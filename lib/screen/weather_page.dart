import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

import '../model/weather_forcast_model.dart';
import '../model/weather_model.dart';
import '../service/weather_service.dart';
import '../widgets/forecast.dart';
import '../widgets/glassmorphis.dart';
import '../widgets/more_info.dart';
import 'cities_weather_screen.dart';

class WeatherPage extends ConsumerStatefulWidget {
  final String cityName;
  const WeatherPage({super.key, required this.cityName});

  @override
  ConsumerState<WeatherPage> createState() => WeatherPageState();
}

class WeatherPageState extends ConsumerState<WeatherPage> {
  String getWeatherAnimation(String? mianCondition) {
    if (mianCondition == null) return 'assets/cloudy.json';
    switch (mianCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/cloudy.json';
    }
  }

  late Future<Map<String, dynamic>> weatherData;

  void fetchWeather() async {
    print("${widget.cityName} weather Page Widget");
    weatherData = ref
        .read(weatherServiceProvider)
        .getWeatherData(context, widget.cityName);
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: FutureBuilder<Map<String, dynamic>>(
          future: ref
              .watch(weatherServiceProvider)
              .getWeatherData(context, widget.cityName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset('assets/loadingLocation.json'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Lottie.asset('assets/error_loader.json'),
              );
            } else if (snapshot.data == null) {
              return Center(
                child: Lottie.asset('assets/location_not_found.json'),
              );
            }
            Map<String, dynamic> weatherMap = snapshot.data!;
            Weather weather = weatherMap['weather'];
            String cityImage = weatherMap['cityImage'];

            return Stack(
              children: [
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Image.network(
                    cityImage,
                    fit: BoxFit.cover,
                  ),
                ),
                LiquidPullToRefresh(
                  onRefresh: () async {
                    setState(() {
                      weatherData = ref
                          .read(weatherServiceProvider)
                          .getWeatherData(context, 'kolkata');
                    });
                  },
                  child: ListView(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  print('finding location');
                                  final city = await checkLocationPermission();
                                  print('location fetch');
                                  if (city != null) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WeatherPage(cityName: city),
                                        ));
                                  } else {
                                    print('location found');
                                    showSnack(
                                        context, 'Failed to find location');
                                  }
                                  print('something is not right');
                                },
                                icon: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 31,
                                ),
                              ),
                              Text(
                                weather.cityName,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const CitiesWeatherScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 31,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('MMMM d')
                              .format(DateTime.now())
                              .toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Updated as of ${DateFormat('h:mm a').format(weather.timestamp)} GMT ${weather.timeZone ~/ 3600}:${(weather.timeZone % 3600) ~/ 60}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: size.height / 4,
                          child: Lottie.asset(
                              getWeatherAnimation(weather.mianCondition)),
                        ),
                        Text(
                          weather.mianCondition,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Stack(
                          children: [
                            const Positioned(
                              right: 0,
                              child: Text(
                                '\u2103',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  weather.temp,
                                  // textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontSize: 66,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MoreInfo(
                              icon: Icons.water_drop_outlined,
                              infoName: 'Humidity',
                              infoData: '${weather.humidity}%',
                            ),
                            MoreInfo(
                              icon: Icons.air_outlined,
                              infoName: 'Wind',
                              infoData: '${weather.windSpeed}km/h',
                            ),
                            MoreInfo(
                              icon: Icons.thermostat_outlined,
                              infoName: 'Feels Like',
                              infoData: '${weather.feelsLike}\u00B0',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GlassMorphism(
                            color: Colors.black,
                            start: 0.2,
                            end: 0,
                            child: Container(
                              height: size.height * 0.20,
                              width: size.width,
                              padding: const EdgeInsets.all(15),
                              child: FutureBuilder(
                                future: ref
                                    .watch(weatherServiceProvider)
                                    .getWeatherForecastData(context, 'Kolkata'),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: Lottie.asset(
                                            'assets/loadingLinear.json'));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  } else {
                                    return ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      itemExtent: size.width / 5,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        WeatherForeCastModel
                                            weatherForecastData =
                                            snapshot.data![index];
                                        DateTime dateTime =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                weatherForecastData.timestamp *
                                                    1000);
                                        String formattedDate =
                                            DateFormat('E d').format(dateTime);
                                        return Forecast(
                                            date: formattedDate,
                                            weatherIcon:
                                                weatherForecastData.weatherIcon,
                                            temp: weatherForecastData.temp
                                                .toString(),
                                            windSpeed: weatherForecastData
                                                .windSpeed
                                                .toString());
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            );
          }),
    );
  }
}
