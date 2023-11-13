import 'package:flutter/material.dart';

class Forecast extends StatelessWidget {
  final String date;
  final String weatherIcon;
  final String temp;
  final String windSpeed;
  const Forecast({
    super.key,
    required this.date,
    required this.weatherIcon,
    required this.temp,
    required this.windSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          date,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 50,
          child: Image.network(
            'https://openweathermap.org/img/wn/${weatherIcon}.png',
          ),
        ),
        Stack(
          children: [
            const Positioned(
              right: 0,
              child: Text(
                '\u2103',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                temp,
                // textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Text(
          '${windSpeed} km/h',
          style: const TextStyle(fontSize: 10, color: Colors.white),
        )
      ],
    );
  }
}
