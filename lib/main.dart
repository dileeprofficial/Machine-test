import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:machine_test/view/homeScreen.dart';
import 'package:machine_test/view/locationSearchWidget.dart';
import 'package:machine_test/view/mapDetails.dart';
import 'package:machine_test/viewModel/searchViewModel.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'models/searchHistory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await dotenv.load(fileName: "assets/.env");
  Hive.registerAdapter(SearchHistoryAdapter());
  await Hive.openBox<SearchHistory>('searchHistoryBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  double latitude = 37.7749;
  double longitude = -122.4194;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Route Finder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
