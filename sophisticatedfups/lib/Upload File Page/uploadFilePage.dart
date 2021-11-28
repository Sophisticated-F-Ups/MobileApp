// ignore_for_file: file_names
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sophisticated_f_ups/Transcribed%20Text%20Pages/transcribeTextPage.dart';
import 'package:video_player/video_player.dart';

import 'viewSelectedFile.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({Key? key}) : super(key: key);

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  bool fileSelected = false;
  String fileSelectedPath = "";
  bool disableSendButton = false;
  String buttonText = "Get Transcription";
  Map decodedFile = {};

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
          //Text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: const TextSpan(
                    text: "Upload Video or Audio",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'RaleWay',
                      fontFamilyFallback: <String>[
                        'Noto Sans CJK SC',
                        'Noto Color Emoji',
                      ],
                    ))),
          ),

          //Select File Button
          if (fileSelected == false) ...[
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
                  onPressed: () async {
                    //Implement Get File
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ["mp4", "mp3"]);

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      setState(() {
                        fileSelected = true;
                        fileSelectedPath = file.path;
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Select File",
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
          ] else ...[
            //Video/Audio
            Container(
              decoration: BoxDecoration(),
              child: SizedBox(
                height: 400,
                child: ChewieListItem(
                    videoPlayerController:
                        VideoPlayerController.file(File(fileSelectedPath)),
                    looping: true),
              ),
            ),
            //Remove File
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 150,
                      height: 45,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Color(0xFF47B5E5); // Regular color
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ))),
                        onPressed: () {
                          setState(() {
                            fileSelected = false;
                            fileSelectedPath = "";
                          });
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Remove File",
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
                ),
              ],
            ),
          ],

          //Transcribe Button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Center(
              child: SizedBox(
                width: 200,
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
                  onPressed: !disableSendButton
                      ? () async {
                          // print("SENDING FILE");
                          await upload(File(fileSelectedPath), context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TranscribedText(
                                        decodedFile: decodedFile,
                                      )));
                        }
                      : null,
                  child: RichText(
                    text: TextSpan(
                      text: buttonText,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  upload(File file, BuildContext context) async {
    setState(() {
      disableSendButton = true;
      buttonText = "Loading...";
    });
    // open a bytestream
    // ignore: deprecated_member_use
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    // get file length
    var length = await file.length();

    // string to uri
    var uri = Uri.parse("https://lectureleverager.herokuapp.com/upload");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(file.path));

    print(multipartFile.contentType);
    print(multipartFile.field);
    print(multipartFile.filename);

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print("\n\n---------------------------");
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(decodedFile["summerize"]);
      print(decodedFile["text"]);

      setState(() {
        disableSendButton = false;
        buttonText = "Get Transcription!";
        decodedFile = jsonDecode(value);
      });
    });
  }
}
