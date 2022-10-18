import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transport_predict_app/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_predict_app/setting_page.dart';
import 'package:transport_predict_app/theme_change.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


bool b = true;

Object? tmp = '-'; //ここに温度
late Object? hum = '-'; //ここに湿度
Object? dust = '-';
Object? pressure = '-';

class Data_page extends ConsumerStatefulWidget {
  const Data_page({Key? key}) : super(key: key);

  static AssetImage background_img(theme_index) {
    //背景テーマ用
    if (theme_index == 2) {
      return AssetImage('assets/IMG_3541.jpg');
    } else if (theme_index == 3) {
      return AssetImage(
          'assets/wp6205436-minimal-solar-system-hd-wallpapers.jpg');
    } else {
      return AssetImage('');
    }
  }

  @override
  _Data_page createState() => _Data_page();
}

class _Data_page extends ConsumerState<Data_page> {
  void showProgressDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 400),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(  //この部分
              color: Colors.white,
              size: 100
          ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        showProgressDialog();
        await Future.delayed(Duration(seconds: 1.toInt()));
        Navigator.of(context).pop();
        _getPrefItems() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          switch_value = prefs.getBool('dark_mode') ?? false;

          ref.read(darkmodeProvider.notifier).state = switch_value
              ? ThemeData.dark().copyWith(
                  primaryColor: Colors.white, disabledColor: Colors.black87)
              : ThemeData.light().copyWith(
                  primaryColor: Colors.black87, disabledColor: Colors.white);

          ref.read(localeProvider.notifier).state =
              prefs.getString('language') ?? 'en';

          ref.read(themechangeProvider.notifier).state =
              prefs.getInt('theme') ?? 0;
          ref.read(theme1boolProvider.notifier).state =
              prefs.getBool('theme1') ?? false;
          ref.read(theme2boolProvider.notifier).state =
              prefs.getBool('theme2') ?? false;
          ref.read(theme3boolProvider.notifier).state =
              prefs.getBool('theme3') ?? false;

          ref.read(layoutProvider.notifier).state =
              prefs.getBool('layout') ?? false;
        }

        _getPrefItems();

        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        final ref2 = FirebaseDatabase.instance.ref();

        final tmpsnapshot = await ref2.child('weather/temperature/now').get();
        final humsnapshot = await ref2.child('weather/humidity/now').get();
        final dustsnapshot = await ref2.child('dust/now').get();
        final ap_snapshot = await ref2.child('ap/now').get();

        if (tmpsnapshot.exists) {
          print(tmpsnapshot.child('tag1').value);

          setState(() {
            tmp = tmpsnapshot.child('tag1').value;
            hum = humsnapshot.child('tag1').value;

            var dust_cast = dustsnapshot.child('tag1').value as double;

            dust = dust_cast.toStringAsFixed(3);

            var pressure_cast = ap_snapshot.child("now").value as double;
            pressure = pressure_cast.toStringAsFixed(3);
            print(dust);
          });
        } else {
          print('No data available.');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var date = DateTime.now();
    var date_h = date.hour;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showProgressDialog();
          await Future.delayed(Duration(seconds: 1.toInt()));
          Navigator.of(context).pop();

          WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp();
          final ref2 = FirebaseDatabase.instance.ref();

          final tmpsnapshot = await ref2.child('weather/temperature/now').get();
          final humsnapshot = await ref2.child('weather/humidity/now').get();
          final dustsnapshot = await ref2.child('dust/now').get();
          final ap_snapshot = await ref2.child('ap/now').get();

          if (tmpsnapshot.exists) {
            print(tmpsnapshot.child('tag1').value);
            setState(() {
              tmp = tmpsnapshot.child('tag1').value;
              hum = humsnapshot.child('tag1').value;

              var dust_cast = dustsnapshot.child('tag1').value as double;
              dust = dust_cast.toStringAsFixed(3);

              var pressure_cast = ap_snapshot.child("now").value as double;
              pressure = pressure_cast.toStringAsFixed(3);

              print(dust);
            });
          } else {
            print('No data available.');
          }
        },
        label: Text(AppLocalizations.of(context).get_data),
        icon: Icon(Icons.download),
      ),

      //
      // backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title,
            style: TextStyle(color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).disabledColor,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: Data_page.background_img(ref.read(themechangeProvider.notifier).state),
          colorFilter: ColorFilter.mode(
              switch_value
                  ? Colors.white.withOpacity(0.6)
                  : Colors.white.withOpacity(0.7),
              BlendMode.dstATop),
          fit: BoxFit.cover,
        )),
        
        
        child: ref.read(layoutProvider.notifier).state? Column(
          children: [
            SizedBox(height: screenSize.height*0.05,),
            Text('$date_h:00',
                style: TextStyle(
                    fontSize: 50, color: Theme.of(context).primaryColor)),
            Row(
              children: [
                Container(
                  width: screenSize.width * 0.48,
                  height: screenSize.height * 0.3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                      border: Border.all(color: Theme.of(context).disabledColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      SizedBox(
                          width: screenSize.width * 0.2,
                          height: screenSize.height * 0.3,
                          child: Center(
                            child: Image.asset(
                              'assets/tmpicon.png',
                              color: Colors.lightBlueAccent,
                            ),
                          )
                        // if (tmp>30) {
                        //   Colors.lightBlueAccent
                        // }else{
                        // }.lightBlueAccent,),
                      ),
                      Container(
                        width: screenSize.width * 0.22,
                        height: screenSize.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                child: BorderedText(
                                  child: Text(
                                    AppLocalizations.of(context).temperature,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ),
                                  strokeWidth: 1.0,
                                  strokeColor: Theme.of(context).primaryColor,
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  '$tmp℃',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontFamily: 'ds_digital',
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: screenSize.width*0.03,),
                Container(
                  width: screenSize.width * 0.48,
                  height: screenSize.height * 0.3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                      border: Border.all(color: Theme.of(context).disabledColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenSize.width * 0.2,
                        height: screenSize.height * 0.3,
                        child: Center(
                          child: Image.asset(
                            'assets/humicon.png',
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                      Container(
                        width: screenSize.width * 0.25,
                        height: screenSize.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                child: BorderedText(child:
                                Text(
                                  AppLocalizations.of(context).humidity,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.pink,
                                ),
                                ),
                                  strokeWidth: 1.0,
                                  strokeColor: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: screenSize.height*0.01,),
                              FittedBox(
                                child: Text(
                                  '$hum%',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontFamily: 'ds_digital',
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height*0.03,),

            Row(
              children: [
                Container(
                  width: screenSize.width * 0.48,
                  height: screenSize.height * 0.3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                      border: Border.all(color: Theme.of(context).disabledColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      SizedBox(
                          width: screenSize.width * 0.2,
                          height: screenSize.height * 0.3,
                          child: Center(
                              child: Image.asset(
                                'assets/ifn0112.png',
                                color: Colors.lightBlueAccent,
                              ))
                        // if (tmp>30) {
                        //   Colors.lightBlueAccent
                        // }else{
                        // }.lightBlueAccent,),
                      ),
                  Container(
                    width: screenSize.width * 0.25,
                    height: screenSize.height * 0.3,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            child: BorderedText(
                              child: Text(
                                AppLocalizations.of(context).air_pressure,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.lightGreenAccent,
                              ),
                              ),
                              strokeWidth: 1.0,
                              strokeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: screenSize.height*0.01,),
                          FittedBox(
                            child: Text(
                              '$pressure hPa',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'ds_digital',
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),],),
                ),

                SizedBox(width: screenSize.width * 0.03,),

                Container(
                  width: screenSize.width * 0.48,
                  height: screenSize.height * 0.3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.5),
                      border: Border.all(color: Theme.of(context).disabledColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Container(
                          width: screenSize.width * 0.2,
                          height: screenSize.height * 0.3,
                          child: Image.asset(
                            'assets/dust-icon-6.jpg',
                            color: Colors.lightBlueAccent,
                          )
                        // if (tmp>30) {
                        //   Colors.lightBlueAccent
                        // }else{
                        // }.lightBlueAccent,),
                      ),
                      Container(
                        width: screenSize.width * 0.25,
                        height: screenSize.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                child: BorderedText(child:
                                Text(
                                  'PM2.5',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Theme.of(context).primaryColor),
                                ),
                                  strokeWidth: 1.0,
                                  strokeColor: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: screenSize.height*0.01,),
                              FittedBox(
                                child: Text(
                                  '$dust μg/m^3',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "ds_digital",
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ):
        SingleChildScrollView(
          child: Column(children: [
            Text('$date_h:00',
                style: TextStyle(
                    fontSize: 50, color: Theme.of(context).primaryColor)),
            const SizedBox(
              height: 70,
            ),
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: screenSize.width * 0.5,
                        height: 300,
                        child: Center(
                          child: Image.asset(
                            'assets/tmpicon.png',
                            color: Colors.lightBlueAccent,
                          ),
                        )
                        // if (tmp>30) {
                        //   Colors.lightBlueAccent
                        // }else{
                        // }.lightBlueAccent,),
                        ),
                    Container(
                      width: screenSize.width * 0.5,
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context).temperature,
                              style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              '$tmp℃',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontFamily: 'ds_digital',
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    image_theme('assets/humicon.png', 'assets/humicon.png'),
                    Container(
                      width: screenSize.width * 0.5,
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context).humidity,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(
                              '$hum%',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontFamily: 'ds_digital',
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              children: [
                SizedBox(
                    width: screenSize.width * 0.5,
                    height: 300,
                    child: Center(
                        child: Image.asset(
                      'assets/ifn0112.png',
                      color: Colors.lightBlueAccent,
                    ))
                    // if (tmp>30) {
                    //   Colors.lightBlueAccent
                    // }else{
                    // }.lightBlueAccent,),
                    ),
                Container(
                  width: screenSize.width * 0.5,
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context).air_pressure,
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          '$pressure hPa',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'ds_digital',
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            Row(
              children: [
                Container(
                    width: screenSize.width * 0.5,
                    height: 300,
                    child: Image.asset(
                      'assets/dust-icon-6.jpg',
                      color: Colors.lightBlueAccent,
                    )
                    // if (tmp>30) {
                    //   Colors.lightBlueAccent
                    // }else{
                    // }.lightBlueAccent,),
                    ),
                Container(
                  width: screenSize.width * 0.5,
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PM2.5',
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          '$dust μg/m^3',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: "ds_digital",
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ]),
        )),
      );
  }

  Widget image_theme(img, img2) {
    var screenSize = MediaQuery.of(context).size;
    if (switch_value == true) {
      return SizedBox(
          width: screenSize.width * 0.5,
          height: 300,
          child: Center(
              child: Image.asset(
            img,
            color: Colors.lightBlueAccent,
          )));
    } else {
      return SizedBox(
          width: screenSize.width * 0.5,
          height: 300,
          child: Center(
              child: Image.asset(
            img2,
            color: Colors.lightBlueAccent,
          )));
    }

  }

}
