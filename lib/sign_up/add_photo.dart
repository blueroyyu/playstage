import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'subscriber_info.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  bool _filled = false;

  final List<String> _imageFilePath = List.generate(6, (_) => "");
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_filled == false) {
                  return;
                }

                SubscriberInfo info = SubscriberInfo();
                for (String path in _imageFilePath) {
                  // Upload image with the current time as the key
                  final key = DateTime.now().toString();
                  final file = File(path);


                  info.profileImages.add(path);
                }

                // Get.to(const AllowLocation());
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                side: BorderSide(
                  width: 2.0,
                  color: _filled
                      ? const Color(0xFFFFC800)
                      : const Color(0xFFE9E9E9),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'next'.tr,
                style: TextStyle(
                  color: _filled
                      ? const Color(0xFFFFC800)
                      : const Color(0xFFE9E9E9),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'STEP 4/5',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFFC000),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 80),
              Text(
                'add_photo'.tr,
                style: const TextStyle(
                  fontSize: 33,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'add_photo_desc'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8E8E8E),
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 6,
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
                              if (getPathCount() < 1) {
                                _filled = false;
                              }
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
              const SizedBox(height: 30),
              Text(
                'photo_warning'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'photo_warning_detail'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
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
        _filled = true;
      });
    }
  }

  void _takePhoto(int index) async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFilePath[index] = pickedFile.path;
        _filled = true;
      });
    }
  }
}
