import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playstage/people/member_info_entity/tb_member_photo_info_list.dart';

import '../const.dart';
import '../feed/verify_photo.dart';
import '../shared_data.dart';
import '../sign_up/subscriber_info.dart';
import '../utils/loader.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  bool _filled = false;
  final bool _loading = false;

  final List<String> _imageFilePath = List.generate(6, (_) => "");
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final profileImages = SharedData().owner!.tbMemberPhotoInfoList;
    int index = 0;
    for (TbMemberPhotoInfoList info in profileImages!) {
      setState(() {
        _imageFilePath[index] =
            SharedData().owner!.makeProfileImagePath(index: index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '프로필 수정'.tr,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _filled
                ? () async {
                    if (_filled == false) {
                      return;
                    }

                    SubscriberInfo info = SubscriberInfo();
                    for (String path in _imageFilePath) {
                      final file = File(path);
                      if (await file.exists()) {
                        info.profileImages.add(path);
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    '프로필 사진'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 6,
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
                                  if (_getPathCount() < 1) {
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
                                      ? _imageFilePath[index]
                                              .startsWith('https:')
                                          ? Image(
                                              image: CachedNetworkImageProvider(
                                                  _imageFilePath[index]),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
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
                ],
              ),
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
      Get.to(() => VerifyPhoto(title: '', path: pickedFile.path))!
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
