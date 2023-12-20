import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportInfoUpdateScreen extends StatefulWidget {
  @override
  _SupportInfoUpdateScreenState createState() =>
      _SupportInfoUpdateScreenState();
}

class _SupportInfoUpdateScreenState extends State<SupportInfoUpdateScreen> {
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Function to fetch existing user information and populate the TextFields
    fetchSupportInfo();
  }

  Future<void> fetchSupportInfo() async {
    try {
      // Fetch user information assuming 'userId' is the user's document ID
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('admin').doc('support').get();

      // Extract data from the snapshot and populate the TextFields
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data()!;
        _facebookController.text = userData['facebookGroup'] ?? '';
        _whatsappController.text = userData['whatsappNumber'] ?? '';
        _gmailController.text = userData['gmail'] ?? '';
      }
    } catch (e) {
      // Handle errors here, e.g., show an error message
      print('Error fetching user information: $e');
    }
  }

  Future<void> updateUserInformation() async {
    String facebook = _facebookController.text.trim();
    String whatsapp = _whatsappController.text.trim();
    String gmail = _gmailController.text.trim();

    // Update user information in Firestore
    await _firestore.collection('admin').doc('support').set({
      'facebookGroup': facebook,
      'whatsappNumber': whatsapp,
      'gmail': gmail,
    });

    // Show a success message or navigate to another screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User information updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Support Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _facebookController,
              decoration: const InputDecoration(labelText: 'Facebook Group'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _whatsappController,
              decoration: const InputDecoration(labelText: 'WhatsApp Number'),
            ),const SizedBox(height: 20),
            TextFormField(
              controller: _gmailController,
              decoration: const InputDecoration(labelText: 'Gmail'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateUserInformation();
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
