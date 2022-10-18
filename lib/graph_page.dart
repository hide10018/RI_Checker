import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transport_predict_app/data_page.dart';
import 'package:transport_predict_app/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transport_predict_app/setting_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


List<double> tempValue = List<double>.generate(24, (i) => 0); //グラフデータ初期値0埋め

List<double> humValue = List<double>.generate(24, (i) => 20);

List<double> dustValue = List<double>.generate(24, (i) => 0);

List<double> apValue = List<double>.generate(24, (i) => 970);

double_cast(data, list) {
  var x = double.parse("${data}");

  list.add(x);
}

class GraphPage extends ConsumerStatefulWidget {
  const GraphPage({Key? key}) : super(key: key);


  @override
  _GraphPageState createState() => _GraphPageState();

}

class _GraphPageState extends ConsumerState<GraphPage> {

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


  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];

  @override
  void initState() {
    super.initState();
    Future(() async {
      showProgressDialog();
      await Future.delayed(Duration(seconds: 1.toInt()));
      Navigator.of(context).pop();
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final ref = FirebaseDatabase.instance.ref();

      final onedaytmp = await ref.child(
          'weather/temperature/onedaytmp').get();
      final onedayhum = await ref.child(
          'weather/humidity/onedayhum').get();
      final onedaydust = await ref.child('dust/onedaydust').get();

      final onedayap = await ref.child('ap/onedayap').get();


      // final daytmp = onedaytmp.child;
      var date = DateTime.now();

      setState(() {
        print(tempValue);
        tempValue.clear();
        print("a");
        humValue.clear();

        dustValue.clear();

        apValue.clear();
        print("a");
        print(tempValue);


        for (var i = date.hour; i >= 0; i--) {
          // print(onedaytmp
          //     .child("${i}")
          //     .key);
          double_cast(onedaytmp
              .child("${i}")
              .value as int, tempValue);

          double_cast(onedayhum
              .child("${i}")
              .value as int, humValue);

          double_cast(onedaydust
              .child("${i}")
              .value as double, dustValue);

          double_cast(onedayap
              .child("${i}")
              .value as double, apValue);
        }

        for (var i = 23; i > date.hour; i--) {
          // print(onedaytmp
          //     .child("${i}")
          //     .key);
          double_cast(onedaytmp
              .child("${i}")
              .value as int, tempValue);

          double_cast(onedayhum
              .child("${i}")
              .value as int, humValue);

          double_cast(onedaydust
              .child("${i}")
              .value as double, dustValue);

          double_cast(onedayap
              .child("${i}")
              .value as double, apValue);
        }

        print("a");
        print(tempValue);
      });
    });
  }

  var screenSize = MediaQuery;
  final test = "";

  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showProgressDialog();
          await Future.delayed(Duration(seconds: 1.toInt()));
          Navigator.of(context).pop();
          WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp();
          final ref = FirebaseDatabase.instance.ref();

          final onedaytmp = await ref.child(
              'weather/temperature/onedaytmp').get();
          final onedayhum = await ref.child(
              'weather/humidity/onedayhum').get();
          final onedaydust = await ref.child('dust/onedaydust').get();

          final onedayap = await ref.child('ap/onedayap').get();


          setState(() {
            print("tempValue");
            print(tempValue);
            tempValue.clear();

            humValue.clear();

            dustValue.clear();

            apValue.clear();
            var date = DateTime.now();

            if (onedaytmp.exists) {
              for (var i = date.hour; i >= 0; i--) {
                // print(onedaytmp
                //     .child("${i}")
                //     .key);
                double_cast(onedaytmp
                    .child("${i}")
                    .value as int, tempValue);

                double_cast(onedayhum
                    .child("${i}")
                    .value as int, humValue);

                double_cast(onedaydust
                    .child("${i}")
                    .value as double, dustValue);

                double_cast(onedayap
                    .child("${i}")
                    .value as double, apValue);


                print(apValue);
                print("test");
              }

              for (var i = 23; i > date.hour; i--) {
                // print(onedaytmp
                //     .child("${i}")
                //     .key);
                double_cast(onedaytmp
                    .child("${i}")
                    .value as int, tempValue);

                double_cast(onedayhum
                    .child("${i}")
                    .value as int, humValue);

                double_cast(onedaydust
                    .child("${i}")
                    .value as double, dustValue);

                double_cast(onedayap
                    .child("${i}")
                    .value as double, apValue);
              }
            }
          });
          print(tempValue);
          print("humValue");
        }, label: Text(AppLocalizations
          .of(context)
          .get_data),
        icon: Icon(Icons.download),

      ),
      // backgroundColor:

      appBar: AppBar(

        title: Text(AppLocalizations
            .of(context)
            .charts_title,
            style: TextStyle(color: Theme
                .of(context)
                .primaryColor)),
        backgroundColor: Theme
            .of(context)
            .disabledColor,
      ),
      body:
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: Data_page.background_img(ref
                  .read(themechangeProvider.notifier)
                  .state),
              colorFilter: ColorFilter.mode(
                  switch_value ? Colors.white.withOpacity(0.6) : Colors.white
                      .withOpacity(0.7), BlendMode.dstATop),
              fit: BoxFit.cover,
            )),
        child: SingleChildScrollView(
          child:
          Column(
            children: <Widget>[
              SizedBox(
                height: screenSize.height*0.05,
              ),

              Text(AppLocalizations
                  .of(context)
                  .temperature2,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.lightBlueAccent
                ),
              ),

              SingleChildScrollView( //temp chart
                scrollDirection: Axis.horizontal,
                child: Container(
                    color: Theme
                        .of(context)
                        .disabledColor
                        .withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                    margin: screenSize.width >= 500 ? EdgeInsets.fromLTRB(
                        screenSize.width * 0, 50, 0, 50) : const EdgeInsets
                        .fromLTRB(0, 50, 0, 50),
                    width: screenSize.width >= 500
                        ? screenSize.width * 1
                        : screenSize.width * 2,
                    height: screenSize.height * 0.4,

                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 25,
                        minY: tempValue.reduce(min) - 3,
                        maxY: tempValue.reduce(max) + 3,
                        lineBarsData: [
                          LineChartBarData(
                              spots: [
                                FlSpot(0, tempValue[0]),
                                FlSpot(1, tempValue[1]),
                                FlSpot(2, tempValue[2]),
                                FlSpot(3, tempValue[3]),
                                FlSpot(4, tempValue[4]),
                                FlSpot(5, tempValue[5]),
                                FlSpot(6, tempValue[6]),
                                FlSpot(7, tempValue[7]),
                                FlSpot(8, tempValue[8]),
                                FlSpot(9, tempValue[9]),
                                FlSpot(10, tempValue[10]),
                                FlSpot(11, tempValue[11]),
                                FlSpot(12, tempValue[12]),
                                FlSpot(13, tempValue[13]),
                                FlSpot(14, tempValue[14]),
                                FlSpot(15, tempValue[15]),
                                FlSpot(16, tempValue[16]),
                                FlSpot(17, tempValue[17]),
                                FlSpot(18, tempValue[18]),
                                FlSpot(19, tempValue[19]),
                                FlSpot(20, tempValue[20]),
                                FlSpot(21, tempValue[21]),
                                FlSpot(22, tempValue[22]),
                                FlSpot(23, tempValue[23]),
                              ]

                          ),
                        ],
                        titlesData: FlTitlesData(
                            show: true,

                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false
                                )
                            ),

                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false
                                )
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: leftTitleWidgets,
                                reservedSize: 33,
                              ),
                            ),

                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            )
                        ),
                      ),
                    )
                ),
              ),

              Text(AppLocalizations
                  .of(context)
                  .humidity2,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),),

              SingleChildScrollView( //hum chart
                scrollDirection: Axis.horizontal,
                child: Container(
                    color: Theme
                        .of(context)
                        .disabledColor
                        .withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                    margin: screenSize.width >= 500 ? EdgeInsets.fromLTRB(
                        screenSize.width * 0, 50, 0, 100) : const EdgeInsets
                        .fromLTRB(0, 50, 0, 50),
                    width: screenSize.width >= 500
                        ? screenSize.width * 1
                        : screenSize.width * 2,
                    height: screenSize.height * 0.4,

                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 25,
                        minY: humValue.reduce(min) - 7,
                        maxY: humValue.reduce(max) + 7,
                        lineBarsData: [
                          LineChartBarData(
                              spots: [
                                FlSpot(0, humValue[0]),
                                FlSpot(1, humValue[1]),
                                FlSpot(2, humValue[2]),
                                FlSpot(3, humValue[3]),
                                FlSpot(4, humValue[4]),
                                FlSpot(5, humValue[5]),
                                FlSpot(6, humValue[6]),
                                FlSpot(7, humValue[7]),
                                FlSpot(8, humValue[8]),
                                FlSpot(9, humValue[9]),
                                FlSpot(10, humValue[10]),
                                FlSpot(11, humValue[11]),
                                FlSpot(12, humValue[12]),
                                FlSpot(13, humValue[13]),
                                FlSpot(14, humValue[14]),
                                FlSpot(15, humValue[15]),
                                FlSpot(16, humValue[16]),
                                FlSpot(17, humValue[17]),
                                FlSpot(18, humValue[18]),
                                FlSpot(19, humValue[19]),
                                FlSpot(20, humValue[20]),
                                FlSpot(21, humValue[21]),
                                FlSpot(22, humValue[22]),
                                FlSpot(23, humValue[23]),
                              ]

                          ),
                        ],
                        titlesData: FlTitlesData(
                            show: true,

                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false
                                )
                            ),

                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false
                                )
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: leftTitleWidgets,
                                reservedSize: 33,
                              ),
                            ),


                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            )
                        ),
                      ),
                    )
                ),
              ),

              Text(AppLocalizations
                  .of(context)
                  .air_pressure2,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.greenAccent
                ),
              ),

              SingleChildScrollView( //temp chart
                scrollDirection: Axis.horizontal,
                child: Container(
                    color: Theme
                        .of(context)
                        .disabledColor
                        .withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                    margin: screenSize.width >= 500 ? EdgeInsets.fromLTRB(
                        screenSize.width * 0, 50, 0, 50) : const EdgeInsets
                        .fromLTRB(0, 50, 0, 50),
                    width: screenSize.width >= 500
                        ? screenSize.width * 1
                        : screenSize.width * 2,
                    height: screenSize.height * 0.4,

                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 25,
                        minY: apValue.reduce(min) - 3,
                        maxY: apValue.reduce(max) + 3,
                        lineBarsData: [
                          LineChartBarData(
                              spots: [
                                FlSpot(0, apValue[0]),
                                FlSpot(1, apValue[1]),
                                FlSpot(2, apValue[2]),
                                FlSpot(3, apValue[3]),
                                FlSpot(4, apValue[4]),
                                FlSpot(5, apValue[5]),
                                FlSpot(6, apValue[6]),
                                FlSpot(7, apValue[7]),
                                FlSpot(8, apValue[8]),
                                FlSpot(9, apValue[9]),
                                FlSpot(10, apValue[10]),
                                FlSpot(11, apValue[11]),
                                FlSpot(12, apValue[12]),
                                FlSpot(13, apValue[13]),
                                FlSpot(14, apValue[14]),
                                FlSpot(15, apValue[15]),
                                FlSpot(16, apValue[16]),
                                FlSpot(17, apValue[17]),
                                FlSpot(18, apValue[18]),
                                FlSpot(19, apValue[19]),
                                FlSpot(20, apValue[20]),
                                FlSpot(21, apValue[21]),
                                FlSpot(22, apValue[22]),
                                FlSpot(23, apValue[23]),
                              ]
                          ),
                        ],
                        titlesData: FlTitlesData(
                            show: true,

                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false
                                )
                            ),

                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false
                                )
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: leftTitleWidgets,
                                reservedSize: 33,
                              ),
                            ),

                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            )
                        ),
                      ),
                    )
                ),
              ),

              Text('PM2.5(μg/m^3)',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme
                        .of(context)
                        .primaryColor
                ),),

              SingleChildScrollView( //dust chart
                scrollDirection: Axis.horizontal,
                child: Container(
                    color: Theme
                        .of(context)
                        .disabledColor
                        .withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                    margin: screenSize.width >= 500 ? EdgeInsets.fromLTRB(
                        screenSize.width * 0, 50, 0, 50) : const EdgeInsets
                        .fromLTRB(0, 50, 0, 75),
                    width: screenSize.width >= 500
                        ? screenSize.width * 1
                        : screenSize.width * 2,
                    height: screenSize.height * 0.4,

                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 25,
                        minY: dustValue.reduce(min) - 0.2,
                        maxY: dustValue.reduce(max) + 0.2,
                        lineBarsData: [
                          LineChartBarData(
                              spots: [
                                FlSpot(0, dustValue[0]),
                                FlSpot(1, dustValue[1]),
                                FlSpot(2, dustValue[2]),
                                FlSpot(3, dustValue[3]),
                                FlSpot(4, dustValue[4]),
                                FlSpot(5, dustValue[5]),
                                FlSpot(6, dustValue[6]),
                                FlSpot(7, dustValue[7]),
                                FlSpot(8, dustValue[8]),
                                FlSpot(9, dustValue[9]),
                                FlSpot(10, dustValue[10]),
                                FlSpot(11, dustValue[11]),
                                FlSpot(12, dustValue[12]),
                                FlSpot(13, dustValue[13]),
                                FlSpot(14, dustValue[14]),
                                FlSpot(15, dustValue[15]),
                                FlSpot(16, dustValue[16]),
                                FlSpot(17, dustValue[17]),
                                FlSpot(18, dustValue[18]),
                                FlSpot(19, dustValue[19]),
                                FlSpot(20, dustValue[20]),
                                FlSpot(21, dustValue[21]),
                                FlSpot(22, dustValue[22]),
                                FlSpot(23, dustValue[23]),
                              ]

                          ),
                        ],
                        titlesData: FlTitlesData(
                            show: true,

                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false
                                )
                            ),

                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false
                                )
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: DleftTitleWidgets,
                                reservedSize: 33,
                              ),
                            ),

                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            )
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme
          .of(context)
          .primaryColor,
      fontFamily: 'Digital',
      fontSize: 10,
    );
    String text;
    var x = (value).toInt();

    switch (x) {
      case 0:
        text = AppLocalizations
            .of(context)
            .now;
        break;
      case 3:
        text = '3' + AppLocalizations
            .of(context)
            .hour_ago;
        break;
      case 6:
        text = '6' + AppLocalizations
            .of(context)
            .hour_ago;
        break;
      case 9:
        text = '9' + AppLocalizations
            .of(context)
            .hour_ago;
        break;
      case 12:
        text = '12' + AppLocalizations
            .of(context)
            .hour_ago;
        break;
      case 15:
        text = '15' + AppLocalizations
            .of(context)
            .hour_ago;
        break;
      case 18:
        text = '18' + AppLocalizations
            .of(context)
            .hour_ago;
        break;
      case 21:
        text = '21' + AppLocalizations
            .of(context)
            .hour_ago;
        break;
      case 24:
        text = '24' + AppLocalizations
            .of(context)
            .hour_ago;
        break;
      default:
        return const Text ('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style2 = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme
          .of(context)
          .primaryColor,
      fontFamily: 'Digital',
      fontSize: 10,
    );
    String text;
    var y = (value).toInt();
    var x = (y).toString();
    text = x;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, softWrap: false, style: style2),);
  }

  Widget DleftTitleWidgets(double value, TitleMeta meta) {
    var style2 = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme
          .of(context)
          .primaryColor,
      fontFamily: 'Digital',
      fontSize: 10,
    );
    String _text;
    var x = value.toStringAsFixed(1);
    var y = (x).toString();
    _text = y;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(_text, softWrap: false, style: style2),);
  }
}



