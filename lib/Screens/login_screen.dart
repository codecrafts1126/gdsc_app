import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/Screens/main_screen.dart';
import 'package:gdsc_app/Screens/recover_password_screen.dart';
import 'package:gdsc_app/Screens/signup_screen.dart';
import 'package:gdsc_app/Widgets/elevated_signin_button.dart';
import 'package:gdsc_app/Widgets/email_text_input.dart';
import 'package:gdsc_app/Widgets/password_text_input.dart';

import '../cubit/auth/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().autoLoginStateCall();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text("Hello again!",
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: 30,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(height: 9),
                    Text(
                      "Welcome back \nyou've been missed",
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
                    SizedBox(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, right: 12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RecoverPasswordScreen(),
                                ));
                          },
                          child: const Text(
                            "Recover Password",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 51,
                    width: double.maxFinite,
                    child: LoginButton(
                        emailController: emailController,
                        passwordController: passwordController),
                  ),
                  Column(children: [
                    const Text("Or continue with"),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member?"),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ));
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.read<AuthCubit>().logInEmailPass(
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
            if (state is LoggedInState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ));
              emailController.clear();
              passwordController.clear();
            } else if (state is LogInErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red[300],
                  content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ProcessingState) {
              return const CircularProgressIndicator();
            } else {
              return const Text("Sign In");
            }
          },
        ));
  }
}
