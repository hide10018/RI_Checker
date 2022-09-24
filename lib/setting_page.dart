import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:transport_predict_app/main.dart';
import 'package:transport_predict_app/language_change.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool switch_value = false;//トグルスイッチのオンオフ描画用

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).settings,
          style: TextStyle(color: Theme.of(context).disabledColor)),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
                title: Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: Icon(Icons.language),
                    title: Text(AppLocalizations.of(context).language),
                    value: Text(AppLocalizations.of(context).japanese),
                    onPressed: (context){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => language_changePage())
                      );
                    }
                  ),
                SettingsTile.switchTile(
                  onToggle: (bool value) {
                    setState(() {
                      switch_value = Provider.of<MyTheme>(context, listen: false).toggle();
                      print(switch_value);
                    });
                  },
                  initialValue: switch_value,
                  leading: Icon(Icons.dark_mode),
                  title: Text(AppLocalizations.of(context).dark_mode),
                ),
              ]
            )
            // SettingsSectionを並べていく。
          ],
        )
    );
  }
}



