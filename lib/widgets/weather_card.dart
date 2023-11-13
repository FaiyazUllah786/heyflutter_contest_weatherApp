import 'package:flutter/material.dart';

import 'glassmorphis.dart';

class WeatherCards extends StatelessWidget {
  final String cityName;
  final String mainCondition;
  final String humidity;
  final String windSpeed;
  final String temp;
  final String weatherIcon;

  const WeatherCards({
    super.key,
    required this.cityName,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
    required this.temp,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassMorphism(
      start: 0.5,
      end: 0.2,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cityName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  mainCondition,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Humidity  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$humidity %',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Wind  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${windSpeed} km/h',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 56,
                  child: Image.network(
                    'https://openweathermap.org/img/wn/${weatherIcon}.png',
                  ),
                ),
                SizedBox(
                  // color: Colors.amber,
                  width: 80,
                  child: Stack(
                    children: [
                      const Positioned(
                        right: 0,
                        child: Text(
                          '\u2103',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          temp,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
