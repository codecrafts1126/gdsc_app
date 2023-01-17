import 'package:DSCSITP/Screens/user_profile_screen.dart';
import 'package:DSCSITP/utils/network_vars.dart';
import 'package:DSCSITP/utils/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DSCSITP/Models/domain_model.dart';
import 'package:DSCSITP/cubit/event/Event_participant/event_participant_cubit.dart';
import 'package:DSCSITP/cubit/event/Event_refresh/event_refresh_cubit.dart';
import 'package:DSCSITP/utils/date_time_utils.dart';

class EventParticipantsScreen extends StatefulWidget {
  final eid;
  const EventParticipantsScreen({super.key, required this.eid});

  @override
  State<EventParticipantsScreen> createState() =>
      _EventParticipantsScreenState();
}

class _EventParticipantsScreenState extends State<EventParticipantsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<EventParticipantCubit>().getParticipants(widget.eid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Participants",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),
              )
            ],
          ),
          elevation: 3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.black,
        ),
        // body: EventParticipantsScrollable(eid: widget.eid),
        body: BlocConsumer<EventParticipantCubit, EventParticipantState>(
          listener: (context, state) {
            if (state is EventParticipantErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red[300],
                  content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is EventParticipantProcessingState) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (sortedParticipantsDetails.keys.isNotEmpty) {
                return EventParticipantsScrollable(eid: widget.eid);
              } else {
                return const SizedBox(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Text(
                        "Participants will show up here soon",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class EventParticipantsScrollable extends StatelessWidget {
  const EventParticipantsScrollable({super.key, required this.eid});
  final String eid;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<EventParticipantCubit>().getParticipants(eid);
      },
      child: Container(
        color: Colors.grey[50],
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: sortedParticipantsDetails.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                child: participantItem(index, context));
          },
        ),
      ),
    );
  }

  Widget participantItem(int index, BuildContext context) {
    final String pfpUrl =
        sortedParticipantsDetails.values.elementAt(index)['pfp'].toString();
    final String name =
        sortedParticipantsDetails.values.elementAt(index)['name'].toString();
    final String branch =
        sortedParticipantsDetails.values.elementAt(index)['branch'].toString();
    final String prn =
        sortedParticipantsDetails.values.elementAt(index)['prn'].toString();
    final String number =
        sortedParticipantsDetails.values.elementAt(index)['number'].toString();
    // sortedParticipantsDetails.values.elementAt(index).toString()
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          index == 0 ? const SizedBox(height: 12) : const SizedBox(),
          Card(
            color: Colors.blueGrey[50],
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      backgroundColor: Colors.blueGrey[50],
                      radius: 21,
                      child: (pfpUrl == "null")
                          ? ClipOval(
                              child: Image.asset('icons/default_pfp.png',
                                  fit: BoxFit.cover))
                          : ClipOval(
                              child: Image.network(
                                pfpUrl,
                                fit: BoxFit.cover,
                                frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  return child;
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: SizedBox(
                      height: 42,
                      width: 42,
                      child: FloatingActionButton.small(
                        onPressed: () {
                          Navigator.push(
                              context,
                              customSlideTransitionRight(UserProfileScreen(
                                  branch: branch,
                                  name: name,
                                  number: number,
                                  pfp: pfpUrl,
                                  prn: prn)));
                        },
                        elevation: 3,
                        highlightElevation: 0,
                        backgroundColor: Colors.blueGrey[50],
                        foregroundColor: Colors.black,
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
