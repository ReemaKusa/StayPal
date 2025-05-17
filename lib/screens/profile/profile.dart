import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staypal/screens/profile/log_out.dart';
import 'package:staypal/screens/profile/my_fav.dart';
import 'package:staypal/screens/profile/my_review.dart';
import 'package:staypal/screens/profile/payment_methods.dart';
import 'package:staypal/screens/profile/personal_details.dart';
import 'package:staypal/screens/profile/security_settings.dart';

import 'uploud_image.dart';


class MyProfile extends StatefulWidget{
  @override
  _MyProfileState createState()=> _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30.0,color: Colors.black,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(' My Profile',
              style: TextStyle(

                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ), centerTitle: true,

            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, size: 30.0,color: Colors.black,),
                onPressed: () {},
              ),
              Text('data')

            ],


          ),
          body: Padding(

            padding: EdgeInsets.all(10.0),

            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      _image != null ?
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: MemoryImage(_image!),

                      ) :

                      const CircleAvatar(
                        radius: 65.0,

                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3407.jpg'),

                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.photo_camera),
                        ), bottom: -10,
                        left: 80,
                      ),
                    ],

                  ),
                  SizedBox(height: 30.0,),

                  Card(
                      color: Colors.white,
                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                          children: [
                            SizedBox(height: 12),

                            ListTile(
                              leading: const Icon(Icons.payment,
                                color:Colors.black ,),
                              title: Text('Payment Methods',style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>PaymentMethods()));


                              },

                            ),
                          ]))
                  ,
                  Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                          children: [
                            SizedBox(height: 12),

                            ListTile(

                              leading: const Icon(Icons.person, color:Colors.black),
                              title: const Text('Personal Details',style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>PersonalDetails()));

                              },

                            ),
                          ]) ),
                  Card(
                      color: Colors.white,
                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                          children: [
                            SizedBox(height: 12.0),


                            ListTile(
                              leading: const Icon(Icons.lock, color:Colors.black),
                              title: const Text('Security Settings',style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: (){


                                Navigator.push(context,MaterialPageRoute(builder: (context)=>SecuritySetting()));

                              },


                            ),])),
                  Card(
                      color: Colors.white,
                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                          children: [

                            SizedBox(height: 12),

                            ListTile(
                              leading: const Icon(Icons.favorite, color:Colors.black),
                              title: const Text('My Favorite',style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>MyFav()));

                              },


                            ),])),
                  Card(
                      color: Colors.white,
                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                          children: [
                            SizedBox(height: 12),

                            ListTile(
                              leading: const Icon(Icons.rate_review, color:Colors.black),
                              title: const Text('My Review',style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyReview()));

                              },


                            ),])),
                  Card(

                      color: Colors.white,

                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                          children: [
                            SizedBox(height: 12.0),
                            ListTile(
                              leading: const Icon(Icons.exit_to_app,
                                size: 25,
                                color: Colors.black,),
                              title: const Text('Log Out',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>LogOut()));
                              },
                            )])


                  )

                ]),

          )
      ),




    );
  }

}






