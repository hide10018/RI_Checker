import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class setting_page extends StatefulWidget{
  const setting_page({Key? key}) : super(key: key);
  // static const keyDarkMode = 'key-dark-mode';
  @override
  _setting_page createState() => _setting_page();
}

class _setting_page extends State<setting_page> {
  static const keyDarkMode = 'key-dark-mode';

  @override
  Widget build(BuildContext context) => (
    buildDarkMode()
  );

  Widget buildDarkMode() => SwitchSettingsTile(
      settingKey: keyDarkMode,
    leading: Icon(Icons.dark_mode),
    title: 'Dark Mode',
    onChange: (_){},
      );


}