import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:transport_predict_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class language_changePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _setPrefItems() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('language', ref.read(localeProvider.notifier).state);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settings,
              style: TextStyle(color: Theme.of(context).primaryColor)),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Theme.of(context).disabledColor,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(title: Text('Common'), tiles: <SettingsTile>[
              SettingsTile(
                  leading: Icon(Icons.language),
                  title: Text("English"),
                  onPressed: (context) {
                    ref.read(localeProvider.notifier).state = 'en';
                    _setPrefItems();
                  }),
              SettingsTile(
                  leading: Icon(Icons.language),
                  title: Text("日本語"),
                  onPressed: (context) {
                    ref.read(localeProvider.notifier).state = 'ja';
                    _setPrefItems();
                  }),
              SettingsTile(
                  leading: Icon(Icons.language),
                  title: Text("中文"),
                  onPressed: (context) {
                    ref.read(localeProvider.notifier).state = 'zh';
                    _setPrefItems();
                  }),
              SettingsTile(
                  leading: Icon(Icons.language),
                  title: Text("Español"),
                  onPressed: (context) {
                    ref.read(localeProvider.notifier).state = 'es';
                    _setPrefItems();
                  }),
            ])
            // SettingsSectionを並べていく。
          ],
        ));
  }
}
