import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

Future<void> saveImagePath(String imagePath) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('savedImagePath', imagePath);
}

Future<String?> getSavedImagePath() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('savedImagePath');
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

String? savedImagePath;
File? imageFile;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturing Images'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            FutureBuilder(
                future: getSavedImagePath(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      imageFile = File(snapshot.data!);
                      return Container(
                        width: 640,
                        height: 480,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              image: FileImage(imageFile!), fit: BoxFit.cover),
                          border: Border.all(width: 8, color: Colors.black),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      );
                    } else
                      return Text('No loaded image');
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return Container(
                      width: 640,
                      height: 480,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 8, color: Colors.black12),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Text(
                        'Image should appear here',
                        style: TextStyle(fontSize: 26),
                      ),
                    );
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => captureImage(),
                    child: const Text('Capture Image',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickImage(),
                    child: const Text('Select Image',
                        style: TextStyle(fontSize: 18)),
                  ),
                )
              ],
            ),
            savedImagePath != null
                ? Text('Image saved at: $savedImagePath')
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> captureImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70,
    );

    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
      await saveImagePath(file.path);
    }
  }

  Future<void> pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70,
    );

    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
      await saveImagePath(file.path);
    }
  }
}
