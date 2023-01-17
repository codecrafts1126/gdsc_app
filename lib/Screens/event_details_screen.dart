import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DSCSITP/Models/domain_model.dart';
import 'package:DSCSITP/cubit/event/Event_participant/event_participant_cubit.dart';
import 'package:DSCSITP/cubit/event/Event_refresh/event_refresh_cubit.dart';
import 'package:DSCSITP/utils/date_time_utils.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventData;
  final eid;
  const EventDetailsScreen(
      {super.key, required this.EventData, required this.eid});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.black,
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(children: [
              Material(
                elevation: 3,
                child: Container(
                  height: 45,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),
              EventDataScrollable(eventData: widget.EventData),
              const SizedBox(height: 21),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 42,
                  height: 60,
                  child: InterestedButton()),
              const SizedBox(height: 10)
            ]),
            Positioned(
              child: Material(
                elevation: 3,
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 45,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 43,
                      child: domainModel[widget.EventData['domain'].toString()]
                      // backgroundColor: Colors.black,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget InterestedButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(75),
            )),
        onPressed: () async {
          if (widget.EventData['participants']
              .contains(FirebaseAuth.instance.currentUser?.uid)) {
            await context
                .read<EventParticipantCubit>()
                .removeParticipant(widget.eid)
                .then((value) async =>
                    await context.read<EventRefreshCubit>().refreshEventData());
          } else {
            await context
                .read<EventParticipantCubit>()
                .addParticipant(widget.eid)
                .then((value) async =>
                    await context.read<EventRefreshCubit>().refreshEventData());
          }

          try {
            Navigator.pop(context);
          } catch (e) {}
        },
        child: BlocConsumer<EventParticipantCubit, EventParticipantState>(
          listener: (context, state) {
            if (state is EventParticipantErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[300],
              ));
            } else if (state is EventParticipantAddedState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green[300],
              ));
            } else if (state is EventParticipantRemovedState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green[300],
              ));
            }
          },
          builder: (context, state) {
            if (state is EventParticipantErrorState ||
                state is EventParticipantAddedState ||
                state is EventParticipantRemovedState ||
                state is EventParticipantsLoadedState ||
                state is EventParticipantInitialState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.EventData['participants']
                          .contains(FirebaseAuth.instance.currentUser?.uid)
                      ? "Opt out"
                      : "Become a participant"),
                  const SizedBox(width: 12),
                  Icon(widget.EventData['participants']
                          .contains(FirebaseAuth.instance.currentUser?.uid)
                      ? Icons.person_remove
                      : Icons.person_add),
                ],
              );
            } else if (state is EventParticipantProcessingState) {
              return const CircularProgressIndicator();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
    // child: );
  }
}

class EventDataScrollable extends StatelessWidget {
  final eventData;
  const EventDataScrollable({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(18),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: double.maxFinite,
            // color: Colors.blue,
            child: Column(children: [
              DetailItem(
                tag: "Event",
                data: eventData['name'],
              ),
              DetailItem(
                tag: "Duration",
                data: (stringToDatetime(eventData['startDate']).year ==
                            stringToDatetime(eventData['endDate']).year &&
                        stringToDatetime(eventData['startDate']).month ==
                            stringToDatetime(eventData['endDate']).month &&
                        stringToDatetime(eventData['startDate']).day ==
                            stringToDatetime(eventData['endDate']).day)
                    ? writableDateTimeToReadableDateTime(eventData['startDate'])
                    : "${writableDateTimeToReadableDateTime(eventData['startDate'])} - ${writableDateTimeToReadableDateTime(eventData['endDate'])}",
              ),
              DetailItem(
                tag: "Venue",
                data: eventData['venue'],
              ),
              DetailItem(
                tag: "Start Time",
                data: eventData['startTime'],
              ),
              DetailItem(
                tag: "End Time",
                data: eventData['endTime'],
              ),
              DetailItem(
                tag: "Description",
                data: eventData['description'],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String tag;
  final String data;
  const DetailItem({
    super.key,
    required this.tag,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            tag,
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey[500],
                fontWeight: FontWeight.w300),
          ),
          Text(
            data,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
          )
        ]),
      ),
    );
  }
}
