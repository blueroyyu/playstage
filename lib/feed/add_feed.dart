import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playstage/const.dart';
import 'package:playstage/feed/feed_view.dart';
import 'package:playstage/feed/verify_photo.dart';
import 'package:playstage/shared_data.dart';
import 'package:playstage/utils/api_provider.dart';
import 'package:playstage/utils/loader.dart';

class AddFeed extends StatefulWidget {
  const AddFeed({super.key});

  @override
  State<AddFeed> createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {
  bool _filled = false;
  bool _loading = false;

  final List<String> _imageFilePath = List.generate(6, (_) => "");
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'upload'.tr,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _filled
                ? () async {
                    // if (_textController.text.isEmpty && _getPathCount() < 1) {
                    //   Get.snackbar('Playstage', 'empty_feed'.tr);
                    //   return;
                    // }

                    // request add feed
                    String memberId = SharedData().owner!.memberId!;
                    try {
                      setState(() {
                        _loading = true;
                      });

                      var responseData = await ApiProvider.requestAddFeed(
                          memberId, _textController.text, _imageFilePath);

                      if (kDebugMode) {
                        print(responseData);
                      }

                      setState(() {
                        _loading = false;
                      });

                      Get.off(FeedView(member: SharedData().owner!));
                    } on Exception catch (e) {
                      DioError dioError = e as DioError;
                      if (kDebugMode) {
                        print(dioError);
                      }
                    }
                  }
                : null,
            icon: Icon(
              Icons.check,
              color: _filled ? colorTabBottom : colorSlderInactive,
            ),
            iconSize: 26,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _textController,
                    maxLines: 100,
                    decoration: InputDecoration(
                      hintText: 'input_feed'.tr,
                      contentPadding: const EdgeInsets.all(20.0),
                    ),
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filled = value.isNotEmpty;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          if (index != 0 &&
                              _imageFilePath[index - 1].isEmpty &&
                              _imageFilePath[index].isEmpty) {
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
                                          leading:
                                              const Icon(Icons.photo_library),
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
                                  if (_getPathCount() < 1 &&
                                      _textController.text.isEmpty) {
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
                ),
              ],
            ),
            Container(
              child: _loading ? const Loader(loadingTxt: '') : Container(),
            ),
          ],
        ),
      ),
    );
  }

  int _getPathCount() {
    int pathCount = 0;
    for (String path in _imageFilePath) {
      if (path.isNotEmpty) {
        pathCount++;
      }
    }
    return pathCount;
  }

  void _processPickedFile(XFile? pickedFile, int index) {
    if (pickedFile != null) {
      var result = false;
      Get.to(() => VerifyPhoto(title: 'upload'.tr, path: pickedFile.path))!
          .then((value) {
        result = value ?? false;

        if (result) {
          setState(() {
            _imageFilePath[index] = pickedFile.path;
            _filled = true;
          });
        }
      });
    }
  }

  void _pickImage(int index) async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    _processPickedFile(pickedFile, index);
  }

  void _takePhoto(int index) async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    _processPickedFile(pickedFile, index);
  }
}
