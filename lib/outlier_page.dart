import 'dart:async';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:transport_predict_app/data_page.dart';
import 'package:transport_predict_app/main.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:transport_predict_app/setting_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


List<Widget> pred_list = [];

class OutlierPage extends ConsumerStatefulWidget {
  const OutlierPage({Key? key}) : super(key: key);

  @override
  _OutlierPageState createState() => _OutlierPageState();
}

class _OutlierPageState extends ConsumerState<OutlierPage> {

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
    Future(() async {
      showProgressDialog();
      await Future.delayed(Duration(seconds: 1.toInt()));
      Navigator.of(context).pop();
      //getリクエスト
      pred_list.clear();
      try {
        http.Response result = await http
            .get(
              Uri.parse(
                  'https://riapi.hide10018.repl.co/?temp=${tmp}&hum=${hum}&dust=${dust}&pressure=${pressure}'),
            )
            .timeout(const Duration(seconds: 3));
        print("d");

        Map<String, dynamic> pred_json = jsonDecode(result.body);
        print(pred_json);
        setState(() {
          pred_list = [
            Outlier(pred_json['Temperature']).View(
                AppLocalizations.of(context).temperature2,
                Theme.of(context),
                MediaQuery.of(context).size),
            Outlier(pred_json['Humidity']).View(
                AppLocalizations.of(context).humidity2,
                Theme.of(context),
                MediaQuery.of(context).size),
            Outlier(pred_json['AirPressure']).View(
                AppLocalizations.of(context).air_pressure2,
                Theme.of(context),
                MediaQuery.of(context).size),
            Outlier(pred_json['PM2.5']).View('PM2.5(μg/m^3)', Theme.of(context),
                MediaQuery.of(context).size),
          ];
        });
      } on TimeoutException catch (e) {
        return setState(() {
          pred_list = [
            Column(
              children: [
                Container(
                  child: Text('APIに接続できませんでした。'),
                ),
              ],
            )
          ];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            showProgressDialog();
            await Future.delayed(Duration(seconds: 1.toInt()));
            Navigator.of(context).pop();
            pred_list.clear();
            try {
              http.Response result = await http
                  .get(Uri.parse(
                      'https://riapi.hide10018.repl.co/?temp=${tmp}&hum=${hum}&dust=${dust}&pressure=${pressure}'))
                  .timeout(const Duration(seconds: 1));
              print("d");

              Map<String, dynamic> pred_json = jsonDecode(result.body);
              print(pred_json);
                setState(() {
                  pred_list = [
                    Outlier(pred_json['Temperature']).View(
                        AppLocalizations.of(context).temperature2,
                        Theme.of(context),
                        MediaQuery.of(context).size),
                    Outlier(pred_json['Humidity']).View(
                        AppLocalizations.of(context).humidity2,
                        Theme.of(context),
                        MediaQuery.of(context).size),
                    Outlier(pred_json['AirPressure']).View(
                        AppLocalizations.of(context).air_pressure2,
                        Theme.of(context),
                        MediaQuery.of(context).size),
                    Outlier(pred_json['PM2.5']).View('PM2.5(μg/m^3)',
                        Theme.of(context), MediaQuery.of(context).size),
                  ];
                });
            } on TimeoutException catch (e) {
              return setState(() {
                pred_list = [
                  Column(
                    children: [
                      Container(
                        child: Text('APIに接続できませんでした。'),
                      ),
                    ],
                  )
                ];
              });
            }
          },
          label: Text(AppLocalizations.of(context).get_data),
          icon: Icon(Icons.download_rounded),
        ),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).outlier,
              style: TextStyle(color: Theme.of(context).primaryColor)),
          backgroundColor: Theme.of(context).disabledColor,
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: Data_page.background_img(
                  ref.read(themechangeProvider.notifier).state),
              colorFilter: ColorFilter.mode(
                  switch_value
                      ? Colors.white.withOpacity(0.6)
                      : Colors.white.withOpacity(0.7),
                  BlendMode.dstATop),
              fit: BoxFit.cover,
            )),
            child: ListView(
              children: pred_list,
            )));
  }
}

class Outlier {
  Object? data;

  Widget View(title_text, text_color, screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: screenSize.height * 0.025,
              bottom: screenSize.height * 0.025),
          // padding: EdgeInsets.only(right: screenSize.width*0.03,left: screenSize.width*0.03),
          width: screenSize.width * 0.7,
          height: screenSize.height * 0.25,
          decoration: BoxDecoration(
              color: text_color.disabledColor.withOpacity(0.5),
              border: Border.all(color: text_color.disabledColor),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title_text),
              Container(
                padding: EdgeInsets.only(),
                child: Center(
                  child: BorderedText(
                    child: Text(
                      data == 1 ? '正常値です' : '異常値の恐れ',
                      style: TextStyle(
                          color: data == 1
                              ? Colors.lightGreenAccent
                              : Colors.pinkAccent,
                          fontSize: 30),
                    ),
                    strokeWidth: 1.0,
                    strokeColor: text_color.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget error() {
    return Container(
      child: Text('APIに接続できませんでした。'),
    );
  }

  Outlier(this.data);
}
