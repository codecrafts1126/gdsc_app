import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DSCSITP/Widgets/email_text_input.dart';
import 'package:DSCSITP/cubit/auth/auth_cubit.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
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
                      Text("Lost?😔",
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 30,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 9),
                      Text(
                        "Reset your password now",
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
                    ]),
                    SizedBox(
                      height: 51,
                      width: double.maxFinite,
                      child: SendMailButton(emailController: emailController),
                    ),
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

class SendMailButton extends StatelessWidget {
  const SendMailButton({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await context.read<AuthCubit>().sendResetPassword(
                emailController.text.trim(),
              );
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
              return const Text("Send Reset Password Mail");
            }
          },
        ));
  }
}
