import 'package:app/widgets/fade_animation.dart';
import 'package:flutter/material.dart';

import '../models/TireModel.dart';

class Tire extends StatefulWidget {
  final String image;
  final TireModel tire;

  const Tire({required this.image, required this.tire, super.key});

  @override
  _TireState createState() => _TireState();
}

class _TireState extends State<Tire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Hero(
            tag: widget.tire.tireSize!,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(widget.image),
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
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios, color: Colors.white,),
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                          ),
                          child: const Center(
                            child: Icon(Icons.favorite_border, size: 20,),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    child: FadeAnimation(1, Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.9),
                                Colors.black.withOpacity(.0),
                              ]
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FadeAnimation(1, Text(widget.tire.tireSize!, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)),
                          const SizedBox(height: 10,),
                          FadeAnimation(1.2, Text(widget.tire.loadIndex!, style: const TextStyle(color: Colors.white, fontSize: 20),)),
                          const SizedBox(height: 10,),
                          FadeAnimation(1.3, Text(widget.tire.threadPattern!, style: const TextStyle(color: Colors.white, fontSize: 20),)),
                          const SizedBox(height: 10,),
                          FadeAnimation(1.5, Text('₱ ${widget.tire.unitPrice!.toString()}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)),
                          // Row(
                          //   children: <Widget>[
                          //     FadeAnimation(1.5, Container(
                          //       width: 40,
                          //       height: 40,
                          //       margin: const EdgeInsets.only(right: 20),
                          //       child: const Center(
                          //           child: Text('40', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          //       ),
                          //     )),
                          //     FadeAnimation(1.45, Container(
                          //       width: 40,
                          //       height: 40,
                          //       margin: const EdgeInsets.only(right: 20),
                          //       decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(10)
                          //       ),
                          //       child: const Center(
                          //           child: Text('42', style: TextStyle(fontWeight: FontWeight.bold),)
                          //       ),
                          //     )),
                          //     FadeAnimation(1.46, Container(
                          //       width: 40,
                          //       height: 40,
                          //       margin: const EdgeInsets.only(right: 20),
                          //       child: const Center(
                          //           child: Text('44', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          //       ),
                          //     )),
                          //     FadeAnimation(1.47, Container(
                          //       width: 40,
                          //       height: 40,
                          //       margin: const EdgeInsets.only(right: 20),
                          //       child: const Center(
                          //           child: Text('46', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          //       ),
                          //     )),
                          //   ],
                          // ),
                          const SizedBox(height: 60,),
                          FadeAnimation(1.5, Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: const Center(
                                child: Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold),)
                            ),
                          )),
                          const SizedBox(height: 30,),
                        ],
                      ),
                    )),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}