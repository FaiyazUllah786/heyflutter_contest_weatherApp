class WeatherForeCastModel {
  final int timestamp;
  final String weatherIcon;
  final int temp;
  final int windSpeed;
  WeatherForeCastModel(
      {required this.timestamp,
      required this.weatherIcon,
      required this.temp,
      required this.windSpeed});

  factory WeatherForeCastModel.fromJson(Map<String, dynamic> json) {
    return WeatherForeCastModel(
        timestamp: json['dt'],
        weatherIcon: json['weather'][0]['icon'],
        temp: json['main']['temp'].round(),
        windSpeed: json['wind']['speed'].round());
  }
}
