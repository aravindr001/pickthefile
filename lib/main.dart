import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedFile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      // String initialDirectory =
      //     await FilePicker.getPlatform().getDirectoryPath();

      // String initialDirectory = await FilePicker.platform.pickFiles().toString();
      // print('${initialDirectory.characters} initialDirectory');
      result = await FilePicker.platform.pickFiles();

      if (result != null) {
        fileName = result!.files.first.name;
        pickedFile = result!.files.first;
        fileToDisplay = File(pickedFile!.path.toString());

        print('file name $fileToDisplay');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Loading() :
        Column(
          children: [
            if(result!=null)
            Expanded(
              child: SizedBox(
                // child: Image.file(fileToDisplay!),
                child: SfPdfViewer.file(fileToDisplay!),
                // child: Text( getPDFtext(pickedFile!.path.toString())),
              ),
            ),
          ],
        ),

      // body: (result!=null)? FutureBuilder<String>(
      //   future: getPDFtext(pickedFile!.path.toString()),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return Text(snapshot.data.toString());
      //     } else if (snapshot.hasError) {
      //       return Text('hai');
      //     }
      //     return const Loading();
      //   },
      // ):
      // CircularProgressIndicator(),

      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

Future<String> getPDFtext(String path) async {
  String text = "";
  try {
    text = await ReadPdfText.getPDFtext(path);
    print(text);
  } on PlatformException {
    print('Failed to get PDF text.');
  }
  return text;
}
