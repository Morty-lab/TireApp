import 'dart:convert';

import 'package:app/components/Card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/TireModel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _search = TextEditingController();
  bool _showSearchBar = false;
  int? selectedRimDiameter = 0;
  String item = "";
  int maxItems = 10;
  List<TireModel> _tires = [];
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadTires(maxItems);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMoreData) {
      // User has scrolled to the bottom, load more items
      setState(() {
        _isLoadingMore = true;
        maxItems += 10;
      });
      _loadTires(10);
    }
  }

  Future<void> _loadTires(int limit) async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/assets/data/tireData.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);

      if (_tires.length + limit >= jsonData.length) {
        limit = jsonData.length - _tires.length;
        _hasMoreData = false;
      }

      final List<TireModel> newTires = [];
      for (int i = _tires.length; i < _tires.length + limit; i++) {
        newTires.add(TireModel.fromMap(jsonData[i]));
      }

      setState(() {
        _tires.addAll(newTires);
        _isLoadingMore = false;
      });
    } catch (e) {
      print('Error loading tires data: $e');
      throw Exception('Failed to load tire data. Asset may not exist.');
    }
  }

  Future<List<int?>> _loadRimSize() async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/assets/data/tireData.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final List<TireModel> tires =
          jsonData.map((data) => TireModel.fromMap(data)).toList();

      final Set<int?> uniqueRimDiameters =
          tires.map((item) => item.rimDiameter).toSet();
      final List<int?> rimDiameter = [0, ...uniqueRimDiameters.toList()];

      return rimDiameter;
    } catch (e) {
      print('Error loading rimDiameter data: $e');
      throw Exception('Failed to load tire data. Asset may not exist.');
    }
  }

  void _onSearch(String text) {
    setState(() {
      item = text;
    });
  }

  List<TireModel> _filterTiresBySize(
      List<TireModel> tires, String searchTerm, int? selectedRimDiameter) {
    if (selectedRimDiameter == 0) {
      return tires.where((tire) {
        final List<String> knownAttributes = [
          'tireSize',
          'loadIndex',
          'threadPattern'
        ];
        for (var attr in knownAttributes) {
          if (tire
              .getAttribute(attr)
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
            return true;
          }
        }
        return false;
      }).toList();
    } else {
      return tires.where((tire) {
        final List<String> knownAttributes = [
          'tireSize',
          'loadIndex',
          'threadPattern'
        ];
        for (var attr in knownAttributes) {
          if (tire
              .getAttribute(attr)
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
            return tire.rimDiameter == selectedRimDiameter &&
                tire
                    .getAttribute(attr)
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase());
          }
        }
        return false;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showSearchBar
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _search,
                  onChanged: _onSearch,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: "Search.."),
                ),
              )
            : const Text("Tire Catalog"),
        actions: <Widget>[
          FutureBuilder<List<int?>>(
            future: _loadRimSize(),
            builder:
                (BuildContext context, AsyncSnapshot<List<int?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButton<int?>(
                    value: selectedRimDiameter,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedRimDiameter = newValue;
                      });
                    },
                    items: snapshot.data!.map((int? item) {
                      String displayText = item == 0 ? "All" : item.toString();
                      return DropdownMenuItem<int?>(
                        child: Text(displayText),
                        value: item,
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              itemCount:
                  _filterTiresBySize(_tires, item, selectedRimDiameter).length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                final tire = _filterTiresBySize(
                    _tires, item, selectedRimDiameter)[index];
                return TireCard(tire: tire);
              },
            ),
          ),
          if (_isLoadingMore)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
