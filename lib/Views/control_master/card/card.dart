import 'package:flutter/material.dart';
import 'package:testappbita/model/card_model.dart';

class CardView extends StatelessWidget {
  final CardModel cardModel;
  final Function onTap; // Define onTap as a callback

  CardView(
      {required this.cardModel, required this.onTap}); // Pass onTap callback

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(), // Trigger onTap callback
      child: Card(
        elevation: 8, // Increased elevation for more shadow effect
        margin: EdgeInsets.symmetric(
            horizontal: 10, vertical: 10), // More margin for spacing
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              15), // Rounded corners for a more modern look
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue, // Set the border color (blue in this case)
              width: 4, // Border width of 4px
            ),
            borderRadius:
                BorderRadius.circular(15), // Rounded corners for the border
          ),
          padding:
              EdgeInsets.all(18), // Padding inside the card for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                cardModel.title,
                style: TextStyle(
                  fontSize: 24, // Larger font size for title
                  fontWeight: FontWeight.bold, // Bold for emphasis
                  color: Colors.black, // Dark text color for readability
                ),
              ),
              SizedBox(height: 8), // Space between title and subtitle
              Text(
                cardModel.subtitle,
                style: TextStyle(
                  fontSize: 16, // Slightly smaller font size for subtitle
                  color: Colors.grey[600], // Grey color for subtlety
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
