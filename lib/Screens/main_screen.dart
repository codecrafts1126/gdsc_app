import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_app/Screens/Navbar%20Pages/events_page.dart';
import 'package:gdsc_app/Screens/Navbar%20Pages/news_page.dart';
import 'package:gdsc_app/Screens/Navbar%20Pages/settings_page.dart';
import 'package:gdsc_app/Widgets/add_event_bottom_sheet.dart';
import 'package:gdsc_app/Widgets/custom_drawer.dart';

import 'package:gdsc_app/Widgets/custom_navbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/cubit/event/Event_refresh/event_refresh_cubit.dart';
import 'package:gdsc_app/cubit/nav_bar/navbar_cubit.dart';
import 'package:gdsc_app/networkVars.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavbarCubit, NavbarState>(
        builder: (context, state) {
          if (state is NavbarEventsState) {
            return const EventsPage();
          } else if (state is NavbarNewsState) {
            return const NewsPage();
          } else if (state is NavbarSettingsState) {
            return const SettingsPage();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      appBar: customAppBar(),
      bottomNavigationBar: const CustomNavbar(),
      drawerEdgeDragWidth: 30,
      resizeToAvoidBottomInset: false,
      floatingActionButton: BlocBuilder<NavbarCubit, NavbarState>(
        builder: (context, state) {
          if (state is NavbarEventsState && roles.contains('EventManager')) {
            return addEventButton(context);
          } else {
            return Container();
          }
        },
      ),
      drawer: const CustomDrawer(),
    );
  }

  PreferredSizeWidget customAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 1,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.developer_board_off_outlined),
            SizedBox(width: 10),
            Text("GDSC")
          ]),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shadowColor: Colors.transparent,
    );
  }

  Widget addEventButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            enableDrag: true, // <----------- value to change when state changes
            isDismissible:
                true, // <----------- value to change when state changes
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            builder: (context) {
              return const AddEventBottomSheet();
            });
      },
      elevation: 1,
      backgroundColor: Colors.green[300],
      child: const Icon(Icons.add),
    );
  }
}
