import 'package:flutter/material.dart';
import 'package:staypal/screens/profile.dart';

class SecuritySetting extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),),
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
        }, icon: Icon(Icons.arrow_back)),

      ),
    );
  }
}