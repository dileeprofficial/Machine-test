import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../models/searchHistory.dart';
import '../viewModel/searchViewModel.dart';

class ResultsScreen extends StatefulWidget {
  final String startLocation;
  final String endLocation;
  final LatLng startLatLng;
  final LatLng endLatLng;

  ResultsScreen(
      {required this.startLocation,
      required this.endLocation,
      required this.startLatLng,
      required this.endLatLng});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  MapboxMapController? mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _fetchAndDisplayRoute();
  }

  Future<void> _fetchAndDisplayRoute() async {
    final start =
        '${widget.startLatLng.longitude},${widget.startLatLng.latitude}';
    final end = '${widget.endLatLng.longitude},${widget.endLatLng.latitude}';

    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/$start;$end?access_token=${dotenv.get('MAPBOX_ACCESS_TOKEN')}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final geometry = json['routes'][0]['geometry'];
      //final decodedGeometry = _decodePolyline(geometry);
     // _addRouteToMap(decodedGeometry);
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  // List<LatLng> _decodePolyline(String polyline) {
  //   var points = PolylinePoints().decodePolyline(polyline);
  //   List<LatLng> decodedCoords =
  //       points.map((point) => LatLng(point.latitude, point.longitude)).toList();
  //   return decodedCoords;
  // }

  // void _addRouteToMap(List<LatLng> points) {
  //   final line = Polyline(
  //     polylineId: PolylineId('route'),
  //     points: points,
  //     width: 5,
  //     color: Colors.blue,
  //   );
  //   mapController?.addPolyline(line);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 32, right: 16, bottom: 16, top: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.startLocation,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Divider(height: 1,),
                  Text(
                    widget.endLocation,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MapboxMap(
                accessToken: dotenv.get('MAPBOX_ACCESS_TOKEN'),
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: widget.startLatLng,
                  zoom: 11.0,
                ),
        
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade600, Colors.blue.shade300],
                ),
              ),
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  final searchHistory = SearchHistory(
                    startLocation: widget.startLocation,
                    endLocation: widget.endLocation,
                    searchDate: DateTime.now(),
                    startLatitude: widget.startLatLng.latitude,
                    startLongitude: widget.startLatLng.longitude,
                    endLatitude: widget.endLatLng.latitude,
                    endLongitude: widget.endLatLng.longitude,
                  );
                  Provider.of<SearchViewModel>(context, listen: false)
                      .addSearchHistory(searchHistory);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, backgroundColor: Colors.white,
        
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                ),
                child: Text('Save', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

