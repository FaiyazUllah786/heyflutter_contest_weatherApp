// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/service/weather_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../model/weather_card_model.dart';

// final weatherServiceController = Provider((ref) {
//   final weatherService = ref.watch(weatherServiceProvider);
//   return WeatherServiceController(
//     weatherService: weatherService,
//   );
// });

// class WeatherServiceController {
//   final WeatherService weatherService;
//   final String cityName;

//   WeatherServiceController({required this.weatherService});

//   Future<List<WeatherCardModel>> fetchCards(BuildContext context) async {
//     return await weatherService.getWeatherCards(context, cityName);
//   }
// }
