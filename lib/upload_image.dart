import 'package:facebook_app/database/Firebase%20Storage/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () async {
              final results = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.custom,
                allowedExtensions: ['png', 'jpg'],
              );

              if (results == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No file selected.')));
                return;
              }

              final path = results.files.single.path!;
              final fileName = results.files.single.name;
              storage
                  .uploadFile(path, fileName)
                  .then((value) => print('Done:::::::Done'));
              print('path:::::$path');
              print('path:::::$fileName');
            },
            color: Colors.redAccent,
            textColor: Colors.white,
            minWidth: 150,
            height: 55,
            child: Text('Upload Image'),
          ),
          Container(
            height: 200,
            child: FutureBuilder(
              future: storage.listFiles(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return MaterialButton(
                          onPressed: () {},
                          child: Text(snapshot.data!.items[index].name),
                        );
                      },
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container();
              },
            ),
          ),
          Container(
            height: 200,
            child: FutureBuilder(
              future: storage
                  .downloadURL('Screenshot_20220920-115732_Manga Slayer.jpg'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                      child: Image.network(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ));
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container();
              },
            ),
          )
        ],
      )),
    );
  }
}
