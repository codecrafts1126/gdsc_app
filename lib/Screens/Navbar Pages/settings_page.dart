import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[200],
      child: Center(
        child: Text("Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[850],
                fontSize: 30,
                fontWeight: FontWeight.w200)),
      ),
    );
  }
}
