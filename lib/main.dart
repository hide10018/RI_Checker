import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:transport_predict_app/graph_page.dart';
import 'package:transport_predict_app/data_page.dart';
import 'package:transport_predict_app/language_change.dart';
import 'package:transport_predict_app/setting_page.dart';
import 'package:transport_predict_app/data_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// String locale = ("ja");
bool a = false;
String lang = 'en';

class MyTheme extends ChangeNotifier {//ダークモード用provider
  _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark_mode', _isDark);
  }

  ThemeData current = ThemeData.light().copyWith(
      primaryColor: Colors.black87,
      disabledColor: Colors.white);
  bool _isDark = false;

  toggle() {
    _isDark = !_isDark;
    current = _isDark ? ThemeData.dark().copyWith(
      primaryColor: Colors.white,
      disabledColor: Colors.black87,

    ) : ThemeData.light().copyWith(
      primaryColor: Colors.black87,
      disabledColor: Colors.white,
    );
    notifyListeners();
    _setPrefItems();
    return _isDark;
  }

  test() {
    _isDark = b;
    current = _isDark ? ThemeData.dark().copyWith(
      primaryColor: Colors.white,
      disabledColor: Colors.black87,

    ) : ThemeData.light().copyWith(
      primaryColor: Colors.black87,
      disabledColor: Colors.white,
    );
    notifyListeners();
    _setPrefItems();
  }
}

class Local_Change extends ChangeNotifier{
  Locale _locale;
  Local_Change(this._locale);

  factory Local_Change.first(lang)=>//設定値を読み込む用
      Local_Change(Locale(lang));

  factory Local_Change.jp()=>
      Local_Change(Locale('ja'));


  factory Local_Change.en()=>
      Local_Change(Locale('en'));

  void changeLocale(Local_Change state){
    _locale=state.locale;
    lang = _locale.toLanguageTag();

    _setPrefItems() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('language', lang);
    }

    _setPrefItems();
    notifyListeners();
  }


  Locale get locale => _locale;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => MyTheme()),
        ChangeNotifierProvider(create: (_) => Local_Change.jp())
      ],child: Consumer2<MyTheme, Local_Change>(builder: (_, theme, localState,__)
{

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: theme.current,
              darkTheme: theme.current,
              home: const MyHomePage(title: '現在のデータ'),
              locale: localState.locale,

            );
          })
          );
}
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const _screens = [
    data_page(),
    GraphPage(),
    SettingsPage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Theme.of(context).disabledColor,
          backgroundColor: Theme.of(context).primaryColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Charts'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }

}
