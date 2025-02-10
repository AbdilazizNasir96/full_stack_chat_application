import 'package:flutter/material.dart';
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar( backgroundColor: Colors.orangeAccent,foregroundColor: Colors.red,
        title: const Center(child: Text('About Page',
        style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),),
      ),
      body: SafeArea(child: Container(
        padding: const EdgeInsets.all(10),
        child: const Column(
          children: [
            SizedBox(height: 15,),
            Center(child: Text('Developer And Designer ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),),
            SizedBox(height: 30,),
            Center(child: Text('Abdilaziz Nasir'),),
            ListTile(
              leading: Icon(Icons.flutter_dash_rounded),
              title: Text('App version '),
            ),
            SizedBox(height: 20,),
            Center(child: Text('1.2')),
          ],
        ),
      )),
    );
  }
}
