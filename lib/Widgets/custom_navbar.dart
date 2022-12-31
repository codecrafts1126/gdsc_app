import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:DSCSITP/cubit/nav_bar/navbar_cubit.dart';
import 'package:provider/provider.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  //calls navbarCunit function to change state
  void changePage(BuildContext context, int navbarPageIndex) {
    final navbarCubit = context.read<NavbarCubit>();
    navbarCubit.switchNavbarPage(navbarPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54,
              blurRadius: 4.5,
              offset: Offset(0.0, 0.75),
              blurStyle: BlurStyle.outer)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(75),
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: GNav(
                onTabChange: (value) {
                  changePage(context, value);
                },
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                gap: 9,
                tabBackgroundColor: Colors.grey.shade800,
                tabBorderRadius: 75,
                tabs: const [
                  GButton(
                    icon: Icons.event,
                    text: "Events",
                    padding: EdgeInsets.all(15),
                  ),
                  GButton(
                    icon: Icons.newspaper,
                    text: "News",
                    padding: EdgeInsets.all(15),
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: "Settings",
                    padding: EdgeInsets.all(15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
