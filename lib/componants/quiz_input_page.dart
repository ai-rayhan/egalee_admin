// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:egalee_admin/componants/dialogs/custom_alert.dart';
// import 'package:egalee_admin/componants/dialogs/deleting_dialog.dart';
// import 'package:egalee_admin/data/firebase_caller/storage/delete.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class QuizInputPage extends StatefulWidget {
//   final String? quizfileLink;
//   QuizInputPage({this.quizfileLink});
//   @override
//   _QuizInputPageState createState() =>
//       _QuizInputPageState();
// }

// class _QuizInputPageState
//     extends State<QuizInputPage> {
//   TextEditingController questionController = TextEditingController();
//   TextEditingController option1Controller = TextEditingController();
//   TextEditingController option2Controller = TextEditingController();
//   TextEditingController option3Controller = TextEditingController();
//   TextEditingController option4Controller = TextEditingController();
//   TextEditingController correctAnswerController = TextEditingController();
//   // TextEditingController explanationController = TextEditingController();

//   List<Map<String, dynamic>> questions = [];
//   bool isLoading = true;

//   fetchData() async {
//     try {
//       if (widget.quizfileLink == null) {
//         isLoading = false;
//         setState(() {});
//         return;
//       }
//       http.Response response = await http.get(Uri.parse(widget.quizfileLink!));

//       if (response.statusCode == 200) {
//         String responseBody =
//             utf8.decode(response.bodyBytes); // Decode using UTF-8

//         List<dynamic> parsedList = jsonDecode(responseBody);
//         List<Map<String, dynamic>> formattedList =
//             parsedList.map((item) => item as Map<String, dynamic>).toList();

//         setState(() {
//           questions = formattedList;
//         });
//         print('Failed to load data: $questions');
//       } else {
//         print('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Exception while fetching data: $e');
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     fetchData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Questions'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: () {
//               // saveQuestionsToFirebaseStorage();
//               showCustomDialog(
//                 context,
//                 title: 'Confirmation',
//                 content: 'Are you sure you want to perform this action?',
//                 onOkPressed: () {
//                   Navigator.pop(context);
//                   showLoadingDialog(context);
//                   FiledeleteUtils.deleteImageFromFirebaseStorage(
//                       widget.quizfileLink);
//                   saveQuestionsToFirebaseStorage(context);
//                   print('OK button pressed! Execute specific action.');
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: questions.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(questions[index]['question']!),
//             subtitle:
//                 Text('Correct Answer: ${questions[index]['correctAnswer']}'),
//             trailing: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 _showEditQuestionDialog(context, index);
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddQuestionDialog(context);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddQuestionDialog(BuildContext context) {
//     TextEditingController correctOptionController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Question'),
//           content: SingleChildScrollView(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: <Widget>[
//                   TextField(
//                     controller: questionController,
//                     decoration: InputDecoration(
//                       labelText: 'Enter the question',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: option1Controller,
//                     decoration: InputDecoration(
//                       labelText: 'Enter option 1',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: option2Controller,
//                     decoration: InputDecoration(
//                       labelText: 'Enter option 2',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: option3Controller,
//                     decoration: InputDecoration(
//                       labelText: 'Enter option 3',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: option4Controller,
//                     decoration: InputDecoration(
//                       labelText: 'Enter option 4',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: correctOptionController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Enter correct option number',
//                     ),
//                   ),
//                   // SizedBox(height: 20.0),
//                   // TextField(
//                   //   controller: explanationController,
//                   //   decoration: InputDecoration(
//                   //     labelText: 'Explanation',
//                   //   ),
//                   // ),
//                   SizedBox(height: 20.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       if(int.parse(correctOptionController.text)>4){
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
//                         Text("Fill Data Correctly"),));
//                         return ;
//                       }
//                       saveQuestion(correctOptionController.text);
//                       Navigator.pop(context);
//                     },
//                     child: Text('Add Question'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showEditQuestionDialog(BuildContext context, int index) {
//     // Pre-fill the text controllers with the existing question data
//     questionController.text = questions[index]['question'];
//     option1Controller.text = questions[index]['options'].split(', ')[0];
//     option2Controller.text = questions[index]['options'].split(', ')[1];
//     option3Controller.text = questions[index]['options'].split(', ')[2];
//     option4Controller.text = questions[index]['options'].split(', ')[3];
//     // explanationController.text = questions[index]['explanation'];

//     String correctAnswer = questions[index]['correctAnswer'];
//     int correctOptionIndex =
//         questions[index]['options'].split(', ').indexOf(correctAnswer) + 1;

//     TextEditingController correctOptionController =
//         TextEditingController(text: correctOptionIndex.toString());

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit Question'),
//           content: SingleChildScrollView(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: <Widget>[
//                   TextField(
//                     controller: questionController,
//                     decoration: InputDecoration(
//                       labelText: 'Enter the question',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: option1Controller,
//                     decoration: InputDecoration(
//                       labelText: 'Enter option 1',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: option2Controller,
//                     decoration: InputDecoration(
//                       labelText: 'Enter option 2',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: option3Controller,
//                     decoration: InputDecoration(
//                       labelText: 'Enter option 3',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: option4Controller,
//                     decoration: InputDecoration(
//                       labelText: 'Enter option 4',
//                     ),
//                   ),
//                   SizedBox(height: 12.0),
//                   TextField(
//                     controller: correctOptionController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Enter correct option number',
//                     ),
//                   ),
//                   // SizedBox(height: 20.0),
//                   // TextField(
//                   //   controller: explanationController,
//                   //   decoration: InputDecoration(
//                   //     labelText: 'Explanation',
//                   //   ),
//                   // ),
//                   SizedBox(height: 20.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       if(int.parse(correctOptionController.text)>4){
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
//                         Text("Fill Data Correctly"),));
//                         return ;
//                       }
//                       _saveEditedQuestion(index, correctOptionController.text);
//                       Navigator.pop(context); // Close the dialog after saving
//                     },
//                     child: Text('Save Changes'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void saveQuestion(String correctOption) {
//     String question = questionController.text;

//     int correctOptionIndex = int.tryParse(correctOption) ?? 0;
//     if (correctOptionIndex <= 0 || correctOptionIndex > 4) {
//       return;
//     }

//     List<String> options = [
//       option1Controller.text,
//       option2Controller.text,
//       option3Controller.text,
//       option4Controller.text
//     ];

//     String correctAnswer = options[correctOptionIndex - 1];

//     Map<String, String> newQuestion = {
//       'question': question,
//       'options': options.join(', '),
//       // 'explanation': explanationController.text,
//       'correctAnswer': correctAnswer,
//     };

//     setState(() {
//       questions.add(newQuestion);
//     });

//     questionController.clear();
//     option1Controller.clear();
//     option2Controller.clear();
//     option3Controller.clear();
//     option4Controller.clear();
//     // explanationController.clear();
//     correctAnswerController.clear();
//   }

//   void _saveEditedQuestion(int index, String correctOption) {
//     String question = questionController.text;

//     int correctOptionIndex = int.tryParse(correctOption) ?? 0;
//     if (correctOptionIndex <= 0 || correctOptionIndex > 4) {
//       return;
//     }

//     List<String> options = [
//       option1Controller.text,
//       option2Controller.text,
//       option3Controller.text,
//       option4Controller.text
//     ];

//     String correctAnswer = options[correctOptionIndex - 1];

//     Map<String, String> updatedQuestion = {
//       'question': question,
//       'options': options.join(', '),
//       // 'explanation': explanationController.text,
//       'correctAnswer': correctAnswer,
//     };

//     setState(() {
//       questions[index] = updatedQuestion;
//     });

//     questionController.clear();
//     option1Controller.clear();
//     option2Controller.clear();
//     option3Controller.clear();
//     option4Controller.clear();
//     // explanationController.clear();
//     correctAnswerController.clear();
//   }

//   // void saveQuestionsToFirebaseStorage(BuildContext context) async {
//   //   try {
//   //     Uint8List jsonData = Uint8List.fromList(utf8.encode(jsonEncode(questions)));

//   //     FirebaseStorage storage = FirebaseStorage.instance;
//   //     Reference ref = storage.ref().child('${DateTime.now().toIso8601String()}.json');
//   //     await ref.putData(jsonData);

//   //     Navigator.pop(context);
//   //   } catch (e) {
//   //     print('Error saving questions to Firebase: $e');
//   //   }
//   // }



//   String convertQuestionsToJson() {
//     return jsonEncode(questions);
//   }

//   void saveQuestionsToFirebaseStorage(BuildContext context) async {
//     String jsonData = convertQuestionsToJson();
//     Uint8List data =
//         Uint8List.fromList(utf8.encode(jsonData)); // Convert to Uint8List

//     Reference ref =
//         FirebaseStorage.instance.ref().child('${DateTime.now().toIso8601String()}.json');
//     UploadTask uploadTask = ref.putData(
//       data,
//       SettableMetadata(contentType: 'application/json'),
//     );

//     try {
//       TaskSnapshot snapshot = await uploadTask;
//       if (snapshot.state == TaskState.success) {
//         // If upload is successful, get the download URL
//         String downloadURL = await snapshot.ref.getDownloadURL();

//         // Print the download URL
//         print('Download URL: $downloadURL');

//         // Perform action to pop the screen, for example, using Navigator.pop
//         Navigator.pop(context, downloadURL); // This pops the current screen

//         // You can navigate to a new screen or perform any other action as needed here
//         // For navigating to a new screen, you might use:
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
//       }
//     } catch (e) {
//       print('Error uploading file: $e');
//       // Handle errors here
//     }
//   }
// }
