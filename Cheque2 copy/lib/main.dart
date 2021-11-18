import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(
  home : MyHomePage(),
));



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String tex;
  PickedFile imageURI;
  File imageee;
  final ImagePicker _picker = ImagePicker();
  Future<String> futureCheque;


  doUpload(){
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.1.15:3000/upload"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        imageee.readAsBytes().asStream(),
        imageee.lengthSync(),
        filename: "filename",
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    request.send().then((value) => print(value.statusCode));
}
  Future<String> fetchCheque() async {
    final response = await http.get(Uri.parse('http://192.168.1.15:3000/api/cheque/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print(response.body);
      setState(() {
        tex = response.body.toString();
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load cheque');
    }
  }

  @override
  void initState() {
    super.initState();
    print(fetchCheque());
    futureCheque = fetchCheque();
  }

  Future getImageFromCameraGallery(bool isCamera) async {
    var image = await _picker.getImage(source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      imageURI = image;
      this.imageee = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: imageURI == null ? Text('No Image To Analyse') : Image.file(File(imageURI.path)),
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: tex,
            ),
          ),
          
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () { 
              },
              child: Text('Analyse'),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment:  MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              getImageFromCameraGallery(true); 
            },
            child: Icon(
              Icons.camera
            ),
            ),
          SizedBox(height: 15),
          FloatingActionButton(
            onPressed: (){
              getImageFromCameraGallery(false); 
            },
            child: Icon(
              Icons.photo_album
            ),
            ),
        ],
      ),
    );
  }
  
}

