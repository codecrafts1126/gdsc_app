import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/cubit/event/Event_refresh/event_refresh_cubit.dart';
import 'package:gdsc_app/networkVars.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Random().nextInt(2));
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
          return EventsPageListView();
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
                  child: Card(
                      elevation: 3,
                      color: Colors.blueGrey[100],
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(events[events.keys.elementAt(index)]
                              .toString()))));
            },
          )),
    );
  }
}
