import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/Screens/login_screen.dart';
import 'package:gdsc_app/cubit/auth/auth_cubit.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: const [
        MaterialPage(child: LoginScreen()),
        // MaterialPage(child: MainScreen()),
      ],
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }
}
