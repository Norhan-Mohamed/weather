import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/Api.dart';
import 'package:weatherapp/Model/singleForecastRead.dart';
import 'package:weatherapp/Model/weatherResponse.dart';

class Home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {
  DateTime date = DateTime.now();
  final tomorrow = DateTime.now().add(const Duration(days: 1));
  final twoDaysfromNow = DateTime.now().add(const Duration(days: 2));
  final ThreeDaysFromNow = DateTime.now().add(const Duration(days: 3));
  final FourDaysFromNow = DateTime.now().add(const Duration(days: 4));

  List<SingleForecastRead> fiveDaysWeather = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<WeatherResponse>(
            future: Api().getData(),
            builder: (context, snapShot) {
              if (snapShot.hasError) {
                print(snapShot.error.toString());
              }
              if (snapShot.hasData) {
                //here
                if (snapShot.data!.list
                    .where((element) =>
                        element.dt_txt.split("") ==
                        fiveDaysWeather.first.dt_txt.split(""))
                    .isNotEmpty) {
                  print(fiveDaysWeather);
                } else {
                  fiveDaysWeather.add(snapShot.data!.list.first);
                }
/*
                snapShot.data!.list.forEach((element) {
                  // snapShot.data!.list.first.dt_txt.split("")[0] ==
                  // fiveDaysWeather.indexOf(element);
                  if (snapShot.data!.list.first.dt_txt.split("")[0] ==
                      fiveDaysWeather[0]) {
                    print(fiveDaysWeather);
                  }else{
                    fiveDaysWeather.add(snapShot.data!.list.first);
                  }
                });
*/
                print(snapShot.data!.toMap().toString());
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff4480c6), Color(0xff37489b)])),
                  child: Center(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 250,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.white, width: 4.0),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0)),
                              ),
                              child: Center(
                                child: Text(
                                  snapShot.data!.city.name,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 90,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                border: Border.all(
                                    color: Colors.deepOrange, width: 4.0),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Search',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        snapShot.data!.city.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(snapShot.data!.list.first.weather.first.icon),
                      SizedBox(height: 20),
                      Text(snapShot.data!.list.first.main.temp.toString()),
                      SizedBox(height: 5),
                      Text('H:' +
                          snapShot.data!.list.first.main.temp_max.toString() +
                          ' L:' +
                          snapShot.data!.list.first.main.temp_min.toString()),
                      SizedBox(height: 20),
                      Row(children: [
                        Container(
                          child: Column(
                            children: [
                              //  for(var i in fiveDaysWeather){}

                              Text(DateFormat.E().format(date)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(snapShot.data!.list.first.main.temp
                                  .toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(DateFormat.E().format(tomorrow)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(fiveDaysWeather[8].main.temp.toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(DateFormat.E().format(twoDaysfromNow)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(fiveDaysWeather[16].main.temp.toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(DateFormat.E().format(ThreeDaysFromNow)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(fiveDaysWeather[24].main.temp.toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(DateFormat.E().format(FourDaysFromNow)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(fiveDaysWeather[32].main.temp.toString()),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  )),
                );
              }
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                  height: 100,
                  width: 100,
                ),
              );
            }),
      ),
    );
  }
}
