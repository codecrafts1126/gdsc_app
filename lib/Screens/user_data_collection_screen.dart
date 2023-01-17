import 'package:DSCSITP/Models/branch_model.dart';
import 'package:DSCSITP/Models/user_data_model.dart';
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
  final TextEditingController phoneController = TextEditingController();
  String branchInitValue = 'Branch';
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
                          textAlign: TextAlign.center,
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
                            hintText: "Full Name",
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
                            controller: phoneController,
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
                      child: ConfirmDataButton(
                        nameController: nameController,
                        prnController: prnController,
                        phoneController: phoneController,
                        branch: branchInitValue,
                      ),
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
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            border: const OutlineInputBorder(),
            // hintText: widget.hintText,
          ),
          elevation: 3,
          menuMaxHeight: 450,
          isExpanded: true,
          hint: const Text('Branch'),
          items: branchModel.map((String branch) {
            return DropdownMenuItem<String>(
              value: branch,
              child: Text(
                branch,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              branchInitValue = value!;
            });
          },
        ),
      ),
    );
  }
}

class ConfirmDataButton extends StatelessWidget {
  const ConfirmDataButton({
    super.key,
    required this.nameController,
    required this.prnController,
    required this.phoneController,
    required this.branch,
  });

  final TextEditingController nameController;
  final TextEditingController prnController;
  final TextEditingController phoneController;
  final String branch;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          UserDataModel data = UserDataModel(
              name: nameController.text.toString().trim(),
              prn: prnController.text.toString().trim(),
              phoneNumber: phoneController.text.toString().trim(),
              branch: branch);
          await context.read<DataCollectionCubit>().updateUserDetails(data);
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
              nameController.clear();
              prnController.clear();
              phoneController.clear();

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
