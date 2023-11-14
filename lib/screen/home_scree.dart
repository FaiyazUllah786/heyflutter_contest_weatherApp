import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/add_weather_cards.dart';
import 'package:flutter_application_1/screen/cities_weather_screen.dart';
import 'package:flutter_application_1/screen/weather_page.dart';
import 'package:flutter_application_1/utility/util.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String?> checkLocation;

  @override
  void initState() {
    super.initState();
    checkLocation = checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkLocation,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Lottie.asset('assets/loadingLocation.json'));
            } else if (snapshot.hasError) {
              return AddWeatherCards();
            } else if (snapshot.data == null) {
              showSnack(context, 'Location not found.,\nplease try again!!');
              return AddWeatherCards();
            }
            return WeatherPage(cityName: snapshot.data!);
          }),
    );
  }
}
