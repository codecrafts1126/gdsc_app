import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/Models/domain_model.dart';
import 'package:gdsc_app/Widgets/edit_event_bottom_sheet.dart';
import 'package:gdsc_app/cubit/event/Event_delete/event_delete_cubit.dart';
import 'package:gdsc_app/cubit/event/Event_refresh/event_refresh_cubit.dart';
import 'package:gdsc_app/date_time_utils.dart';
import 'package:gdsc_app/network_vars.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventRefreshCubit>().refreshEventData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventRefreshCubit, EventRefreshState>(
      listener: (context, state) {
        if (state is EventRefreshErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red[300], content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is EventRefreshProcessingState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const EventsPageListView();
        }
      },
    );
  }
}

class EventsPageListView extends StatefulWidget {
  const EventsPageListView({
    super.key,
  });

  @override
  State<EventsPageListView> createState() => _EventsPageListViewState();
}

class _EventsPageListViewState extends State<EventsPageListView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<EventRefreshCubit>().refreshEventData();
      },
      child: Container(
        color: Colors.grey[50],
        child: ListView.builder(
          itemCount: sortedEvents.length,
          itemBuilder: (context, index) {
            sortedEvents = Map.fromEntries(events.entries.toList()
              ..sort((e1, e2) => e1.value['date'].compareTo(e2.value['date'])));

            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                child: eventCard(index));
          },
        ),
      ),
    );
  }

  Widget eventCard(int index) {
    return Padding(
      padding: EdgeInsets.only(top: ((index == 0) ? 12 : 0)),
      child: Container(
        // color: Colors.red,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 18),
                child: InkWell(
                  onTap: () {},
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18))),
                    elevation: 3,
                    color: Colors.blueGrey[100],
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 9, right: 9, top: 9, bottom: 12),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Column(children: [
                            SizedBox(
                              height: 54,
                              width: double.maxFinite,
                              // color: Colors.red,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (roles.contains("EventManager"))
                                      popUpDialogueButton(index),
                                  ]),
                            ),
                            Text(
                              sortedEvents[sortedEvents.keys.elementAt(index)]
                                      ['name']
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              sortedEvents[sortedEvents.keys.elementAt(index)]
                                      ['description']
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              "Venue: ${sortedEvents[sortedEvents.keys.elementAt(index)]['venue'].toString()}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              "Date: ${writableDateTimeToReadableDateTime(
                                sortedEvents[sortedEvents.keys.elementAt(index)]
                                        ['date']
                                    .toString(),
                              )}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              "Start Time: ${stringToTime(
                                sortedEvents[sortedEvents.keys.elementAt(index)]
                                        ['startTime']
                                    .toString(),
                              )}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              "End Time: ${stringToTime(
                                sortedEvents[sortedEvents.keys.elementAt(index)]
                                        ['endTime']
                                    .toString(),
                              )}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]),
                        )),
                  ),
                )),
            Material(
              elevation: 3,
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 36,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 33,
                    child: domainModel[sortedEvents.values
                        .elementAt(index)['domain']
                        .toString()]
                    // backgroundColor: Colors.black,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget popUpDialogueButton(int index) {
    return PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Edit Event'),
                  leading: const Icon(Icons.edit_outlined),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await showModalBottomSheet(
                        context: context,
                        enableDrag:
                            true, // <----------- value to change when state changes
                        isDismissible:
                            true, // <----------- value to change when state changes
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        builder: (context) {
                          return EditEventBottomSheet(index: index);
                        });
                  },
                ),
              ),
              PopupMenuItem<String>(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Delete Event'),
                  leading: BlocBuilder<EventDeleteCubit, EventDeleteState>(
                    builder: (context, state) {
                      if (state is EventDeleteProcessingState) {
                        return const CircularProgressIndicator();
                      } else {
                        return Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red[400],
                        );
                      }
                    },
                  ),
                  onTap: () async {
                    await context
                        .read<EventDeleteCubit>()
                        .deleteEvent(events.keys.elementAt(index).toString())
                        .then((value) => Navigator.of(context).pop())
                        .then((value) async => await context
                            .read<EventRefreshCubit>()
                            .refreshEventData());
                  },
                ),
              ),
            ]);
  }
}
