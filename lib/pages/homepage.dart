import 'dart:convert';

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
  final TextEditingController _search = TextEditingController();
  bool _showSearchBar = true;
  String item = "";

  @override
  void initState() {
    super.initState();
    _tiresFuture = _loadTires();
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

  void _onSearch(String text) {
    setState(() {
      item = text;
    });
  }

  List<TireModel> _filterTiresBySize(List<TireModel> tires, String searchTerm) {
    return tires
        .where((tire) =>
            tire.tireSize!.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
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
        future: _tiresFuture.then((tires) => _filterTiresBySize(tires, item)),
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
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0)), // Rounded corners
                  elevation: 5.0, // Shadow effect
                  margin: EdgeInsets.all(10.0), // Margin around the card
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/defaultTireImage.png',
                          height: 69,
                          fit: BoxFit.cover,
                        ), // Display image at the top
                        SizedBox(height: 10.0), // Space between image and text
                        Text(tire.tireSize ?? '',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)), // Bold tire size
                        SizedBox(height: 5.0), // Small space between texts
                        Text(tire.loadIndex ?? '',
                            style: TextStyle(
                                color: Colors
                                    .grey[700])), // Load index with grey color
                        Text(tire.threadPattern ?? '',
                            style: TextStyle(
                                color: Colors.grey[
                                    700])), // Thread pattern with grey color
                        SizedBox(height: 5.0), // Small space before price
                        Text('\$${tire.unitPrice.toString()}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors
                                    .blueAccent)), // Highlighted unit price
                        SizedBox(height: 10.0), // Space before chip
                        if (tire.isNew != false)
                          Chip(
                            label: Text(
                              'New',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
