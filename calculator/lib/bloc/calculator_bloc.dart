import 'package:bloc/bloc.dart';
import 'package:calculator/data_management/ManageData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../data_management/UserPreferences.dart';
import '../models/CalculatorModel.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
part 'calculator_event.dart';
part 'calculator_state.dart';

enum Buttons {
  seven,
  eight,
  nine,
  mult,
  four,
  five,
  six,
  div,
  one,
  two,
  three,
  sub,
  clear,
  zero,
  eq,
  add,
}

extension GetVal on Buttons {
  String get value {
    switch (this) {
      case Buttons.one:
        return '1';
      case Buttons.two:
        return '2';
      case Buttons.three:
        return '3';
      case Buttons.four:
        return '4';
      case Buttons.five:
        return '5';
      case Buttons.six:
        return '6';
      case Buttons.seven:
        return '7';
      case Buttons.eight:
        return '8';
      case Buttons.nine:
        return '9';
      case Buttons.zero:
        return '0';
      case Buttons.clear:
        return 'C';
      case Buttons.mult:
        return 'x';
      case Buttons.div:
        return '/';
      case Buttons.sub:
        return '-';
      case Buttons.add:
        return '+';
      case Buttons.eq:
        return '=';
    }
  }
}

enum LoginMethod {
  google,
  apple,
  anon,
  loggedInPreviously,
}

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  User? user;
  String? _op;
  String? _prev;
  String? _curr;
  LoginMethod? method;

  CalculatorModel _update({required double num}) {
    return CalculatorModel(result: num);
  }

  double _eval({required String op, required String x, required String y}) {
    double res;

    if (op == 'x') {
      res = (double.parse(x) * double.parse(y));
    } else if (op == '/') {
      res = (double.parse(x) / double.parse(y));
    } else if (op == '-') {
      res = (double.parse(x) - double.parse(y));
    } else {
      res = (double.parse(x) + double.parse(y));
    }

    if (method == LoginMethod.anon) {
      UserPreferences.setResult(res);
      UserPreferences.addHistory(
          "${double.parse(x)} $op ${double.parse(y)} = $res");
    } else {
      final DateTime date = DateTime.now();

      // To save history
      final userCalculation = <String, dynamic>{
        "x": double.parse(x),
        'operation': op,
        'y': double.parse(y),
        "result": res,
      };

      ManageData.update(userCalculation, user!.email!, date);
    }

    return res;
  }

  Future _googleLogin() async {
    final googleSignIn = GoogleSignIn();

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future _appleLogin() async {
    // authenticate login
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oAuthProvider = OAuthProvider('apple.com');

    final newCred = oAuthProvider.credential(
        accessToken: credential.authorizationCode,
        idToken: credential.identityToken);

    await FirebaseAuth.instance.signInWithCredential(newCred);
  }

  Future _unsignedLogin() async {
    String? user = UserPreferences.getUser();

    if (user == null) {
      var uuid = Uuid();

      // Generate a v4 (random) id
      UserPreferences.setUser(
          uuid.v4()); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
    }
  }

  // Initializes the calculator
  CalculatorBloc() : super(CalculatorInitial()) {
    on<OnPress>((event, emit) {
      if (state is CalculatorLoaded) {
        final state = this.state as CalculatorLoaded;

        // Make new calculator
        CalculatorModel? newCalc;

        switch (Buttons.values[event.buttonIndex]) {
          case Buttons.mult:
          case Buttons.div:
          case Buttons.sub:
          case Buttons.add:

            /// Op
            {
              if (_prev != null && _op != null && _curr != null) {
                double res = _eval(op: _op!, x: _prev!, y: _curr!);
                newCalc = _update(num: res);
                _prev = res.toString();
                _curr = null;
              } else {
                _prev = state.calculator.result.toString();
                _curr = null;
              }
              _op = Buttons.values[event.buttonIndex].value;
              break;
            }

          case Buttons.eq:
            // Eval
            {
              if (_prev != null && _op != null && _curr != null) {
                newCalc = _update(num: _eval(op: _op!, x: _prev!, y: _curr!));
                _op = _prev = _curr = null;
              }
              break;
            }

          case Buttons.clear:
            // Reset
            {
              newCalc = _update(num: 0);
              _op = _prev = _curr = null;
              break;
            }

          default:
            // General buttons
            {
              String newVal;
              if (_op == null) {
                newVal = (_prev ?? 0).toString() +
                    Buttons.values[event.buttonIndex].value;
                _prev = newVal;
              } else {
                newVal = (_curr ?? 0).toString() +
                    Buttons.values[event.buttonIndex].value;
                _curr = newVal;
              }
              newCalc = _update(num: double.parse(newVal));
              break;
            }
        }

        emit(CalculatorLoaded(
            calculator: (newCalc ?? state.calculator),
            lightMode: state.lightMode));
      }
    });

    on<Initialize>((event, emit) async {
      await Future<void>.delayed(const Duration(seconds: 2));
      emit(CalculatorLogin());
    });

    on<Login>(((event, emit) async {
      // Login based on method chosen
      method = event.method;
      if (method == LoginMethod.google) {
        await _googleLogin();
      } else if (method == LoginMethod.apple) {
        await _appleLogin();
      } else if (method == LoginMethod.anon) {
        await _unsignedLogin();
        print('No authentication required.');
      }

      emit(CalculatorLoading(method: event.method));
    }));

    on<Logout>(((event, emit) async {
      // if (type == SignInType.google) {
      //   final googleSignIn = GoogleSignIn();
      //   await googleSignIn.disconnect();
      // } else if (type == SignInType.apple) {
      //   print('Signing out from apple device!');
      // }
      FirebaseAuth.instance.signOut();
      emit(CalculatorLogin());
    }));

    on<Load>(((event, emit) async {
      // Clear previous inputs
      _curr = _op = _prev = null;

      double? result;
      String? lightMode;
      if (method == LoginMethod.anon) {
        lightMode = UserPreferences.getLightMode();
        emit(CalculatorLoaded(
          calculator:
              CalculatorModel(result: (UserPreferences.getResult() ?? 0)),
          lightMode: lightMode ?? 'Light Mode',
        ));
      } else {
        user = FirebaseAuth.instance.currentUser;
        result = await ManageData.getRecent(user!.email!);
        lightMode = UserPreferences.getLightMode();
        emit(CalculatorLoaded(
            calculator: CalculatorModel(result: (result ?? 0)),
            lightMode: lightMode ?? 'Light Mode'));
      }
    }));

    on<UpdateLightMode>(((event, emit) async {
      CalculatorLoaded oldState = this.state as CalculatorLoaded;

      await UserPreferences.setLightMode(event.lightMode);
      emit(CalculatorLoaded(
          calculator: oldState.calculator, lightMode: event.lightMode));
    }));
  }
}
