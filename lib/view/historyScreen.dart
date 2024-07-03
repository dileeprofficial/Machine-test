import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:machine_test/view/homeScreen.dart';
import 'package:machine_test/view/resultsScreen.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

import '../viewModel/searchViewModel.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SearchViewModel>(
          builder: (context, searchViewModel, child) {
            return Column(children: [
              ProfileCard(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: searchViewModel.searchHistory.length,
                  itemBuilder: (context, index) {
                    final history = searchViewModel.searchHistory[index];
                    return GestureDetector(
                      child: CustomStyledContainer(
                        children: [
                          SizedBox(
                            height: 200,
                            child: MapboxMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(history.startLatitude, history.startLongitude),
                                zoom: 13,
                              ),
                              // onMapCreated: (MapboxMapController controller) {
                              //   model.setMapControllerEnd(controller);
                              // },
                              accessToken: dotenv.get('MAPBOX_ACCESS_TOKEN'),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsScreen(
                              startLocation: history.startLocation,
                              endLocation: history.endLocation,
                              startLatLng: LatLng(
                                  history.startLatitude, history.startLongitude),
                              endLatLng:
                                  LatLng(history.endLatitude, history.endLongitude),
                            ),
                          ),
                        );
                      },
                    );
                  },
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
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue, backgroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                  ),
                  child: Text('Go Back', style: TextStyle(color: Colors.blue)),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
