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
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return GlassMorphism(
        color: Colors.black,
        start: 0.3,
        end: 0.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: textEditingController,
                onChanged: (value) {
                  textEditingController.text = value;
                },
                maxLength: 20,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    splashColor: Colors.amber,
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      if (textEditingController.text.isNotEmpty) {
                        await ref.read(weatherServiceProvider).getWeatherCards(
                            context,
                            textEditingController.text.toLowerCase().trim());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Something Went Wrong!!')));
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
      );
    },
  );
}

Future<String?> checkLocationPermission() async {
  var status = await Permission.location.status;
  print("${status} checkLocationPermission");
  if (status.isGranted) {
    print("fetching location");
    return _getLocation();
  } else {
    status = await Permission.location.request();
    if (status.isGranted) {
      return _getLocation();
    }
  }
}

Future<String?> _getLocation() async {
  try {
    print('getlocation');
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 3),
    );
    print('fetched');

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks.first;

    return '${place.locality}';
  } catch (e) {
    print('Location error!!');
  }
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      backgroundColor: Colors.red,
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
