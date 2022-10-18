import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:transport_predict_app/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transport_predict_app/setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
StateProvider<bool> theme1boolProvider = StateProvider((ref) => false);
StateProvider<bool> theme2boolProvider = StateProvider((ref) => false);
StateProvider<bool> theme3boolProvider = StateProvider((ref) => false);


class theme_changePage extends ConsumerWidget{

  bool theme1 = false;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool theme1_change = ref.watch(theme1boolProvider);
    bool theme2_change = ref.watch(theme2boolProvider);
    bool theme3_change = ref.watch(theme3boolProvider);

    _setPrefItems() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('theme', ref.read(themechangeProvider.notifier).state);
      prefs.setBool('theme1', ref.read(theme1boolProvider.notifier).state);
      prefs.setBool('theme2', ref.read(theme2boolProvider.notifier).state);
      prefs.setBool('theme3', ref.read(theme3boolProvider.notifier).state);
    }


    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).settings,
            style: TextStyle(color: Theme.of(context).primaryColor)),
          iconTheme:
          IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Theme.of(context).disabledColor,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
                title: Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (bool value){
                      if(theme2_change==true){
                        ref.read(theme2boolProvider.notifier).state = false;
                      }
                      if(theme3_change==true){
                        ref.read(theme3boolProvider.notifier).state = false;
                      }
                        ref.read(theme1boolProvider.notifier).state = !theme1_change;
                        ref.read(themechangeProvider.notifier).state = value? 1:0;
                        print(ref.read(theme1boolProvider.notifier).state);
                        _setPrefItems();
                    },
                    initialValue: theme1_change,
                    leading: Icon(Icons.format_paint,size: 40),
                    title: Text(AppLocalizations.of(context).theme1),
                  ),

                  SettingsTile.switchTile(
                    onToggle: (bool value) {
                      if(theme1_change==true){
                        ref.read(theme1boolProvider.notifier).state = !theme1_change;
                      }
                      if(theme3_change==true){
                        ref.read(theme3boolProvider.notifier).state = !theme3_change;
                      }
                      ref.read(themechangeProvider.notifier).state=value? 2:0;
                      ref.read(theme2boolProvider.notifier).state = !theme2_change;

                      _setPrefItems();
                    },
                    initialValue: theme2_change,
                    leading: SizedBox(width: 40, child: Image.asset('assets/icon-5.png')),
                    title: Text(AppLocalizations.of(context).theme2),
                  ),

                  SettingsTile.switchTile(
                    onToggle: (bool value) {
                      if(theme2_change==true){
                        ref.read(theme2boolProvider.notifier).state = !theme2_change;
                      }
                      if(theme1_change==true){
                        ref.read(theme1boolProvider.notifier).state = !theme1_change;
                      }

                      ref.read(themechangeProvider.notifier).state=value? 3:0;
                      ref.read(theme3boolProvider.notifier).state = !theme3_change;
                      _setPrefItems();
                    },
                    initialValue: theme3_change,
                    leading: ImageIcon(AssetImage('assets/38123.png'),size: 40,),
                    title: Text(AppLocalizations.of(context).theme3),
                  ),
                ]
            )
            // SettingsSectionを並べていく。
          ],
        )
    );
  }
}

