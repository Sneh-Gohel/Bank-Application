import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  String studentName = "Sneh Bharatbhai Gohel";
  final double totalBalance = 75000.00;
  bool isEditing = false; // Controls if user is in edit mode

  final List<Map<String, dynamic>> transactionHistory = [
    {"type": "Credit", "amount": 5000, "date": "2024-10-01"},
    {"type": "Debit", "amount": 1000, "date": "2024-09-20"},
    {"type": "Credit", "amount": 3000, "date": "2024-09-15"},
    {"type": "Debit", "amount": 2000, "date": "2024-09-10"},
    {"type": "Credit", "amount": 10000, "date": "2024-09-01"},
  ];

  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = studentName;
  }

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
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                setState(() {
                  studentName = nameController.text;
                  isEditing = false;
                });
                print("Details saved.");
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation();
            },
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 7, 22, 27),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Hero(
                tag: "Folder",
                child: Lottie.asset(
                  'assets/lotties/manAnimation.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                  repeat: true,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildEditableInfoCard("Name", nameController),
            const SizedBox(height: 20),
            _buildInfoCard(
                "Total Balance", "₹ ${totalBalance.toStringAsFixed(2)}"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _showTransactionHistory();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 61, 115, 127),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Text(
                  "History",
                  style: TextStyle(
                    color: Color.fromARGB(255, 206, 199, 191),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Editable Info Card for the Student Name
  Widget _buildEditableInfoCard(
      String title, TextEditingController controller) {
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
        children: [
          Text(
            "$title: ",
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isEditing
              ? Expanded(
                  child: TextField(
                    controller: controller,
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontSize: 20,
                      ),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                )
              : Expanded(
                  child: Text(
                    studentName,
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 199, 191),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Static Info Card for Total Balance
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
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lora(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show Delete Confirmation Dialog
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Confirmation"),
        content: const Text(
          "Data will be permanently deleted. Are you sure you want to continue?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              print("Deleted.");
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Show Transaction History Dialog
  void _showTransactionHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(
            255, 7, 22, 27), // Background color matching theme
        title: Text(
          "Transaction History",
          style: GoogleFonts.lora(
            textStyle: const TextStyle(
              color: Color.fromARGB(
                  255, 61, 115, 127), // Title text color matching app theme
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        content: SizedBox(
          height: 300, // Fixed height to prevent overflow
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: transactionHistory.length,
            itemBuilder: (context, index) {
              final transaction = transactionHistory[index];
              return ListTile(
                leading: Icon(
                  transaction['type'] == 'Credit'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: transaction['type'] == 'Credit'
                      ? const Color.fromARGB(
                          255, 61, 115, 127) // Greenish blue arrow for credit
                      : Colors.redAccent, // Red arrow for debit
                ),
                title: Text(
                  "${transaction['type']}: ₹${transaction['amount']}",
                  style: GoogleFonts.lora(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 206, 199, 191),
                      fontSize: 18,
                    ),
                  ),
                ),
                subtitle: Text(
                  "Date: ${transaction['date']}",
                  style: GoogleFonts.lora(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Close",
              style: GoogleFonts.lora(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 61, 115, 127),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
