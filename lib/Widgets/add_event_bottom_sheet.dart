import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/Models/event_model.dart';
import 'package:gdsc_app/cubit/event/Event_register/event_register_cubit.dart';
import 'custom_textfield.dart';

class AddEventBottomSheet extends StatefulWidget {
  const AddEventBottomSheet({super.key});

  @override
  State<AddEventBottomSheet> createState() => _AddEventBottomSheetState();
}

class _AddEventBottomSheetState extends State<AddEventBottomSheet> {
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
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
              ? (startTime != null
                  ? ("Start Time is set to ${startTime?.hourOfPeriod} : ${startTime?.minute} ${startTime?.period.name}")
                  : "Start Time Not Selected")
              : (endTime != null
                  ? ("End time is set to ${endTime?.hour} : ${endTime?.minute} ${endTime?.period.name}")
                  : "End time Not Selected"), //label text of field
        ),
        readOnly: true, // when true user cannot edit text
        onTap: () async {
          if (isStart) {
            startTime = (await showTimePicker(
              initialTime: TimeOfDay.now(),
              context: context,
            ));
          } else {
            endTime = (await showTimePicker(
              initialTime: TimeOfDay.now(),
              context: context,
            ));
          }

          setState(() {});
        });
  }

  Widget dayPicker() {
    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return TextField(
        //editing controller of this TextField

        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_today), //icon of text field
          hintText: selectedDate != null
              ? ("Event date is on ${selectedDate?.day} ${months[(selectedDate?.month)! - 1]} ${selectedDate?.year}")
              : "Event date is Not selected", //label text of field
        ),
        readOnly: true, // when true user cannot edit text
        onTap: () async {
          selectedDate = (await showDatePicker(
              context: context,
              initialDate: DateTime.now(), //get today's date
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2100)));
          setState(() {});
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
            CustomTextField(controller: eventName, hintText: "Event name"),
            const SizedBox(height: 12),
            CustomTextField(controller: eventDescription, hintText: "Venue"),
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
              eventName: eventName.toString(),
              eventDescripion: eventDescription.toString(),
              eventDate: selectedDate.toString(),
              eventStartTime: startTime.toString(),
              eventEndTime: endTime.toString());
          await context.read<EventRegisterCubit>().registerEvent(data);
          clearControllers();
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
