import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepositDetailsModel {
  String depositMethod;

  String number;

  DepositDetailsModel({
    required this.depositMethod,
   
    required this.number,
  });

  factory DepositDetailsModel.fromMap(Map<String, dynamic>? map) {
    return DepositDetailsModel(
      depositMethod: map?['paymentmethod'] ?? '',
      number: map?['number'] ?? "0",
    );
  }
}

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final TextEditingController depositMethodController = TextEditingController();

  final TextEditingController numberController = TextEditingController();



  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: FutureBuilder(
        future: _fetchDepositDetails(),
        builder: (context, AsyncSnapshot<DepositDetailsModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found');
          } else {
            DepositDetailsModel? depositDetails = snapshot.data;
            depositMethodController.text = depositDetails?.depositMethod??'enter payment mathods';
       
            numberController.text = depositDetails?.number??'Enter a Number';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: depositMethodController,
                    decoration: InputDecoration(labelText: 'payment Method'),
                  ),
               SizedBox(height: 10,),
                  TextField(
                    controller: numberController,
                    decoration: InputDecoration(labelText: 'Number'),
                    maxLines: 2,
                    // keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<DepositDetailsModel> _fetchDepositDetails() async {
    var adminCollection = FirebaseFirestore.instance.collection('admin');
    try {
      DocumentSnapshot depositDoc = await adminCollection.doc('payment').get();
      Map<String, dynamic>? depositData = depositDoc['paymentdetails'];
      return DepositDetailsModel.fromMap(depositData);
    } catch (e) {
      throw Exception('Error fetching deposit details: $e');
    }
  }

  void _saveChanges() async {
    var adminCollection = FirebaseFirestore.instance.collection('admin');
    try {
      await adminCollection.doc('payment').set({
        'paymentdetails': {
          'paymentmethod': depositMethodController.text,
          'number': numberController.text,
        },
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data update successrfully"),
        ),
      );
      FocusScope.of(context).unfocus();
      print('Changes saved!');
    } catch (e) {
      print('Error saving changes: $e');
    }
  }
}
