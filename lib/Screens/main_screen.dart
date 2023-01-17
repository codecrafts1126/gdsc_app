import 'package:DSCSITP/cubit/data_collection/data_collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:DSCSITP/Screens/Navbar%20Pages/events_page.dart';
import 'package:DSCSITP/Screens/Navbar%20Pages/news_page.dart';
import 'package:DSCSITP/Screens/Navbar%20Pages/settings_page.dart';
import 'package:DSCSITP/Widgets/add_event_bottom_sheet.dart';
import 'package:DSCSITP/Widgets/custom_drawer.dart';

import 'package:DSCSITP/Widgets/custom_navbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DSCSITP/cubit/nav_bar/navbar_cubit.dart';
import 'package:DSCSITP/utils/network_vars.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    if (userDetails['name'] == null ||
        (userDetails['name'] as String).trim() == "") {
      context.read<DataCollectionCubit>().showDataCollectionScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    // globalContext = context;
    return SafeArea(
      child: Scaffold(
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
            if (state is NavbarEventsState &&
                (userDetails['roles'] as List<dynamic>)
                    .contains('EventManager')) {
              return addEventButton(context);
            } else {
              return Container();
            }
          },
        ),
        drawer: const CustomDrawer(),
      ),
    );
  }

  PreferredSizeWidget customAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 3,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(Icons.developer_board_off_outlined),
            SizedBox(
              height: 20,
              child: Image.asset(
                "icons/dsc_logo.png",
              ),
            ),
            // SizedBox(width: 10),
            // Text(
            //   "Developers",
            //   style: TextStyle(color: Colors.grey[600]),
            // )
          ]),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shadowColor: Colors.black,
    );
  }

  Widget addEventButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showModalBottomSheet(
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
      elevation: 3,
      highlightElevation: 0,
      backgroundColor: Colors.blueGrey[100],
      child: const Icon(Icons.add_rounded, color: Colors.black),
    );
  }
}
