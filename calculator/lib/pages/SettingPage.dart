import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/data_management/ManageData.dart';
import 'package:calculator/data_management/Notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// mon - sun
final selectDays = [false, false, false, false, false, false, false];
DateTime selectTime = DateTime.now();

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Settings')),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                width: 200,
                height: 50,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  MyCheckbox(id: 'Sun'),
                  MyCheckbox(id: 'Mon'),
                  MyCheckbox(id: 'Tue'),
                  MyCheckbox(id: 'Wed'),
                  MyCheckbox(id: 'Thu'),
                  MyCheckbox(id: 'Fri'),
                  MyCheckbox(id: 'Sat'),
                ],
              ),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  onDateTimeChanged: (value) {
                    selectTime = value;
                    print(selectTime);
                  },
                  initialDateTime: selectTime,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => const AlertDialog(
                        title: Text('Notification Alert'),
                        content: Text('Updated notification settings :)'),
                        // actions: <Widget>[
                        //   TextButton(
                        //     onPressed: () => Navigator.pop(context, 'Cancel'),
                        //     child: const Text('Cancel'),
                        //   ),
                        //   TextButton(
                        //     onPressed: () => Navigator.pop(context, 'OK'),
                        //     child: const Text('OK'),
                        //   ),
                        // ],
                      ),
                    );
                    NotificationAPI.weeklyNotifications(
                        title: 'ProtoCalculator',
                        body: 'Time to practice nerd.',
                        payload: 'reminder',
                        scheduleDays: selectDays,
                        scheduleTime: selectTime);
                  },
                  child: const Text('Set notifications')),
              ElevatedButton(
                onPressed: () {
                  context.read<CalculatorBloc>().add(Load());
                },
                child: const Text('Back to calculator'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CalculatorBloc>().add(Logout());
                },
                child: const Text('Logout!'),
              ),
            ],
          ),
        ));
  }
}

class MyCheckbox extends StatefulWidget {
  final id;
  const MyCheckbox({Key? key, required this.id}) : super(key: key);

  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return Column(
      children: [
        Text(widget.id),
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              if (widget.id == 'Sun') {
                selectDays[6] = !selectDays[6];
              } else if (widget.id == 'Mon') {
                selectDays[0] = !selectDays[0];
              } else if (widget.id == 'Tue') {
                selectDays[1] = !selectDays[1];
              } else if (widget.id == 'Wed') {
                selectDays[2] = !selectDays[2];
              } else if (widget.id == 'Thu') {
                selectDays[3] = !selectDays[3];
              } else if (widget.id == 'Fri') {
                selectDays[4] = !selectDays[4];
              } else if (widget.id == 'Sat') {
                selectDays[5] = !selectDays[5];
              }
              print('Current checklist: $selectDays');
              isChecked = value!;
            });
          },
        ),
      ],
    );
  }
}
