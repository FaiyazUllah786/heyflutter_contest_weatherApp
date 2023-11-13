import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/weather_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WeatherPage(cityName: 'Kolkata,IN');
  }
}
