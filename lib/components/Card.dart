import 'package:app/models/TireModel.dart';
import 'package:flutter/material.dart';

class TireCard extends StatefulWidget {
  final TireModel tire;
  const TireCard({super.key, required this.tire});

  @override
  State<TireCard> createState() => _CardState();
}

class _CardState extends State<TireCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)), // Rounded corners
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
            Text(widget.tire.tireSize ?? '',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)), // Bold tire size
            SizedBox(height: 5.0), // Small space between texts
            Text(widget.tire.loadIndex ?? '',
                style: TextStyle(
                    color: Colors.grey[700])), // Load index with grey color
            Text(widget.tire.threadPattern ?? '',
                style: TextStyle(
                    color: Colors.grey[700])), // Thread pattern with grey color
            SizedBox(height: 5.0), // Small space before price
            Text('\$${widget.tire.unitPrice.toString()}',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent)), // Highlighted unit price
            SizedBox(height: 10.0), // Space before chip
            if (widget.tire.isNew != false)
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
    ;
  }
}
