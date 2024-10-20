// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HistoryDetailsScreen extends StatefulWidget {
  var HistoryData;
  HistoryDetailsScreen({required this.HistoryData, super.key});

  @override
  State<StatefulWidget> createState() => _HistoryDetailsScreen();
}

class _HistoryDetailsScreen extends State<HistoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 22, 27),
        elevation: 0,
        title: const Text(
          "Student Details",
          style: TextStyle(
            color: Color.fromARGB(255, 61, 115, 127),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 61, 115, 127),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 22, 27),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Lottie.asset(
              'assets/lotties/allHistoryAnimation.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
              repeat: true,
            ),
          ),
          const SizedBox(height: 30),
          const SizedBox(height: 20),
          _buildInfoCard("Student Name:", widget.HistoryData['name']),
          const SizedBox(height: 20),
          _buildInfoCard(
              "Folder Name:", "₹ ${widget.HistoryData['folder_name']}"),
          const SizedBox(height: 20),
          _buildInfoCard("Transaction:", widget.HistoryData['transaction']),
          const SizedBox(height: 20),
          _buildInfoCard("Amount:", widget.HistoryData['amount']),
          const SizedBox(height: 20),
          _buildInfoCard("Transaction Date:", widget.HistoryData['date']),
          const SizedBox(height: 20),
          _buildInfoCard("Remarks:", widget.HistoryData['remarks']),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

Widget _buildInfoCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 61, 115, 127),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Text
        Flexible(
          flex: 2,
          child: Text(
            title,
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10), // Spacing between title and value
        // Value Text with Right Alignment
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right, // Align text to the right
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 20,
              ),
            ),
            maxLines: null, // Allow multiple lines
            overflow: TextOverflow.visible, // Avoid overflow issues
          ),
        ),
      ],
    ),
  );
}
