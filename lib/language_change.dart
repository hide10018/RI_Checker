import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:transport_predict_app/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transport_predict_app/setting_page.dart';

class language_changePage extends StatefulWidget {
  const language_changePage({Key? key}) : super(key: key);




  @override
  State<language_changePage> createState() => _language_changeState();

}

class _language_changeState extends State<language_changePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).settings,
          style: TextStyle(color: Theme.of(context).disabledColor)),
          iconTheme:
          IconThemeData(
            color: Theme.of(context).disabledColor,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
                title: Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile(
                      leading: Icon(Icons.language),
                      title: Text(AppLocalizations.of(context).english),
                      onPressed: (context)  {

                          Provider.of<Local_Change>(context,listen: false).changeLocale(Local_Change.en());

                      }
                  ),

                  SettingsTile(
                      leading: Icon(Icons.language),
                      title: Text(AppLocalizations.of(context).japanese),
                      onPressed: (context) {
                        Provider.of<Local_Change>(context,listen: false).changeLocale(Local_Change.jp());
                      }
                  ),

                  SettingsTile(
                      leading: Icon(Icons.language),
                      title: Text(AppLocalizations.of(context).japanese),
                      onPressed: (context) {
                        Provider.of<Local_Change>(context,listen: false).changeLocale(Local_Change.jp());
                      }
                  ),
                ]
            )
            // SettingsSectionを並べていく。
          ],
        )
    );
  }
}

