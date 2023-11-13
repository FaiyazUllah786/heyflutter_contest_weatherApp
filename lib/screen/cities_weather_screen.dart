import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/model/weather_card_model.dart';
import 'package:flutter_application_1/screen/weather_page.dart';

import 'package:flutter_application_1/service/weather_service.dart';
import 'package:flutter_application_1/widgets/glassmorphis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../utility/util.dart';
import '../widgets/weather_card.dart';

class CitiesWeatherScreen extends ConsumerStatefulWidget {
  const CitiesWeatherScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CitiesWeatherScreenState();
}

class _CitiesWeatherScreenState extends ConsumerState<CitiesWeatherScreen> {
  TextEditingController _textEditingController = TextEditingController();

  late Future<List<WeatherCardModel>> weatheCardModelList;

  Future<String> fetchCityList() async {
    return await rootBundle.loadString('assets/city.json');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    weatheCardModelList =
        ref.read(weatherServiceProvider).getWeatherCards(context, 'Kolkata');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(57, 26, 73, 1),
                  Color.fromRGBO(48, 29, 92, 1),
                  Color.fromRGBO(38, 33, 113, 1),
                  Color.fromRGBO(48, 29, 92, 1),
                  Color.fromRGBO(57, 26, 73, 1),
                ],
              ),
            ),
          ),
          Container(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
              child: SafeArea(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saved Locations',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder<List<WeatherCardModel>?>(
                      future: weatheCardModelList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Lottie.asset('assets/loadingLinear.json'),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Lottie.asset('assets/error_loader.json'),
                          );
                        }
                        List<WeatherCardModel> weatherList = snapshot.data!;
                        return Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: weatherList.length,
                            itemBuilder: (context, index) {
                              WeatherCardModel weatheCardModel =
                                  weatherList[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WeatherPage(
                                                cityName:
                                                    weatheCardModel.cityName),
                                          ));
                                      print('go to weather page screen');
                                    },
                                    child: WeatherCards(
                                        cityName: weatheCardModel.cityName,
                                        mainCondition:
                                            weatheCardModel.mainCondition,
                                        humidity: weatheCardModel.humidity,
                                        windSpeed: weatheCardModel.windSpeed,
                                        temp: weatheCardModel.temp,
                                        weatherIcon:
                                            weatheCardModel.weatherIcon),
                                  ),
                                ),
                              );

                              // return WeatherCards(cityName: , mainCondition: weatherForeCastModel.mianCondition, humidity: humidity, windSpeed: windSpeed, temp: temp, weatherIcon: weatherIcon)
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: Material(
                color: Colors.transparent,
                child: GlassMorphism(
                  start: 0.5,
                  end: 0.2,
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      await addCityCard(context, ref, _textEditingController);
                      setState(() {});
                    },
                    child: Container(
                      height: 60,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Add new',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
