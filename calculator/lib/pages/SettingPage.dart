import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/data_management/Notification.dart';
import 'package:calculator/data_management/UserPreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_permissions/notification_permissions.dart';

// use shared preference instead
late List<String> selectedDays;
late DateTime selectTime;

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String timeString =
        UserPreferences.getTime() ?? DateTime.now().toString();
    selectTime = DateTime.parse(timeString);

    if (UserPreferences.getSchedule() == null) {
      selectedDays = [
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false'
      ];
      UserPreferences.setSchedule(selectedDays);
    } else {
      selectedDays = UserPreferences.getSchedule()!;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Settings')),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                width: 200,
                height: 10,
              ),
              const NotificationSwitch(),
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
  @override
  Widget build(BuildContext context) {
    bool isChecked;
    if (widget.id == 'Sun') {
      isChecked = selectedDays[6] == 'true';
    } else if (widget.id == 'Mon') {
      isChecked = selectedDays[0] == 'true';
    } else if (widget.id == 'Tue') {
      isChecked = selectedDays[1] == 'true';
    } else if (widget.id == 'Wed') {
      isChecked = selectedDays[2] == 'true';
    } else if (widget.id == 'Thu') {
      isChecked = selectedDays[3] == 'true';
    } else if (widget.id == 'Fri') {
      isChecked = selectedDays[4] == 'true';
    } else {
      isChecked = selectedDays[5] == 'true';
    }

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
              final id;
              if (widget.id == 'Sun') {
                selectedDays[6] = (!(selectedDays[6] == 'true')).toString();
                id = 6;
              } else if (widget.id == 'Mon') {
                selectedDays[0] = (!(selectedDays[0] == 'true')).toString();
                id = 0;
              } else if (widget.id == 'Tue') {
                selectedDays[1] = (!(selectedDays[1] == 'true')).toString();
                id = 1;
              } else if (widget.id == 'Wed') {
                selectedDays[2] = (!(selectedDays[2] == 'true')).toString();
                id = 2;
              } else if (widget.id == 'Thu') {
                selectedDays[3] = (!(selectedDays[3] == 'true')).toString();
                id = 3;
              } else if (widget.id == 'Fri') {
                selectedDays[4] = (!(selectedDays[4] == 'true')).toString();
                id = 4;
              } else {
                selectedDays[5] = (!(selectedDays[5] == 'true')).toString();
                id = 5;
              }

              UserPreferences.setSchedule(selectedDays);

              if (value!) {
                print('Notification SET for ${widget.id} at $selectTime');
                NotificationAPI.setWeeklyNotifications(
                    id: id,
                    title: 'ProtoCalculator',
                    body: 'Time to practice nerd.',
                    payload: 'reminder',
                    scheduleTime: selectTime);
              } else {
                print('Notification CLEARED for ${widget.id} at $selectTime');
                NotificationAPI.cancel(id);
              }
              isChecked = value;
            });
          },
        ),
      ],
    );
  }
}

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({Key? key}) : super(key: key);

  @override
  _NotificationSwitchState createState() {
    return _NotificationSwitchState();
  }
}

//TODO
class _NotificationSwitchState extends State<NotificationSwitch>
    with WidgetsBindingObserver {
  bool state = NotificationAPI.permission == PermissionStatus.granted &&
      (UserPreferences.getNotification() ?? true);

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) async {
    print('state = $appState');
    if (appState == AppLifecycleState.resumed) {
      await NotificationAPI.updatePermission();
      print('Updated permissions: ${NotificationAPI.permission}');
      if (NotificationAPI.permission == PermissionStatus.granted) {
        // schedule all
        print('Notification Enabled: RESCHEDULED ALL');
        // Update all valid days
        for (var id = 0; id < 7; id++) {
          if (selectedDays[id] == 'true') {
            NotificationAPI.setWeeklyNotifications(
                id: id,
                title: 'ProtoCalculator',
                body: 'Time to practice nerd.',
                payload: 'reminder',
                scheduleTime: selectTime);
          }
        }
      } else if (NotificationAPI.permission == PermissionStatus.denied) {
        print('Notification Enabled: CLEARED ALL');
        NotificationAPI.cancelAll();
      }

      state = NotificationAPI.permission == PermissionStatus.granted &&
          (UserPreferences.getNotification() ?? true);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blue,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              'Notification Switch',
              style: TextStyle(color: Colors.white),
            ),
            CupertinoSwitch(
              activeColor: Colors.blue[200],
              value: state,
              onChanged: (value) {
                if (NotificationAPI.permission != PermissionStatus.granted) {
                  return;
                }
                if (value) {
                  print('Notification Enabled: RESCHEDULED ALL');
                  // Update all valid days
                  for (var id = 0; id < 7; id++) {
                    if (selectedDays[id] == 'true') {
                      NotificationAPI.setWeeklyNotifications(
                          id: id,
                          title: 'ProtoCalculator',
                          body: 'Time to practice nerd.',
                          payload: 'reminder',
                          scheduleTime: selectTime);
                    }
                  }
                } else {
                  print('Notification Disabled: CLEARED ALL');
                  NotificationAPI.cancelAll();
                }
                state =
                    NotificationAPI.permission == PermissionStatus.granted &&
                        value;

                UserPreferences.setNotification(value);
                setState(() {});
              },
            )
          ]),
        ),
        const SizedBox(height: 20),
        state && NotificationAPI.permission == PermissionStatus.granted
            ? Row(
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
              )
            : const Text(''),
        state && NotificationAPI.permission == PermissionStatus.granted
            ? const PopUpTimePicker()
            : const Text(''),
      ],
    );
  }
}

class PopUpTimePicker extends StatefulWidget {
  const PopUpTimePicker({Key? key}) : super(key: key);

  @override
  _PopUpTimePickerState createState() {
    return _PopUpTimePickerState();
  }
}

class _PopUpTimePickerState extends State<PopUpTimePicker> {
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectTime);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _selectTime(context);
      },
      child: const Text("Choose Time"),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        //global
        final now = DateTime.now();
        final String timeString = DateTime(
                now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute)
            .toString();
        selectTime = DateTime.parse(timeString);
        print(timeString);
        UserPreferences.setTime(timeString);

        // Update all valid days
        for (var id = 0; id < 7; id++) {
          if (selectedDays[id] == 'true') {
            print(id);
            NotificationAPI.setWeeklyNotifications(
                id: id,
                title: 'ProtoCalculator',
                body: 'Time to practice nerd.',
                payload: 'reminder',
                scheduleTime: selectTime);
          }
        }
        NotificationAPI.pendingNotificationRequest();
      });
    }
  }
}
