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
  late Future<List<TireModel>> _tiresFuture;
  late Future<List<int?>> rimDiameters;
  final TextEditingController _search = TextEditingController();
  bool _showSearchBar = false;
  int? selectedRimDiameter = 0;
  String item = "";

  @override
  void initState() {
    super.initState();
    _tiresFuture = _loadTires();
    rimDiameters = _loadRimSize();
  }

  Future<List<TireModel>> _loadTires() async {
    try {
      // Attempt to load the JSON file
      final jsonString =
          await rootBundle.loadString('lib/assets/data/tireData.json');
      // Decode the JSON file
      final List<dynamic> jsonData = jsonDecode(jsonString);
      // Map each item in the list to a TireModel instance
      final List<TireModel> tires =
          jsonData.map((item) => TireModel.fromMap(item)).toList();

      return tires;
    } catch (e) {
      print('Error loading tires data: $e');
      throw Exception('Failed to load tire data. Asset may not exist.');
    }
  }

  Future<List<int?>> _loadRimSize() async {
    try {
      final json = await _loadTires();
      // Convert the mapped list to a Set to remove duplicates
      final Set<int?> uniqueRimDiameters =
          json.map((item) => item.rimDiameter).toSet();

      // Convert the Set back to a List if necessary and prepend null for "All"
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
    // If selectedRimDiameter is null, return all tires filtered by searchTerm
    if (selectedRimDiameter == 0) {
      return tires.where((tire) {
        final List<String> knownAttributes = [
          'tireSize',
          'loadIndex',
          'threadPattern',
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
      // Filter tires by both searchTerm and selectedRimDiameter
      return tires.where((tire) {
        final List<String> knownAttributes = [
          'tireSize',
          'loadIndex',
          'threadPattern',
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
        // return tire.rimDiameter == selectedRimDiameter &&
        //     tire
        //         .getAttribute('tireSize')
        //         .toString()
        //         .toLowerCase()
        //         .contains(searchTerm.toLowerCase());
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
            future:
                rimDiameters, // Assuming this is already initialized somewhere in your code
            builder:
                (BuildContext context, AsyncSnapshot<List<int?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show loading indicator while waiting
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Handle error case
              } else {
                // Build DropdownButton with items from the snapshot.data
                return Container(
                  // Example properties for the Container
                  padding:
                      EdgeInsets.all(8.0), // Adds padding inside the container
                  margin: EdgeInsets.symmetric(
                      horizontal:
                          20.0), // Adds horizontal margins outside the container
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //       color:
                  //           Colors.grey), // Adds a border around the container
                  //   borderRadius: BorderRadius.circular(
                  //       5.0), // Makes the border corners rounded
                  // ),

                  child: DropdownButton<int?>(
                    value:
                        selectedRimDiameter, // Make sure this is defined in your state
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
      body: FutureBuilder<List<TireModel>>(
        future: _tiresFuture.then(
            (tires) => _filterTiresBySize(tires, item, selectedRimDiameter)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error loading tires: ${snapshot.error}');
            return Center(child: Text('Error loading tires'));
          } else {
            // Create a GridView with the tire data
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust based on your UI needs
                childAspectRatio: 2 / 3, // Adjust based on your UI needs
              ),
              itemBuilder: (context, index) {
                final tire = snapshot.data![index];
                return TireCard(tire: tire);
              },
            );
          }
        },
      ),
    );
  }
}
