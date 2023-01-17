import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DSCSITP/cubit/auth/auth_cubit.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignedOutState) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Options",
                        style: TextStyle(fontSize: 21, color: Colors.white)),
                    SizedBox(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "RegId: ${FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.uid.toString() : null}",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              "Email: ${FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.email.toString() : null}",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            )
                          ]),
                    )
                  ],
                )),
            ListTile(
              title: const Text(
                "Log Out",
              ),
              onTap: () async {
                await context.read<AuthCubit>().signOut();
                // Navigator.pop(context);
                // Navigator.pop(context);
              },
            ),
            // ListTile(
            //   title: FirebaseAuth.instance.currentUser != null
            //       ? Text(
            //           "UID: ${FirebaseAuth.instance.currentUser!.uid.toString()}")
            //       : const Text("null"),
            // ),
            // ListTile(
            //   title: FirebaseAuth.instance.currentUser != null
            //       ? Text(
            //           "Email: ${FirebaseAuth.instance.currentUser!.email.toString()}")
            //       : const Text("null"),
            // )
          ]),
        );
      },
    );
  }
}
