// ignore_for_file: file_names, prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sophisticated_f_ups/Upload%20File%20Page/uploadFilePage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
            backgroundColor: Colors.black45,
            titleSpacing: 0,
            title: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Image.asset(
                  'images/logo2.png',
                  fit: BoxFit.fitWidth,
                  height: 50,
                ),
              ),
            )),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Image
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              child: SvgPicture.asset(
                'images/logo.svg',
                height: 130,
              ),
            ),
          ),

          //Discription
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: RichText(
                  text: TextSpan(
                      text:
                          "All-in-one assistant for recording lecture video, audio into downloadable files and transcribed text notes. \n\nHaving trouble remembering the contents of your lectures? \n\nAre you tired and distracted by the redundant task of writing down your professor's notes? \n\nLecture Leverager allows for a customizable platform to record the contents of your lectures into transcribed notes.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ))),
            ),
          ),

          //Get Started Button
          Center(
            child: SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Disabled color
                      }
                      return Color(0xFF47B5E5); // Regular color
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadFile()));
                },
                child: RichText(
                  text: TextSpan(
                    text: "Get Started",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          //About Us Button
          SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              text: "About Us",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
