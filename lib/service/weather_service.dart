import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/weather_card_model.dart';
import 'package:flutter_application_1/model/weather_forcast_model.dart';
import 'package:flutter_application_1/model/weather_model.dart';
import 'package:flutter_application_1/screen/cities_weather_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as https;
import 'package:intl/intl.dart';

final weatherServiceProvider = Provider((ref) => WeatherService());

class WeatherService {
  String baseUrl = 'https://api.openweathermap.org/data/2.5/weather?';
  String apiKey = dotenv.env['WEATHER_API_KEY']!;
  String accessKey = dotenv.env['UNSPLASH_API_KEY']!;

  //city images
  Future<List<dynamic>> getImagesCity(String cityName) async {
    try {
      final response = await https.get(
        Uri.parse('https://api.unsplash.com/search/photos?query=$cityName'),
        headers: {'Authorization': 'Client-ID $accessKey'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        return data.map((result) => result['urls']['regular']).toList();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Map<String,dynamic> weatherData;

  Future<Map<String, dynamic>> getWeatherData(
      BuildContext context, String cityName) async {
    Weather? weather;
    String cityImage = '';
    try {
      Uri url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=${apiKey}&units=metric');
      https.Response response = await https.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> weatherData = jsonDecode(response.body);
        Weather weatherModel = Weather.fromJson(weatherData);
        weather = weatherModel;
        String day = 'day';
        int hour = weatherModel.timestamp.hour;
        if (hour >= 0 && hour < 6) {
          day = 'morning';
        } else if (hour >= 6 && hour < 12) {
          day = 'day';
        } else if (hour >= 12 && hour < 17) {
          day = 'afternoon';
        } else if (hour >= 17 && hour < 20) {
          day = 'Evening';
        } else {
          day = 'night';
        }

        List<dynamic> cityImages = await getImagesCity(
            '${weatherModel.cityName} ${weatherModel.mianCondition} $day');
        cityImage = cityImages[Random().nextInt(cityImages.length - 1)];
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    return {'weather': weather, 'cityImage': cityImage};
  }

  Future<List<WeatherForeCastModel>> getWeatherForecastData(
      BuildContext context, String cityName) async {
    List<WeatherForeCastModel> weatherForeCastModelList = [];
    try {
      Uri forecastUrl = Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=${cityName}&appid=${apiKey}&units=metric');
      https.Response forecastResponse = await https.get(forecastUrl);

      if (forecastResponse.statusCode == 200) {
        Map<String, dynamic> weatherForecast =
            jsonDecode(forecastResponse.body);
        List<dynamic> forecasts = weatherForecast['list'];
        List<WeatherForeCastModel> dailyForecastData = forecasts
            .where((forecast) {
              // print(DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000));
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);

              return (dateTime.hour == 11 && dateTime.minute == 30);
            })
            .map((forecast) => WeatherForeCastModel.fromJson(forecast))
            .toList();
        weatherForeCastModelList = dailyForecastData;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(forecastResponse.reasonPhrase ??
                forecastResponse.statusCode.toString())));
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      throw 'error fetching weather!';
    }
    return weatherForeCastModelList;
  }

  final List<WeatherCardModel> _weatherCardModelList = [];

  Future<List<WeatherCardModel>> getWeatherCards(
      BuildContext context, String cityName) async {
    try {
      Uri weatherCardUrl = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=${apiKey}&units=metric');
      https.Response weatherCard = await https.get(weatherCardUrl);

      if (weatherCard.statusCode == 200) {
        Map<String, dynamic> weatherMap = jsonDecode(weatherCard.body);
        WeatherCardModel weatherCardModel =
            WeatherCardModel.fromJson(weatherMap);
        _weatherCardModelList.removeWhere(
            (element) => element.cityId == weatherCardModel.cityId);
        _weatherCardModelList.add(weatherCardModel);
        print(
            '${_weatherCardModelList.length},city Id: ${weatherCardModel.cityId} ');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(weatherCard.reasonPhrase ??
                weatherCard.statusCode.toString())));
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return _weatherCardModelList;
  }
}
