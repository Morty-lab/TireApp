import 'dart:convert';
import 'dart:math';
import 'package:app/components/Card.dart';
import 'package:app/pages/tire.dart';
import 'package:app/widgets/fade_animation.dart';
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


  List<String> tires = ['ct-1.jpg', 'ct-2.jpg', 'ct-3.png', 'ct-4.png', 'ct-5.png', 'ct-3.png'];

  String getRandomTire() {
    final random = Random();
    int index = random.nextInt(tires.length);
    return 'lib/assets/images/${tires[index]}';
  }

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
        backgroundColor: const Color(0xFFE60012),
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
                        color: Colors.white,
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
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  )
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        value: item,
                        child: Text(displayText, style: TextStyle(
                          color: selectedRimDiameter == item ? Colors.white : const Color(0xFFE60012)
                        ),),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
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
            // child: GridView.builder(
            //   controller: _scrollController,
            //   itemCount:
            //       _filterTiresBySize(_tires, item, selectedRimDiameter).length,
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     childAspectRatio: 2 / 3,
            //   ),
            //   itemBuilder: (context, index) {
            //     final tire = _filterTiresBySize(
            //         _tires, item, selectedRimDiameter)[index];
            //     return TireCard(tire: tire);
            //   },
            // ),
            child: ListView.builder(
              controller: _scrollController,
                itemCount:
                _filterTiresBySize(_tires, item, selectedRimDiameter).length,
              itemBuilder: (context, index) {
                final tireItem = _filterTiresBySize(
                    _tires, item, selectedRimDiameter)[index];
                // return TireCard(tire: tire);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  child: FadeAnimation(0.7 + (index * 0.1), makeItem(
                    image:  getRandomTire(),
                    tag: 'blue',
                    context: context,
                    tire: tireItem
                  )),
                );
              }
            ),
          ),
          if (_isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget makeItem({image, tag, context, required TireModel tire}) {
    return Hero(
      tag: tire.tireSize!,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Tire(image: image, tire: tire,)));
        },
        child: Container(
          height: 250,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[400]!,
                    blurRadius: 10,
                    offset: const Offset(0, 10)
                )
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(1, Text(tire.tireSize!, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)),
                        const SizedBox(height: 10,),
                        FadeAnimation(1.1, Text(tire.loadIndex!, style: const TextStyle(color: Colors.white, fontSize: 20),)),
                        const SizedBox(height: 10,),
                        FadeAnimation(1.1, Text(tire.threadPattern!, style: const TextStyle(color: Colors.white, fontSize: 20),)),
                      ],
                    ),
                  ),
                  FadeAnimation(1.2, Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                    child: const Center(
                      child: Icon(Icons.favorite_border, size: 20,),
                    ),
                  ))
                ],
              ),
              FadeAnimation(1.2, Text('₱ ${tire.unitPrice!.toString()}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)),
            ],
          ),
        ),
      ),
    );
  }
}
