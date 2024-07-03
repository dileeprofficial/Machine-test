import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_search/mapbox_search.dart';

class HomeProvider extends ChangeNotifier {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  late MapboxMapController mapControllerStart;
  late MapboxMapController mapControllerEnd;
  LatLng _geoStart = LatLng(0, 0);
  LatLng _geoEnd = LatLng(0, 0);
  String _locationName = '';

  LatLng get geoStart => _geoStart;
  LatLng get geoEnd => _geoEnd;
  String get locationName => _locationName;

  void setMapControllerStart(MapboxMapController controller) {
    mapControllerStart = controller;
  }

  void setMapControllerEnd(MapboxMapController controller) {
    mapControllerEnd = controller;
  }

  void searchLocationStart(TextEditingController controller) async {

    String apiKey = dotenv.get('MAPBOX_ACCESS_TOKEN'); // Replace with your Mapbox API key
    MapBoxSearch.init(apiKey);

    var placesService = GeoCoding(
      apiKey: apiKey,
      country: "IN",
      limit: 1,
      types: [PlaceType.place],
    );

    ApiResponse<List<MapBoxPlace>> places =
        await placesService.getPlaces(controller.text);

    if (places != null) {
      if (places.success != null && places.success!.isNotEmpty) {
        var place = places.success![0]; // Accessing the first place found
        _locationName = place.placeName ?? '';
        _geoStart =
            LatLng(place.geometry!.coordinates.lat, place.geometry!.coordinates.long);
        mapControllerStart.animateCamera(CameraUpdate.newLatLng(_geoStart));
      } else {
        _locationName = 'Location not found';
      }
    } else {
      _locationName = 'Error occurred';
    }

    notifyListeners();
  }

  void searchLocationStartEnd(TextEditingController controller) async {

    String apiKey = dotenv.get('MAPBOX_ACCESS_TOKEN'); // Replace with your Mapbox API key
    MapBoxSearch.init(apiKey);

    var placesService = GeoCoding(
      apiKey: apiKey,
      country: "IN",
      limit: 1,
      types: [PlaceType.place],
    );

    ApiResponse<List<MapBoxPlace>> places =
        await placesService.getPlaces(controller.text);

    if (places != null) {
      if (places.success != null && places.success!.isNotEmpty) {
        var place = places.success![0]; // Accessing the first place found
        _locationName = place.placeName ?? '';
        _geoEnd =
            LatLng(place.geometry!.coordinates.lat, place.geometry!.coordinates.long);
        mapControllerEnd.animateCamera(CameraUpdate.newLatLng(_geoEnd));
      } else {
        _locationName = 'Location not found';
      }
    } else {
      _locationName = 'Error occurred';
    }

    notifyListeners();
  }
}
