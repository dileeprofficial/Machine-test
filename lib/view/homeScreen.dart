import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:machine_test/view/resultsScreen.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../viewModel/homeViewModel.dart';
import 'historyScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, model, _) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileCard(),
                  CustomStyledContainer(
                    children: [
                      TextField(
                        controller: model.startController,
                        decoration: InputDecoration(
                          hintText: 'Enter a location...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => model
                                .searchLocationStart(model.startController),
                          ),
                        ),
                        onSubmitted: (_) =>
                            model.searchLocationStart(model.startController),
                      ),
                      SizedBox(
                        height: 200,
                        child: MapboxMap(
                          initialCameraPosition: CameraPosition(
                            target: model.geoStart,
                            zoom: 13,
                          ),
                          onMapCreated: (MapboxMapController controller) {
                            model.setMapControllerStart(controller);
                          },
                          accessToken: dotenv.get('MAPBOX_ACCESS_TOKEN'),
                        ),
                      ),
                    ],
                  ),
                  CustomStyledContainer(
                    children: [
                      TextField(
                        controller: model.endController,
                        decoration: InputDecoration(
                          hintText: 'Enter a location...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => model
                                .searchLocationStartEnd(model.endController),
                          ),
                        ),
                        onSubmitted: (_) =>
                            model.searchLocationStartEnd(model.endController),
                      ),
                      SizedBox(
                        height: 200,
                        child: MapboxMap(
                          initialCameraPosition: CameraPosition(
                            target: model.geoEnd,
                            zoom: 13,
                          ),
                          onMapCreated: (MapboxMapController controller) {
                            model.setMapControllerEnd(controller);
                          },
                          accessToken: dotenv.get('MAPBOX_ACCESS_TOKEN'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue.shade600, Colors.blue.shade300],
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultsScreen(
                                  startLocation: model.startController.text,
                                  endLocation: model.endController.text,
                                  startLatLng: model.geoStart,
                                  endLatLng: model.geoEnd,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue, backgroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0), // Rounded corners
                            ),
                          ),
                          child: Text('Navigate', style: TextStyle(color: Colors.blue)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HistoryScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue, backgroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0), // Rounded corners
                            ),
                          ),
                          child: Text('Saved Searches', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(90.0),
            child: Image.asset(
              'assets/user.png', // Replace with your image asset path
              width: 100,
              height: 100,
              color: Colors.white,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'john.doe@example.com',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomStyledContainer extends StatelessWidget {
  final List<Widget> children;

  CustomStyledContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.blue,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.children,
      ),
    );
  }
}

