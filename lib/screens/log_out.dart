import 'package:flutter/material.dart';
import 'package:staypal/screens/profile.dart';
class LogOut extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Out',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),),
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
        }, icon: Icon(Icons.arrow_back)),
      ),
    );
  }
}

