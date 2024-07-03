import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_search/mapbox_search.dart';

class LocationSearchWidget extends StatefulWidget {
  @override
  _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  late MapboxMapController mapController;
  LatLng _center = LatLng(0, 0);
  late CameraTargetBounds cameraTargetBounds;
  String _locationName = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapbox Location Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter a location...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
              ),
              onSubmitted: (_) => _searchLocation(),
            ),
          ),
          Expanded(
            child: MapboxMap(
              accessToken: dotenv.get('MAPBOX_ACCESS_TOKEN'),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
            ),
          ),
          Text('Location: $_locationName'),
        ],
      ),
    );
  }

  void _onMapCreated(MapboxMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _searchLocation() async {
    String apiKey = dotenv.get(
        'MAPBOX_ACCESS_TOKEN'); // Replace with your Mapbox API key
    MapBoxSearch.init(apiKey);

    var placesService = GeoCoding(
      apiKey: apiKey,
      country: "IN",
      limit: 1,
      types: [PlaceType.place],
    );
    ApiResponse<List<MapBoxPlace>>  places = await placesService.getPlaces(
      _controller.text,
    );
    if (places != null) {
      if (places.success != null && places.success!.isNotEmpty) {
        var place = places.success![0]; // Accessing the first place found
        setState(() {
          _locationName = place.placeName??"";
          _center = LatLng(place.geometry!.coordinates.lat, place.geometry!.coordinates.long);
          mapController.animateCamera(CameraUpdate.newLatLng(_center));
        });
      } else {
        setState(() {
          _locationName = 'Location not found';
        });
      }
    } else {
      setState(() {
        _locationName = 'Error occurred';
      });
    }
    print(places);
  }
}