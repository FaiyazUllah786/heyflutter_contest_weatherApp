class Weather {
  final String cityName;
  final String mianCondition;
  final int windSpeed;
  final int humidity;
  final int feelsLike;
  final String temp;
  final DateTime timestamp;
  final int timeZone;

  Weather(
      {required this.cityName,
      required this.temp,
      required this.windSpeed,
      required this.mianCondition,
      required this.feelsLike,
      required this.humidity,
      required this.timestamp,
      required this.timeZone});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temp: json['main']['temp'].round().toString(),
        windSpeed: (json['wind']['speed'] * 3.6).round(),
        mianCondition: json['weather'][0]['main'].toString(),
        feelsLike: json['main']['feels_like'].round(),
        humidity: json['main']['humidity'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
        timeZone: json['timezone']);
  }
}
