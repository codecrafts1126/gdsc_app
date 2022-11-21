import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth/auth_cubit.dart';

class ElevatedSignInButton extends StatelessWidget {
  final String path;
  final int mode;
  const ElevatedSignInButton(
      {super.key, required this.path, required this.mode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.maxFinite,
        width: 66,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Colors.blueGrey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
            onPressed: () async {
              if (mode == 1) {
                await context.read<AuthCubit>().loginGoogle();
              } else if (mode == 2) {
                await context.read<AuthCubit>().loginGithub();
              }
            },
            child: Image.asset(path)));
  }
}
