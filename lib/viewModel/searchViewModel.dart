import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/searchHistory.dart';

class SearchViewModel extends ChangeNotifier {
  Box<SearchHistory> searchHistoryBox = Hive.box<SearchHistory>('searchHistoryBox');

  List<SearchHistory> _searchHistory = [];
  List<SearchHistory> get searchHistory => _searchHistory;

  void addSearchHistory(SearchHistory history) {
    searchHistoryBox.add(history);
    _searchHistory = searchHistoryBox.values.toList();
    notifyListeners();
  }

  void loadSearchHistory() {
    _searchHistory = searchHistoryBox.values.toList();
    notifyListeners();
  }
}
