import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled
    throw Exception('Location services are disabled.');
  }

  // Check location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are permanently denied
    throw Exception('Location permissions are permanently denied.');
  }

  // Get the current position
  return await Geolocator.getCurrentPosition();
}

Future<void> sendLocationToWebview(WebViewController controller) async {
  try {
    Position position = await determinePosition();
    String jsCode = """
        window.dispatchEvent(new CustomEvent('locationUpdate', {
          detail: {
            latitude: ${position.latitude},
            longitude: ${position.longitude}
          }
        }));
      """;
    await controller.runJavaScript(jsCode);
  } catch (e) {
    // print("Error retrieving location: $e");
  }
}
