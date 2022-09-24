import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:transport_predict_app/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_predict_app/setting_page.dart';

bool b = false;

class data_page extends StatefulWidget{
  const data_page({Key? key}) : super(key: key);
  @override
  _data_page createState() => _data_page();
}

class _data_page extends State<data_page>{

  _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      b = prefs.getBool('dark_mode') ?? false;
      switch_value = b;
      Provider.of<MyTheme>(context, listen: false).test();

    });
  }

  _getlanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lang = prefs.getString('language') ?? 'en';
      Provider.of<Local_Change>(context,listen: false).changeLocale(Local_Change.first(lang));
    });
  }

  @override
  void initState(){
    Future(() async {
      print(lang);

      _getPrefItems();
      _getlanguage();
      print(b);
      print(lang);

      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final ref = FirebaseDatabase.instance.ref();
      // final event = await ref.once(DatabaseEventType.value);
      // final tmp = event.snapshot.value?.temperature ?? 'Anonymous';
      final tmpsnapshot = await ref.child('weather/temperature/now')
          .get();
      final humsnapshot = await ref.child('weather/humidity/now')
          .get();
      final dustsnapshot = await ref.child('dust/now')
          .get();
      final ap_snapshot = await ref.child('ap/now').get();

      if (tmpsnapshot.exists) {
        print(tmpsnapshot
            .child('tag1')
            .value);

        setState(() {
          tmp = tmpsnapshot
              .child('tag1')
              .value;
          hum = humsnapshot
              .child('tag1')
              .value;

          var d = dustsnapshot
              .child('tag1')
              .value as double;

          var du = d.toStringAsFixed(3);

          var a = ap_snapshot.child("now").value as double;
          var ap = a.toStringAsFixed(3);

          apr = double.parse(ap);
          dust = double.parse(du);
          print(dust);
        });
      } else {
        print('No data available.');
      }
    },

    );
  }

  Object? tmp = '-'; //ここに温度
  late Object? hum = '-'; //ここに湿度
  Object? dust = '-';
  Object? apr = '-';




  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    var date = DateTime.now();
    var date_h = date.hour;

    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(
        // child: Icon(Icons.download),
        //   backgroundColor: Colors.blue,
        onPressed: () async {
          WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp();
          final ref = FirebaseDatabase.instance.ref();
          // final event = await ref.once(DatabaseEventType.value);
          // final tmp = event.snapshot.value?.temperature ?? 'Anonymous';
          final tmpsnapshot = await ref.child('weather/temperature/now')
              .get();
          final humsnapshot = await ref.child('weather/humidity/now')
              .get();
          final dustsnapshot = await ref.child('dust/now')
              .get();
          final ap_snapshot = await ref.child('ap/now').get();

          if (tmpsnapshot.exists) {
            print(tmpsnapshot
                .child('tag1')
                .value);
            setState(() {
                tmp = tmpsnapshot
                    .child('tag1')
                    .value;
                hum = humsnapshot
                    .child('tag1')
                    .value;

                var d = dustsnapshot
                    .child('tag1')
                    .value as double;

                var du = d.toStringAsFixed(3);

                var a = ap_snapshot.child("now").value as double;
                var ap = a.toStringAsFixed(3);

                apr = double.parse(ap);
                dust = double.parse(du);
                print(dust);
            });
          } else {
            print('No data available.');
          }
        }, label: Text(AppLocalizations.of(context).get_data),
        icon: Icon(Icons.download),

      ),

      //
      // backgroundColor: Colors.black,


      appBar: AppBar(

        title: Text(AppLocalizations.of(context).title,
          style: TextStyle(color: Theme.of(context).disabledColor)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:

      SingleChildScrollView(
          child:
          SizedBox(
            child: Column(
                children: [
                  Text(
                    '$date_h:00時点',
                    style: TextStyle(
                      fontSize: 50,
                        color: Colors.blueGrey

                    ),
                  ),
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
                                  'assets/tmpicon.png', color: Colors.lightBlueAccent,),
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
                                  Text(AppLocalizations.of(context).temperature,
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
                                        color: Theme.of(context).primaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          SizedBox(
                            width: screenSize.width * 0.5,
                            height: 300,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  child: Image.asset(
                                    'assets/humicon.png', color: Colors.lightBlueAccent,),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.width * 0.5,
                            height: 300,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  Text(AppLocalizations.of(context).humidity,
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Theme.of(context).primaryColor
                                    ),
                                  ),

                                  Text(
                                    '$hum%',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontFamily: 'ds_digital',
                                        color: Theme.of(context).primaryColor
                                    ),
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
                              'assets/ifn0112.png', color: Colors.lightBlueAccent,)
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
                              Text(AppLocalizations.of(context).air_pressure,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Theme.of(context).primaryColor
                                ),
                              ),

                              Text(
                                '$apr hPa',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'ds_digital',
                                    color: Theme.of(context).primaryColor
                                ),
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
                            'assets/dust-icon-6.jpg', color: Colors.lightBlueAccent,)
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

                              Text('PM2.5',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Theme.of(context).primaryColor
                                ),
                              ),

                              Text(
                                '$dust μg/m^3',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: "ds_digital",
                                    color: Theme.of(context).primaryColor
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),


                  // Stack(
                  // children:[
                  //       Row(
                  //         children:[
                  //         SizedBox(
                  //           width: screenSize.width/2,
                  //           height: 50,
                  //           child: ElevatedButton.icon(
                  //             icon: const Icon(
                  //               Icons.download,
                  //               color: Colors.white,
                  //             ),
                  //             label: const Text('値取得'),
                  //             style: ElevatedButton.styleFrom(
                  //               primary: Colors.green,
                  //               onPrimary: Colors.white,
                  //             ),
                  //             onPressed: () async {
                  //               WidgetsFlutterBinding.ensureInitialized();
                  //               await Firebase.initializeApp();
                  //               final ref = FirebaseDatabase.instance.ref();
                  //               // final event = await ref.once(DatabaseEventType.value);
                  //               // final tmp = event.snapshot.value?.temperature ?? 'Anonymous';
                  //               final tmpsnapshot = await ref.child('weather/temperature/now')
                  //                   .get();
                  //               final humsnapshot = await ref.child('weather/humidity/now')
                  //                   .get();
                  //
                  //               if (tmpsnapshot.exists) {
                  //                 print(tmpsnapshot
                  //                     .child('tag1')
                  //                     .value);
                  //                 setState(() {
                  //                   tmp = tmpsnapshot
                  //                       .child('tag1')
                  //                       .value;
                  //                   hum = humsnapshot
                  //                       .child('tag1')
                  //                       .value;
                  //                 });
                  //               } else {
                  //                 print('No data available.');
                  //               }
                  //             },
                  //           ),
                  //         ),
                  //         const SizedBox(
                  //           height: 20,
                  //         ),
                  //
                  //         SizedBox(
                  //           width: screenSize.width/2,
                  //           height: 50,
                  //           child: ElevatedButton.icon(
                  //             icon: const Icon(
                  //               Icons.show_chart,
                  //               color: Colors.white,
                  //             ),
                  //             label: const Text('グラフ'),
                  //             style: ElevatedButton.styleFrom(
                  //               primary: Colors.green,
                  //               onPrimary: Colors.white,
                  //             ),
                  //             onPressed: () async {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(builder: (context) => const NextPage()),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  // ),
                  //   ],
                  //       ),
                  // bottomNavigationBar: BottomNavigationBar(
                  //   items: const[
                  //     BottomNavigationBarItem(
                  //         icon: Icon(Icons.home),
                  //         label:  'Home'
                  //     ),
                  //     BottomNavigationBarItem(
                  //         icon: Icon(Icons.home),
                  //         label: 'Home'
                  //     ),
                  //   ],
                  // ),
                ]
            ),
          )
      ),

    );

  }
}
