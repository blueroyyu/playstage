import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddFeed extends StatefulWidget {
  const AddFeed({super.key});

  @override
  State<AddFeed> createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {
  final List<String> _imageFilePath = List.generate(6, (_) => "");
  final ImagePicker _imagePicker = ImagePicker();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '업로드',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // do something when button is pressed
            },
            icon: Icon(Icons.check),
            iconSize: 26,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: '게시글을 입력해주세요',
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 3,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    int pathCount = getPathCount();
                    if (_imageFilePath[index].isEmpty && pathCount != index) {
                      return;
                    }

                    _imageFilePath[index].isEmpty
                        ? showModalBottomSheet(
                            useSafeArea: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: Text('album'.tr),
                                    onTap: () {
                                      _pickImage(index);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: Text('camera'.tr),
                                    onTap: () {
                                      _takePhoto(index);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          )
                        : setState(() {
                            _imageFilePath[index] = "";
                          });
                  },
                  child: Container(
                    color: Colors.grey[300],
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: _imageFilePath[index].isNotEmpty
                                ? Image.file(
                                    File(_imageFilePath[index]),
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox()),
                        _imageFilePath[index].isEmpty
                            ? const Center(
                                child: Icon(Icons.add),
                              )
                            : const Positioned(
                                right: 0,
                                child: Icon(
                                  Icons.remove_circle,
                                  size: 20,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int getPathCount() {
    int pathCount = 0;
    for (String path in _imageFilePath) {
      if (path.isNotEmpty) {
        pathCount++;
      }
    }
    return pathCount;
  }

  void _pickImage(int index) async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFilePath[index] = pickedFile.path;
      });
    }
  }

  void _takePhoto(int index) async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFilePath[index] = pickedFile.path;
      });
    }
  }
}
