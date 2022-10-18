import 'package:firebase_core/firebase_core.dart';
import 'package:transport_predict_app/graph_page.dart';
import 'package:transport_predict_app/data_page.dart';
import 'package:transport_predict_app/setting_page.dart';
import 'package:transport_predict_app/outlier_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<Icon> theme1list = [//テーマ変更用リスト
  Icon(Icons.home),
  Icon(Icons.show_chart),
  Icon(Icons.check),
  Icon(Icons.settings)
];
final List<Icon> theme2list = [
  Icon(Icons.home),
  Icon(Icons.show_chart),
  Icon(Icons.check),
  Icon(Icons.settings)
];
final List<ImageIcon> theme3list = [
  ImageIcon(
    AssetImage('assets/icon-2.png'),
    size: 40,
  ),
  ImageIcon(
    AssetImage('assets/icon-5.png'),
    size: 40,
  ),
  ImageIcon(
    AssetImage('assets/icon-1.png'),
    size: 40,
  ),
  ImageIcon(
    AssetImage('assets/icon-3.png'),
    size: 40,
  ),
];
final List<ImageIcon> theme4list = [
  ImageIcon(AssetImage('assets/earth.png')),
  ImageIcon(AssetImage('assets/1846.png')),
  ImageIcon(AssetImage('assets/meteor.png')),
  ImageIcon(AssetImage('assets/38123.png'))
];

final List<Icon> theme1list_active = [
  Icon(Icons.home),
  Icon(Icons.show_chart),
  Icon(Icons.check),
  Icon(Icons.settings)
];
final List<Icon> theme2list_active = [
  Icon(Icons.home),
  Icon(Icons.show_chart),
  Icon(Icons.check),
  Icon(Icons.settings)
];
final List<ImageIcon> theme3list_active = [
  MyImageIcon(AssetImage('assets/icon-2.png')),
  MyImageIcon(AssetImage('assets/icon-5.png')),
  MyImageIcon(AssetImage('assets/icon-1.png')),
  MyImageIcon(AssetImage('assets/icon-3.png')),
];
final List<ImageIcon> theme4list_active = [
  ImageIcon(
    AssetImage('assets/earth.png'),
    size: 30,
    color: Colors.lightBlueAccent,
  ),
  ImageIcon(
    AssetImage('assets/1846.png'),
    size: 30,
    color: Colors.lightBlueAccent,
  ),
  ImageIcon(
    AssetImage('assets/meteor.png'),
    size: 30,
    color: Colors.lightBlueAccent,
  ),
  ImageIcon(
    AssetImage('assets/38123.png'),
    size: 30,
    color: Colors.lightBlueAccent,
  )
];

final List<List<Widget>> themelist = [
  theme1list,
  theme2list,
  theme3list,
  theme4list
];
final List<List<Widget>> themelist_active = [
  theme1list_active,
  theme2list_active,
  theme3list_active,
  theme4list_active
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final darkmode = ref.watch(darkmodeProvider);

    return MaterialApp(
      title: 'test',
      theme: darkmode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // BottomNavigationBarを実装したアプリのbaseとなるviewを利用
      home: BaseTabView(),
      locale: Locale(locale),
    );
  }
}

//riverpod
final baseTabViewProvider = StateProvider<ViewType>((ref) => ViewType.home);
final localeProvider = StateProvider<String>((ref) => 'ja');
final darkmodeProvider = StateProvider((ref) => ThemeData.light()
    .copyWith(primaryColor: Colors.black87, disabledColor: Colors.white));
final themechangeProvider = StateProvider((ref) => 0);
final layoutProvider = StateProvider<bool>((ref) => false);


enum ViewType { home, charts, outlier, settings }

class BaseTabView extends ConsumerWidget {
  BaseTabView({Key? key}) : super(key: key);

  final widgets = [
    Data_page(),
    GraphPage(),
    OutlierPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(baseTabViewProvider.state);
    final theme_index = ref.watch(themechangeProvider);
    return Scaffold(
      body: widgets[view.state.index],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: SizedBox(width: 50, child: themelist[theme_index][0]),
              activeIcon:
                  SizedBox(width: 50, child: themelist_active[theme_index][0]),
              label: AppLocalizations.of(context).home),
          BottomNavigationBarItem(
              icon: SizedBox(width: 50, child: themelist[theme_index][1]),
              activeIcon:
                  SizedBox(width: 50, child: themelist_active[theme_index][1]),
              label: AppLocalizations.of(context).charts_title),
          BottomNavigationBarItem(
              icon: SizedBox(width: 50, child: themelist[theme_index][2]),
              activeIcon:
                  SizedBox(width: 50, child: themelist_active[theme_index][2]),
              label: AppLocalizations.of(context).outlier),
          BottomNavigationBarItem(
              icon: SizedBox(width: 50, child: themelist[theme_index][3]),
              activeIcon:
                  SizedBox(width: 50, child: themelist_active[theme_index][3]),
              label: AppLocalizations.of(context).settings),
        ],
        currentIndex: view.state.index,
        onTap: (int index) => view.update((state) => ViewType.values[index]),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class MyImageIcon extends ImageIcon {
  const MyImageIcon(
    ImageProvider image, {
    Key? key,
    double? size,
    Color? color,
    String? semanticLabel,
  }) : super(image,
            key: key, size: size, color: color, semanticLabel: semanticLabel);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Image(
        image: image as ImageProvider,
        width: size,
        height: size,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        excludeFromSemantics: true,
        // color属性は設定しない
      ),
    );
  }
}
