import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat2/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageEditingController = TextEditingController();
  late String message;
  final _auth = FirebaseAuth.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _initializeNotifications();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permissions
 //   flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }

  Future<void> _showNotification(String messageText, String messageSender) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      messageSender,
      messageText,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              onNewMessage: (messageText, messageSender) {
                if (messageSender != loggedInUser.email) {
                  _showNotification(messageText, messageSender);
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageEditingController.clear();
                      _firestore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'text': message,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  MessageBox({required this.text, required this.sender, required this.isMe, required this.time});
  final String text;
  final String sender;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: 2 * (MediaQuery.of(context).size.width / 3),
            child: Card(
              shape: isMe
                  ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)))
                  : RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: Text(
                        sender,
                        style: TextStyle(color: Colors.black54, fontSize: 9),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: TextStyle(color: isMe ? Colors.white : Colors.lightBlueAccent, fontSize: 15),
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Text(
                        time,
                        style: TextStyle(color: Colors.black54, fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final Function(String messageText, String messageSender) onNewMessage;
  const MessageStream({super.key, required this.onNewMessage});

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshots.data?.docs;
        List<MessageBox> messageWidget = [];
        for (var messagey in messages!) {
          final messageText = messagey['text'];
          final messageSender = messagey['sender'];
          final messageTimestamp = messagey['timestamp'] as Timestamp? ?? Timestamp.fromDate(DateTime.now());
          final times = formatTimestamp(messageTimestamp);
          final currentUser = loggedInUser.email;

          final messageWidgetE = MessageBox(
            text: messageText,
            sender: messageSender,
            isMe: messageSender == currentUser,
            time: times,
          );
          messageWidget.add(messageWidgetE);

          if (messageSender != currentUser) {
            onNewMessage(messageText, messageSender);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidget,
          ),
        );
      },
    );
  }
}
