class WeatherCardModel {
  final int cityId;
  final String cityName;
  final String mainCondition;
  final String humidity;
  final String windSpeed;
  final String temp;
  final String weatherIcon;

  WeatherCardModel({
    required this.cityId,
    required this.cityName,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
    required this.temp,
    required this.weatherIcon,
  });

  factory WeatherCardModel.fromJson(Map<String, dynamic> json) {
    return WeatherCardModel(
        cityId: json['id'],
        cityName: json['name'],
        temp: json['main']['temp'].round().toString(),
        windSpeed: (json['wind']['speed'] * 3.6).round().toString(),
        mainCondition: json['weather'][0]['description'].toString(),
        humidity: json['main']['humidity'].toString(),
        weatherIcon: json['weather'][0]['icon']);
  }
}
