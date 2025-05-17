import 'package:flutter/material.dart';
import 'package:staypal/screens/profile.dart';
class MyFav extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorite',
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