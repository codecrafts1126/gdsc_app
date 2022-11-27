import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/Models/event_model.dart';
import 'package:gdsc_app/cubit/event/Event_refresh/event_refresh_cubit.dart';
import 'package:gdsc_app/cubit/event/Event_register/event_register_cubit.dart';
import 'package:gdsc_app/date_time_utils.dart';
import 'custom_textfield.dart';

class AddEventBottomSheet extends StatefulWidget {
  const AddEventBottomSheet({super.key});

  @override
  State<AddEventBottomSheet> createState() => _AddEventBottomSheetState();
}

class _AddEventBottomSheetState extends State<AddEventBottomSheet> {
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  TextEditingController eventVenue = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: SizedBox.expand(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 30, right: 21, left: 21, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bottomSheetBody(),
                SizedBox(
                    width: MediaQuery.of(context).size.width - 42,
                    height: 60,
                    child: confirmButton()),
              ],
            ),
          ),
        ));
  }

  Widget timePicker(bool isStart) {
    return TextField(
        //editing controller of this TextField

        decoration: InputDecoration(
          icon: const Icon(Icons.timelapse), //icon of text field
          hintText: isStart
              ? ("Start Time is set to ${dateTimeToTimeString(startTime)}")
              : ("End time is set to ${dateTimeToTimeString(endTime)}"), //label text of field
        ),
        readOnly: true, // when true user cannot edit text
        onTap: () async {
          if (isStart) {
            var time = (await showTimePicker(
              initialTime: startTime,
              context: context,
            ));
            setState(() {
              if (time != null) {
                startTime = time;
                selectedDate = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, startTime.hour, startTime.minute);
              }
            });
          } else {
            var time = (await showTimePicker(
              initialTime: endTime,
              context: context,
            ));
            setState(() {
              if (time != null) {
                endTime = time;
              }
            });
          }
        });
  }

  Widget dayPicker() {
    return TextField(
        //editing controller of this TextField

        decoration: InputDecoration(
            icon: const Icon(Icons.calendar_today), //icon of text field
            hintText:
                "Event date is on ${dateToStringReadable(selectedDate)}" //label text of field
            ),
        readOnly: true, // when true user cannot edit text
        onTap: () async {
          var date = (await showDatePicker(
              context: context,
              initialDate: selectedDate, //get today's date
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2100)));
          setState(() {
            if (date != null) {
              selectedDate = DateTime(date.year, date.month, date.day,
                  startTime.hour, startTime.minute);
            }
          });
        });
  }

  void clearControllers() {
    eventName.clear();
    eventDescription.clear();
  }

  Widget bottomSheetBody() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SingleChildScrollView(
          // child: Expanded(
          // color: Colors.green,
          // height: 100,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("New Event", style: TextStyle(fontSize: 27)),
            const Divider(),
            const SizedBox(height: 18),
            CustomTextField(
                controller: eventName,
                hintText: "Event name (Ex: Flutter Festival 2023)"),
            const SizedBox(height: 12),
            CustomTextField(
                controller: eventDescription, hintText: "Description"),
            const SizedBox(height: 12),
            CustomTextField(
                controller: eventVenue,
                hintText:
                    "Venue (Ex: Cloud Computing Lab, 4th floor, SIT Base campus"),
            const SizedBox(height: 12),
            dayPicker(),
            const SizedBox(height: 12),
            timePicker(true),
            const SizedBox(height: 12),
            timePicker(false),
          ]),
        ),
      ),
      // ),
    );
  }

  Widget confirmButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(75),
            )),
        onPressed: () async {
          EventModel data = EventModel(
              eventName: eventName.text.toString().trim(),
              eventDescripion: eventDescription.text.toString().trim(),
              eventVenue: eventVenue.text.toString().trim(),
              eventDate: dateToStringWritable(selectedDate),
              eventStartTime: dateTimeToTimeString(startTime).toString().trim(),
              eventEndTime: dateTimeToTimeString(endTime).toString().trim());

          await context.read<EventRegisterCubit>().registerEvent(data).then(
              (value) async => await context
                  .read<EventRefreshCubit>()
                  .refreshEventData()
                  .then((value) => clearControllers()));

          try {
            Navigator.pop(context);
          } catch (e) {}
        },
        child: BlocConsumer<EventRegisterCubit, EventRegisterState>(
          listener: (context, state) {
            if (state is EventRegisterErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[300],
              ));
            } else if (state is EventRegisteredState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green[300],
              ));
            }
          },
          builder: (context, state) {
            if (state is EventRegisterErrorState ||
                state is EventRegisteredState ||
                state is EventRegisterInitialState) {
              return const Text("Confirm");
            } else if (state is EventRegisterProcessingState) {
              return const CircularProgressIndicator();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
