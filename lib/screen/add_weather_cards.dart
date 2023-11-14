import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/cities_weather_screen.dart';
import 'package:flutter_application_1/screen/weather_page.dart';
import 'package:flutter_application_1/service/weather_service.dart';
import 'package:flutter_application_1/widgets/glassmorphis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class AddWeatherCards extends ConsumerStatefulWidget {
  const AddWeatherCards({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddWeatherCardsState();
}

class _AddWeatherCardsState extends ConsumerState<AddWeatherCards> {
  List<dynamic> cities = [];
  void searchCities(String query) async {
    var listCities = await ref.read(weatherServiceProvider).searchCities(query);
    setState(() {
      cities = listCities;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/minimal.jpg',
                  ),
                  fit: BoxFit.cover),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [],
              // ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: TextField(
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        searchCities(value);
                      } else {
                        cities.clear();
                        setState(() {});
                      }
                      print(cities.length);
                    },
                  ),
                ),
                (cities.isEmpty)
                    ? Container(
                        margin: const EdgeInsets.only(top: 200),
                        child: const Text(
                          'Not Found!!',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: (context, index) {
                            if (cities[index]['name'] != null &&
                                cities[index]['countryName'] != null &&
                                cities[index]['countryCode'] != null) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: InkWell(
                                  onTap: () async {
                                    final data = await ref
                                        .read(weatherServiceProvider)
                                        .getWeatherData(context,
                                            '${cities[index]['name']},${cities[index]['countryCode']}');
                                    if (data != null) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => WeatherPage(
                                            cityName:
                                                '${cities[index]['name']},${cities[index]['countryCode']}'),
                                      ));
                                    }
                                  },
                                  child: GlassMorphism(
                                    color: Colors.white,
                                    start: 0.2,
                                    end: 0,
                                    child: ListTile(
                                      title: Text(
                                        cities[index]['name'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        cities[index]['countryName'],
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white
                                            // color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      // title: Text('hello world'),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
