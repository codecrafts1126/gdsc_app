import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/app_navigator.dart';
import 'package:gdsc_app/cubit/auth/auth_cubit.dart';
import 'package:gdsc_app/cubit/event/Event_delete/event_delete_cubit.dart';
import 'package:gdsc_app/cubit/event/Event_edit/event_edit_cubit.dart';
import 'package:gdsc_app/cubit/event/Event_participant/event_participant_cubit.dart';
import 'package:gdsc_app/cubit/event/Event_refresh/event_refresh_cubit.dart';
import 'package:gdsc_app/cubit/event/Event_register/event_register_cubit.dart';
import 'package:gdsc_app/cubit/nav_bar/navbar_cubit.dart';
import 'package:gdsc_app/cubit/news/news_cubit.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GDSC App',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavbarCubit(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => EventRefreshCubit(),
          ),
          BlocProvider(
            create: (context) => EventRegisterCubit(),
          ),
          BlocProvider(
            create: (context) => EventEditCubit(),
          ),
          BlocProvider(
            create: (context) => EventParticipantCubit(),
          ),
          BlocProvider(
            create: (context) => EventDeleteCubit(),
          ),
          BlocProvider(
            create: (context) => NewsCubit(),
          ),
        ],
        child: const AppNavigator(),
      ),
    );
  }
}
