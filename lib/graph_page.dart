import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<double> tempValue = List<double>.generate(24, (i)=>0);

List<double> humValue = List<double>.generate(24, (i)=>20);

List<double> dustValue = List<double>.generate(24, (i)=>0);

List<double> apValue = List<double>.generate(24, (i)=>970);

double_cast(data, list){

  var x = double.parse("${data}");

  list.add(x);
}

//
// class LineChartWidget extends StatelessWidget{
//
// }



class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);


  @override
    Widget build(BuildContext context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          ),

        home: GraphPage(title:'グラフ'),
          // color: Colors.white,
        );
    }

}

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key, required this.title}) : super(key: key);
  final String title;




  @override
  State<GraphPage> createState() => _GraphPageState();

}

// class Chart extends WidgetsFlutterBinding{
//   void getdata() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//     final ref = FirebaseDatabase.instance.ref();
//
//     final onedaytmp = await ref.child('weather/temperature').get();
//     final onedayhum = await ref.child('weather/humidity/now').get();
//
//     var daytmp = onedaytmp.child('temperature').key;
//     return print(daytmp);}
//   Chart.getdata();
//
//
// }

class _GraphPageState extends State<GraphPage>{




  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];
  @override
  void initState() {
    super.initState();
    Future(() async {
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
            double_cast(onedaytmp.child("${i}").value as int, tempValue);

            double_cast(onedayhum.child("${i}").value as int, humValue);

            double_cast(onedaydust.child("${i}").value as double, dustValue);

            double_cast(onedayap.child("${i}").value as double, apValue);

          }

          for (var i = 23; i > date.hour; i--) {
            // print(onedaytmp
            //     .child("${i}")
            //     .key);
            double_cast(onedaytmp.child("${i}").value as int, tempValue);

            double_cast(onedayhum.child("${i}").value as int, humValue);

            double_cast(onedaydust.child("${i}").value as double, dustValue);

            double_cast(onedayap.child("${i}").value as double, apValue);

          }

        print("a");
        print(tempValue);





// List<Object?> tempKey = <Object?>[];
// final List<Object?> tempValue = <Object?>[];


// final daytmp = onedaytmp.child;
//         if (onedaytmp.exists) {
//           for (var i = 0; i <= 23; i++) {
//             // print(onedaytmp
//             //     .child("${i}")
//             //     .key);
//
//             var y = onedaytmp
//                 .child("${i}")
//                 .value as int;
//
//             var yy = double.parse("${y}");
//
//
//             tempValue.add(yy);
//
//
//             print(onedaytmp
//                 .child("$i")
//                 .value);
//             print("test");
//           }
//
//           print(tempValue);
//         }
      });
    });
  }
  var screenSize = MediaQuery;
  final test = "" ;
  // List<double> tempKey = List(23);
  // List<double> tempValue = List(23);



  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(
        // child: Icon(Icons.download),
        //   backgroundColor: Colors.blue,
          onPressed: () async {
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

              // List<Object?> tempKey = <Object?>[];
              // final List<Object?> tempValue = <Object?>[];


              // final daytmp = onedaytmp.child;
              var date = DateTime.now();

              if (onedaytmp.exists) {
                for (var i = date.hour; i >= 0; i--) {
                  // print(onedaytmp
                  //     .child("${i}")
                  //     .key);
                  double_cast(onedaytmp.child("${i}").value as int, tempValue);

                  double_cast(onedayhum.child("${i}").value as int, humValue);

                  double_cast(onedaydust.child("${i}").value as double, dustValue);

                  double_cast(onedayap.child("${i}").value as double, apValue);


                  print(apValue);
                  print("test");
                }

                for (var i = 23; i > date.hour; i--) {
                  // print(onedaytmp
                  //     .child("${i}")
                  //     .key);
                  double_cast(onedaytmp.child("${i}").value as int, tempValue);

                  double_cast(onedayhum.child("${i}").value as int, humValue);

                  double_cast(onedaydust.child("${i}").value as double, dustValue);

                  double_cast(onedayap.child("${i}").value as double, apValue);
                }

              }

            });
            print(tempValue);
            print("humValue");
        }, label: Text('データ取得'),
        icon: Icon(Icons.download),

      ),
      backgroundColor: Colors.black,

      appBar: AppBar(

        title: Text(widget.title),
      ),
      body:
          SingleChildScrollView(
            child:
                Column(
                  children: <Widget>[

                  const Text(
                  'inui toko',
                ),

                  const SizedBox(
                    height: 0,
                ),

                  const Text("Temperature(℃)",
                    style: TextStyle(
                    fontSize: 20,
                    color: Colors.lightBlueAccent
                  ),
                ),

                  SingleChildScrollView(//temp chart
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: screenSize.width >= 500? EdgeInsets.fromLTRB(screenSize.width*0.1, 50, 0, 50):const EdgeInsets.fromLTRB(0, 50, 0, 50),
                      width: screenSize.width >= 500? screenSize.width*0.8: screenSize.width*2,
                      height: screenSize.height * 0.4,

                      child:LineChart(
                      LineChartData(
                          minX: 0,
                          maxX: 25,
                          minY: tempValue.reduce(min)-3,
                          maxY: tempValue.reduce(max)+3,
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

                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: leftTitleWidgets,
                                  reservedSize: 33,
                                ),
                              ),

                            bottomTitles: AxisTitles(
                              sideTitles : SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitleWidgets,
                              ),
                            )
                      ),
                    ) ,
                  )
                  ),
                ),

                  const Text('Humidity(%)',
                    style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),),

                  SingleChildScrollView(//hum chart
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: screenSize.width >= 500? EdgeInsets.fromLTRB(screenSize.width*0.1, 50, 0, 100):const EdgeInsets.fromLTRB(0, 50, 0, 50),
                        width: screenSize.width >= 500? screenSize.width*0.8: screenSize.width*2,
                        height: screenSize.height * 0.4,

                        child:LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: 25,
                            minY: humValue.reduce(min)-7,
                            maxY: humValue.reduce(max)+7,
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

                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: leftTitleWidgets,
                                    reservedSize: 33,
                                  ),
                                ),


                                bottomTitles: AxisTitles(
                                  sideTitles : SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: bottomTitleWidgets,
                                  ),
                                )
                            ),
                          ) ,
                        )
                    ),
                  ),

                    const Text("Air pressure(hPa)",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.greenAccent
                      ),
                    ),

                    SingleChildScrollView(//temp chart
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: screenSize.width >= 500? EdgeInsets.fromLTRB(screenSize.width*0.1, 50, 0, 50):const EdgeInsets.fromLTRB(0, 50, 0, 50),
                          width: screenSize.width >= 500? screenSize.width*0.8: screenSize.width*2,
                          height: screenSize.height * 0.4,

                          child:LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: 25,
                              minY: apValue.reduce(min)-3,
                              maxY: apValue.reduce(max)+3,
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

                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: leftTitleWidgets,
                                      reservedSize: 33,
                                    ),
                                  ),

                                  bottomTitles: AxisTitles(
                                    sideTitles : SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitleWidgets,
                                    ),
                                  )
                              ),
                            ) ,
                          )
                      ),
                    ),

                    const Text('PM2.5(μg/m^3)',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),),

                SingleChildScrollView(//dust chart
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: screenSize.width >= 500? EdgeInsets.fromLTRB(screenSize.width*0.1, 50, 0, 50):const EdgeInsets.fromLTRB(0, 50, 0, 75),
                          width: screenSize.width >= 500? screenSize.width*0.8: screenSize.width*2,
                          height: screenSize.height * 0.4,

                          child:LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: 24,
                              minY: dustValue.reduce(min)-0.2,
                              maxY: dustValue.reduce(max)+0.2,
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

                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: leftTitleWidgets,
                                      reservedSize: 33,
                                    ),
                                  ),

                                  bottomTitles: AxisTitles(
                                    sideTitles : SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitleWidgets,
                                    ),
                                  )
                              ),
                            ) ,
                          )
                      ),
                    ),



                  // Row(
                  //   children:[
                  //     SizedBox(
                  //       width:  screenSize.width / 2,
                  //       height: 50,
                  //       child: ElevatedButton.icon(
                  //         icon: const Icon(
                  //           Icons.download,
                  //           color: Colors.white,
                  //         ),
                  //         label: const Text('データ取得'),
                  //         style: ElevatedButton.styleFrom(
                  //           primary: Colors.green,
                  //           onPrimary: Colors.white,
                  //         ),
                  //         onPressed: () async {
                  //           WidgetsFlutterBinding.ensureInitialized();
                  //           await Firebase.initializeApp();
                  //           final ref = FirebaseDatabase.instance.ref();
                  //
                  //
                  //           final onedaytmp = await ref.child(
                  //               'weather/temperature/onedaytmp').get();
                  //           final onedayhum = await ref.child(
                  //               'weather/humidity/onedayhum').get();
                  //           final onedaydust = await ref.child('dust/onedaydust').get();
                  //
                  //
                  //           setState(() {
                  //             tempKey.clear();
                  //             tempValue.clear();
                  //
                  //             humKey.clear();
                  //             humValue.clear();
                  //
                  //             dustKey.clear();
                  //             dustValue.clear();
                  //
                  //
                  //             // final daytmp = onedaytmp.child;
                  //             if (onedaytmp.exists) {
                  //               for (var i = 0; i <= 23; i++) {
                  //                 print(onedaytmp
                  //                     .child("${i}")
                  //                     .key);
                  //                 print(onedaytmp
                  //                     .child("${i}")
                  //                     .value);
                  //               }
                  //
                  //
                  //               //   setState(() {
                  //               // tmp = tmpsnapshot
                  //               //     .child('tag1')
                  //               //     .value;
                  //               // hum = humsnapshot
                  //               //     .child('tag1')
                  //               //     .value;
                  //               // });
                  //             } else {
                  //               print('No data available.');
                  //             }
                  //
                  //             // List<Object?> tempKey = <Object?>[];
                  //             // final List<Object?> tempValue = <Object?>[];
                  //
                  //
                  //             // final daytmp = onedaytmp.child;
                  //             if (onedaytmp.exists) {
                  //               for (var i = 0; i <= 24; i++) {
                  //                 // print(onedaytmp
                  //                 //     .child("${i}")
                  //                 //     .key);
                  //
                  //                 var x = onedaytmp
                  //                     .child("${i}")
                  //                     .key as String;
                  //
                  //                 var y = onedaytmp
                  //                     .child("${i}")
                  //                     .value as int;
                  //
                  //                 var xx = double.parse(x);
                  //                 var yy = double.parse("${y}");
                  //
                  //                 tempKey.add(xx);
                  //
                  //                 tempValue.add(yy);
                  //
                  //
                  //                 var x2 = onedayhum
                  //                     .child("${i}")
                  //                     .key as String;
                  //
                  //                 var y2 = onedayhum
                  //                     .child("${i}")
                  //                     .value as int;
                  //
                  //                 var xx2 = double.parse(x2);
                  //                 var yy2 = double.parse("${y2}");
                  //
                  //                 humKey.add(xx2);
                  //
                  //                 humValue.add(yy2);
                  //
                  //                 print(humKey);
                  //
                  //
                  //                 var x3 = onedaydust
                  //                     .child("${i}")
                  //                     .key as String;
                  //
                  //                 var y3 = onedaydust
                  //                     .child("${i}")
                  //                     .value as double;
                  //
                  //                 var xx3 = double.parse(x3);
                  //                 var yy3 = double.parse("${y3}");
                  //
                  //                 dustKey.add(xx3);
                  //
                  //                 dustValue.add(yy3);
                  //
                  //
                  //                 print(onedaytmp
                  //                     .child("$i")
                  //                     .value);
                  //                 print("test");
                  //               }
                  //
                  //               print(tempKey);
                  //               print(tempValue);
                  //               print(humValue);
                  //             }
                  //           });
                  //
                  //         },
                  //
                  //
                  //       ),
                  //     ),
                  //
                  //     SizedBox(
                  //       width: screenSize.width/2,
                  //       height: 50,
                  //       child: ElevatedButton.icon(
                  //         icon: const Icon(
                  //           Icons.home,
                  //           color: Colors.white,
                  //         ),
                  //         label: const Text('Home'),
                  //         style: ElevatedButton.styleFrom(
                  //           primary: Colors.green,
                  //           onPrimary: Colors.white,
                  //         ),
                  //         onPressed: () async {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => const MyApp()),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //     ],
                  // ),

                  ],
              ),
              ),

          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: _selectedIndex,
          //   onTap: _onItemTapped,
          //   items: const[
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       label:  'Home'
          //
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       label: 'Home'
          //     ),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.home),
          //         label: 'Home'
          //     ),
          //   ],
          // ),



          );


  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontFamily: 'Digital',
      fontSize: 10,
    );
    String text;
    var x = (value).toInt();

    switch (x) {
      case 0:
        text = '現在';
        break;
      // case 1:
      //   text = '1時間前';
      //   break;
      // case 2:
      //   text = '2h';
      //   break;
      case 3:
        text = '3時間前';
        break;
      // case 4:
      //   text = '4h';
      //   break;
      // case 5:
      //   text = '5h';
      //   break;
      case 6:
        text = '6時間前';
        break;
      // case 7:
      //   text = '7h';
      //   break;
      // case 8:
      //   text = '8h';
      //   break;
      case 9:
        text = '9時間前';
        break;
      // case 10:
      //   text = '10h';
      //   break;
      // case 11:
      //   text = '11h';
      //   break;
      case 12:
        text = '12時間前';
        break;
      // case 13:
      //   text = '13h';
      //   break;
      // case 14:
      //   text = '14h';
      //   break;
      case 15:
        text = '15時間前';
        break;
      // case 17:
      //   text = '17h';
      //   break;
      case 18:
        text = '18時間前';
        break;
      // case 19:
      //   text = '19h';
      //   break;
      // case 20:
      //   text = '20h';
      //   break;
      case 21:
        text = '21時間前';
        break;
      // case 22:
      //   text = '22h';
      //   break;
      // case 23:
      //   text = '23h';
      //   break;
      case 24:
        text = '24時間前';
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
    const style2 = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontFamily: 'Digital',
      fontSize: 10,
    );
    String text;
    var y = (value).toInt();
    var x = (y).toString();
    text=x;
    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text,softWrap: false, style:  style2),);
  }

  Widget DliftTitleWidgets(double value, TitleMeta meta) {
    const style2 = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontFamily: 'Digital',
      fontSize: 9,
    );
    String text3;
    var x = value;
    var y = x.toString();
    switch (y){
      case '0.4':
        text3='0.4';
        break;
      case '0.6000000000000001':
        text3='0.6';
        break;
      case'0.8':
        text3='0.8';
        break;
      case '1.0':
        text3='1.0';
        break;
      case '1.2':
        text3='1.2';
        break;
      case '1.4':
        text3='1.4';
        break;
      case '1.5999999999999999':
        text3='1.6';
        break;
      default:
        return const Text ('');
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text3, style:  style2),);
  }
}

class Footer extends StatefulWidget {
  const Footer();

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
        ),
      ],
    );
  }
}



