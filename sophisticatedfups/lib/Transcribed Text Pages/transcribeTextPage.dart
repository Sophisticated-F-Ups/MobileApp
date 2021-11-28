// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';

class TranscribedText extends StatefulWidget {
  Map? decodedFile;
  TranscribedText({Key? key, this.decodedFile}) : super(key: key);

  @override
  _TranscribedTextState createState() => _TranscribedTextState();
}

class _TranscribedTextState extends State<TranscribedText> {
  @override
  void initState() {
    print("\n\nINSIDE NEXT PAGE\n");
    print(widget.decodedFile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          RichText(
              text: const TextSpan(
                  text: "Summarized Text: ",
                  style: TextStyle(color: Colors.black, fontSize: 25))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 150,
                child: SingleChildScrollView(
                  child: RichText(
                    text: TextSpan(
                        text: widget.decodedFile?["summerize"],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: RichText(
                text: const TextSpan(
                    text: "Transcribed Text: ",
                    style: TextStyle(color: Colors.black, fontSize: 25))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 250,
                child: SingleChildScrollView(
                  child: RichText(
                    text: TextSpan(
                        text: widget.decodedFile?["text"],
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                ),
              ),
            ),
          ),

          // SizedBox(
          //   height: 20,
          // ),
        ],
      ),
    );
  }
}
