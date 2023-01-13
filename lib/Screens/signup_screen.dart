import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DSCSITP/cubit/auth/auth_cubit.dart';

import '../Widgets/elevated_signin_button.dart';
import '../Widgets/email_text_input.dart';
import '../Widgets/password_text_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueGrey[50],
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 51, horizontal: 27),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                width: double.maxFinite,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(children: [
                      const SizedBox(height: 15),
                      Text("First time?😏",
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 30,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 9),
                      Text(
                        "Sign up now",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: 21,
                            overflow: TextOverflow.visible,
                            fontWeight: FontWeight.w100),
                      ),
                    ]),
                    Column(children: [
                      EmailTextInput(
                        controller: emailController,
                        hintText: "Enter email",
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      PasswordTextInput(
                          controller: passwordController, hintText: "Password"),
                    ]),
                    SizedBox(
                      height: 51,
                      width: double.maxFinite,
                      child: SignupButton(
                          emailController: emailController,
                          passwordController: passwordController),
                    ),
                    Column(children: [
                      const Text("Or create an account with"),
                      const SizedBox(height: 21),
                      SizedBox(
                        width: double.maxFinite,
                        height: 51,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              ElevatedSignInButton(
                                path: "icons/google.png",
                                mode: 1,
                              ),
                              // SizedBox(width: 12),
                              // ElevatedSignInButton(
                              //   path: "icons/github.png",
                              //   mode: 2,
                              // ),
                            ]),
                        // color: Colors.red,
                      ),
                    ]),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      foregroundColor: Colors.grey[850],
                      elevation: 1,
                      backgroundColor: Colors.blueGrey[50],
                      child: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await context.read<AuthCubit>().signUpEmailPass(
              emailController.text.trim(), passwordController.text.trim());
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SignedUpState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green[300],
                  content: Text(state.message)));
              emailController.clear();
              passwordController.clear();
              Navigator.pop(context);
            } else if (state is SignUpErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red[300],
                  content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ProcessingState) {
              return const CircularProgressIndicator();
            } else {
              return const Text("Register");
            }
          },
        ));
  }
}
