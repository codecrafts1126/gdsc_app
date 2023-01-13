import 'package:DSCSITP/Models/branch_model.dart';
import 'package:DSCSITP/Widgets/email_text_input.dart';
import 'package:DSCSITP/cubit/data_collection/data_collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataCollectionScreen extends StatefulWidget {
  const UserDataCollectionScreen({super.key});

  @override
  State<UserDataCollectionScreen> createState() =>
      _UserDataCollectionScreenState();
}

class _UserDataCollectionScreenState extends State<UserDataCollectionScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController prnController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String BranchInitValue = 'Branch';
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
                      // Text("Welcome!🥳",
                      // Text("Look at you go!🥳",
                      Text("Look who's here!🥳",
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 30,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 9),
                      Text(
                        "Tell us who you are",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: 21,
                            overflow: TextOverflow.visible,
                            fontWeight: FontWeight.w100),
                      ),
                    ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EmailTextInput(
                            controller: nameController,
                            hintText: "Name",
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          EmailTextInput(
                            controller: prnController,
                            hintText: "PRN",
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          EmailTextInput(
                            controller: phoneNumberController,
                            hintText: "Phone number (without +91)",
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          branchDropDown()
                        ]),
                    SizedBox(
                      height: 51,
                      width: double.maxFinite,
                      child: SendMailButton(emailController: nameController),
                    ),
                    // FloatingActionButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   foregroundColor: Colors.grey[850],
                    //   elevation: 1,
                    //   backgroundColor: Colors.blueGrey[50],
                    //   child: const Icon(Icons.arrow_back),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget branchDropDown() {
    return DropdownButtonHideUnderline(
      child: SizedBox(
        width: double.maxFinite,
        child: DropdownButtonFormField(
          borderRadius: BorderRadius.circular(18),
          elevation: 3,
          menuMaxHeight: 450,
          hint: const Text('Branch'),
          // value: domainInitValue,
          items: branchModel.map((String domain) {
            // ------------------------------------- FIX THIS ERROR DROPDOWNMENUITEM OVERFLOW ----------------------------------------
            return DropdownMenuItem<String>(
              value: domain,
              child: Expanded(
                child: Text(
                  domain,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              BranchInitValue = value!;
            });
          },
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
          await context.read<DataCollectionCubit>().addUserDetails();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        // child: Text("Confirm Details"),
        child: BlocConsumer<DataCollectionCubit, DataCollectionState>(
          listener: (context, state) {
            if (state is DataCollectedState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green[300],
                  content: Text(state.message)));
              emailController.clear();

              Navigator.pop(context);
            } else if (state is DataCollectionErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red[300],
                  content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is DataCollectionProcessingState) {
              return const CircularProgressIndicator();
            } else {
              return const Text("Confirm Details");
            }
          },
        ));
  }
}
