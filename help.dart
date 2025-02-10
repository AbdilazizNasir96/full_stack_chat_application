import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Center(child: Text('Help Page')),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 8.0),
                      Text('How to Use This App'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to the Chat App!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'This app allows you to connect with friends and family through instant messaging.',
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'To get started:',
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '1. Create an account or log in with your existing credentials.',
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '2. Find and add your contacts.',
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '3. Start chatting! Send text messages, images, and more.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.question_answer),
                      SizedBox(width: 8.0),
                      Text('Frequently Asked Questions (FAQs)'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add your FAQs here
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}