import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/cubit/event/Event_refresh/event_refresh_cubit.dart';
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
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  child: eventCard(index));
            },
          )),
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
                padding: const EdgeInsets.only(top: 25),
                child: InkWell(
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
                            left: 9, right: 9, top: 54, bottom: 12),
                        // events[events.keys.elementAt(index)].toString()
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Column(children: [
                            Text(
                              events[events.keys.elementAt(index)]['name']
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              events[events.keys.elementAt(index)]
                                      ['description']
                                  .toString(),
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
                child: Image.asset(
                  'icons/flutter.png',
                  fit: BoxFit.cover,
                ),
                // backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
