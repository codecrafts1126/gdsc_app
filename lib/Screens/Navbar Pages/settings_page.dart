import 'package:DSCSITP/utils/network_vars.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: const [
          ProfileSection(),
          ThemesSection(),
        ],
      ),
    );
  }
}

class ThemesSection extends StatefulWidget {
  const ThemesSection({super.key});

  @override
  State<ThemesSection> createState() => _ThemesSectionState();
}

class _ThemesSectionState extends State<ThemesSection> {
  @override
  Widget build(BuildContext context) {
    return // theme stuff
        SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Themes",
          style: TextStyle(
              fontSize: 33, color: Colors.black, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 6),
        Text(
          "Coming Soon...",
          style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w300,
              color: Colors.grey[500]),
        )
      ]),
    );
  }
}

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 9),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Profile",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.w300),
              ),
              FloatingActionButton(
                onPressed: () {},
                elevation: 3,
                highlightElevation: 0,
                backgroundColor: Colors.blueGrey[50],
                foregroundColor: Colors.black,
                child: const Icon(Icons.edit),
              )
            ],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.maxFinite,
          child: Card(
            elevation: 3,
            color: Colors.blueGrey[50],
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    dataItem("Name", userDetails['name']),
                    const SizedBox(height: 12),
                    dataItem("PRN", userDetails['prn']),
                    const SizedBox(height: 12),
                    dataItem("Phone Number", "+91 ${userDetails['number']}"),
                    const SizedBox(height: 12),
                    dataItem("Branch", userDetails['branch']),
                    const SizedBox(height: 15),
                  ],
                )),
          ),
        ),
        SizedBox(height: 21),
      ]),
    );
  }

  Widget dataItem(tag, data) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        tag,
        style: TextStyle(
            fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.w300),
      ),
      Text(
        data,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
      )
    ]);
  }
}
