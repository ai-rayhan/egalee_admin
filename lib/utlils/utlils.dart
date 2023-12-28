import 'dart:convert';

import 'package:http/http.dart' as http;

class AppStaticData {
  static List<String> jobMainCategory = [
    // "প্রস্তুতি",
    "চাকরির বিজ্ঞপ্তি",
    "নোটিশ",
    "প্রাইভেট জব",
    "চাকরির পত্রিকা"
    // "বিষয়ভিত্তিক প্রস্তুতি",
    // "সফট স্কিল"
  ];
}

Future<void> sendPushNotification(title, body) async {
  // Replace 'YOUR_SERVER_KEY' with your Firebase Cloud Messaging server key
  String serverKey =
      'AAAAwYR3dIc:APA91bFeexRteeBGI1o7HPrfvW-4HYADP7MzCZR0KTlWi6OteDno706H0QzN4OBMbky4wZT6ardmICvpSr_Nz5PBoNXdI9Z0EGypcKRBjzD1wX9vBlF66_HowgMDW_WXMcOUf6OqxDhl';

  // Notification content
  var notification = {
    'title': title,
    'body': body,
  };

  var data = {
    'notification': notification,
    // 'data': {
    //   // Optional data payload
    //   'key1': 'value1',
    //   'key2': 'value2',
    // },
    'priority': 'high',
    'to': '/topics/all-users',
  };

  try {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Notification sent to all users successfully!');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending notification to all users: $e');
  }
}

Future<void> sendNotification(title, body, to) async {
  //set fcm token
  const fcmToken = 'YOUR_FCM_TOKEN_HERE';

  try {
    var url = 'https://fcm.googleapis.com/fcm/send';
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmToken',
    };
    var request = {
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
      'to': '$to',
    };

    var response = await http.post(
      Uri.parse(url),
      headers: header,
      body: json.encode(request),
    );

    print(response.body);
  } catch (error) {
    print(error);
  }
}
