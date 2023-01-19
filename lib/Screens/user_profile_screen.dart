import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final String name;
  final String branch;
  final String prn;
  final String number;
  final String email;
  final String pfp;
  const UserProfileScreen(
      {super.key,
      required this.name,
      required this.branch,
      required this.prn,
      required this.number,
      required this.email,
      required this.pfp});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "User Profile",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),
              )
            ],
          ),
          elevation: 3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.black,
        ),
        // body: EventParticipantsScrollable(eid: widget.eid),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              const SizedBox(height: 9),
              profileSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileSection() {
    return Card(
        color: Colors.blueGrey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                // Text(
                //   "Profile",
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //       color: Colors.grey[700],
                //       fontSize: 33,
                //       fontWeight: FontWeight.w200),
                // ),
                // const SizedBox(height: 3),
                CircleAvatar(
                  backgroundColor: Colors.blueGrey[50],
                  radius: 60,
                  child: (widget.pfp == "null")
                      ? ClipOval(
                          child: Image.asset('icons/default_pfp.png',
                              fit: BoxFit.cover))
                      : ClipOval(
                          // child: Image.network(
                          //   widget.pfp,
                          //   fit: BoxFit.cover,
                          //   frameBuilder: (context, child, frame,
                          //       wasSynchronouslyLoaded) {
                          //     return child;
                          //   },
                          //   loadingBuilder: (context, child, loadingProgress) {
                          //     if (loadingProgress == null) {
                          //       return child;
                          //     } else {
                          //       return const Center(
                          //         child: CircularProgressIndicator(),
                          //       );
                          //     }
                          //   },
                          // ),
                          child: FadeInImage.assetNetwork(
                            image: widget.pfp,
                            placeholder: 'icons/default_pfp.png',
                            fadeInDuration: const Duration(milliseconds: 1),
                            fadeOutDuration: const Duration(milliseconds: 1),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 3),
                dataItem("Name", widget.name),
                const SizedBox(height: 15),
                dataItem("Branch", widget.branch),
                const SizedBox(height: 15),
                dataItem("PRN", widget.prn),
                const SizedBox(height: 15),
                dataItem("Email", "${widget.email}"),
                const SizedBox(height: 15),
                dataItem("Phone Number", "+91 ${widget.number}"),
                const SizedBox(height: 18),
              ],
            ),
          ),
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
