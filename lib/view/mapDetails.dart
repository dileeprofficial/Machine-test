import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapDetails extends StatelessWidget {
  final LatLng latLng;
  final Function(MapboxMapController) onMapCreate;

  const MapDetails({Key? key, required this.latLng, required this.onMapCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      initialCameraPosition: CameraPosition(
        target: latLng,
        zoom: 13,
      ),
      onMapCreated: (MapboxMapController controller) {
        onMapCreate(controller);
      },
      accessToken: dotenv.get('MAPBOX_ACCESS_TOKEN'),
    );
  }
}

void addMarker(MapboxMapController controller, LatLng latLng) async {
  var byteData = await rootBundle.load("assets/location.png");
  var markerImage = byteData.buffer.asUint8List();

  controller.addImage('marker', markerImage);

  await controller.addSymbol(
    SymbolOptions(
      iconSize: 1,
      iconImage: "marker",
      geometry: latLng,
      iconAnchor: "bottom",
    ),
  );
}
