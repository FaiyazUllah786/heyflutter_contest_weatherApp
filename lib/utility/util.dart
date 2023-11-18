import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../service/weather_service.dart';
import '../widgets/glassmorphis.dart';

Future<void> addCityCard(BuildContext context, WidgetRef ref,
    TextEditingController textEditingController) async {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return GlassMorphism(
        color: Colors.black,
        start: 0.3,
        end: 0.0,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 18,
              right: 18,
              top: 18),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  // autofocus: true,
                  maxLength: 20,
                  controller: textEditingController,
                  onChanged: (value) {
                    textEditingController.text = value;
                  },
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter city name...',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  return SizedBox();
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      splashColor: Colors.amber,
                      borderRadius: BorderRadius.circular(30),
                      onTap: () async {
                        if (textEditingController.text.isNotEmpty) {
                          await ref
                              .read(weatherServiceProvider)
                              .getWeatherCards(
                                  context,
                                  textEditingController.text
                                      .toLowerCase()
                                      .trim());
                        } else {
                          showSnack(context, 'Something went Wrong');
                        }
                        textEditingController.clear();
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      splashColor: Colors.amber,
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      backgroundColor: Colors.red,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // serviceEnabled = await Geolocator.isLocationServiceEnabled();
  // if (!serviceEnabled) {
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text(
  //           'Location services are disabled. Please enable the services')));
  //   return false;
  // }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}

Future<String?> getCurrentPosition(BuildContext context) async {
  final hasPermission = await _handleLocationPermission(context);
  if (!hasPermission) return null;
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      timeLimit: const Duration(seconds: 25));
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  Placemark place = placemarks.first;

  print(place.locality);
  print(place.isoCountryCode);

  return '${place.locality},${place.isoCountryCode}';
}
