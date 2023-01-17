import 'package:DSCSITP/Screens/modify_user_data_screen.dart';
import 'package:DSCSITP/cubit/auth/auth_cubit.dart';
import 'package:DSCSITP/cubit/data_collection/data_collection_cubit.dart';
import 'package:DSCSITP/utils/network_vars.dart';
import 'package:DSCSITP/utils/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: const [
          SizedBox(height: 9),
          ProfileSection(),
          SizedBox(height: 18),
          ThemesSection(),
        ],
      ),
    );
  }
}

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  String? address = FirebaseAuth.instance.currentUser?.photoURL;

  void showEditProfileScreen() {
    Navigator.push(
        context, customSlideTransitionDown(const ModifyUserDataScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataCollectionCubit, DataCollectionState>(
      listener: (context, state) async {
        if (state is DataCollectedState) {
          await context
              .read<AuthCubit>()
              .getUserInfo()
              .then((value) => setState(() {}));
          // DOES NOT SETSTATE WORK FIX THIS!!!!!--------------------------------------
        }
      },
      child: profileWidget(),
    );
  }

  Widget profileWidget() {
    return SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.bottomRight, children: [
              Card(
                  color: Colors.blueGrey[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            "Profile",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 33,
                                fontWeight: FontWeight.w200),
                          ),
                          const SizedBox(height: 3),
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey[50],
                            radius: 60,
                            child: (address == null)
                                ? ClipOval(
                                    child: Image.asset('icons/default_pfp.png',
                                        fit: BoxFit.cover))
                                : ClipOval(
                                    child: Image.network(
                                      address!,
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
                          const SizedBox(height: 3),
                          dataItem("Name", userDetails['name']),
                          const SizedBox(height: 15),
                          dataItem("Branch", userDetails['branch']),
                          const SizedBox(height: 15),
                          dataItem("PRN", userDetails['prn']),
                          const SizedBox(height: 15),
                          dataItem(
                              "Phone Number", "+91 ${userDetails['number']}"),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: 57,
                width: 57,
                child: FloatingActionButton(
                  onPressed: () {
                    showEditProfileScreen();
                  },
                  elevation: 3,
                  highlightElevation: 0,
                  backgroundColor: Colors.blueGrey[100],
                  foregroundColor: Colors.black,
                  child: const Icon(Icons.edit),
                ),
              )
            ]),
          ],
        ));
  }

  Widget dataItem(tag, data) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(
        tag,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.w300),
      ),
      Text(
        data,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
      )
    ]);
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
    return Card(
        color: Colors.blueGrey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Themes",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 33,
                        fontWeight: FontWeight.w200),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    "Coming soon",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 15),
                ])));
  }
}
