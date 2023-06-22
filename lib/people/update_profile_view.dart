import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playstage/people/member_info_entity/member_info_entity.dart';
import 'package:playstage/people/member_info_entity/tb_member_photo_info_list.dart';

import '../const.dart';
import '../feed/verify_photo.dart';
import '../shared_data.dart';
import '../utils/api_provider.dart';
import '../utils/loader.dart';
import '../utils/utils.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  bool _filled = false;
  final bool _loading = false;

  final List<String> _imageFilePath = List.generate(6, (_) => '');
  final List<TbMemberPhotoInfoList> _profileImages = List.generate(6, (_) => TbMemberPhotoInfoList());
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _addedImages = <String>[];
  final List<int> _deleteImages = <int>[];
  bool _imageChanged = true;

  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final int _characterLimit = 15;

  bool _nicknameDuplicated = false;
  bool _nicknameChecked = true;

  bool _nicknameChecking = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    MemberInfoEntity member = SharedData().owner!;
    for (int index = 0; index < member.tbMemberPhotoInfoList!.length; index++) {
      setState(() {
        _imageFilePath[index] = member.makeProfileImagePath(index: index);
        _profileImages[index] = member.tbMemberPhotoInfoList![index];
      });
    }

    _nickNameController.text = member.nickName!;
    _aboutMeController.text = member.memberIntro!;
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

                    await submit();
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
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            if (index != 0 && _imageFilePath[index - 1].isEmpty && _imageFilePath[index].isEmpty) {
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
                                    String deletedPath = _imageFilePath[index];
                                    _addedImages.remove(deletedPath);
                                    _imageFilePath[index] = '';
                                    if (_profileImages[index].photoSavedFileName != null && _profileImages[index].photoSavedFileName!.isNotEmpty) {
                                      _deleteImages.add(_profileImages[index].photoSeq!);
                                      _profileImages[index].photoSeq = 0;
                                      _profileImages[index].photoSavedFileName = '';
                                    }

                                    _imageChanged = true;
                                    checkSubmit();
                                  });
                          },
                          child: Container(
                            color: Colors.grey[300],
                            child: Stack(
                              children: [
                                Positioned.fill(
                                    child: _imageFilePath[index].isNotEmpty
                                        ? _imageFilePath[index].startsWith('https:')
                                            ? Image(
                                                image: CachedNetworkImageProvider(_imageFilePath[index]),
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
                    const SizedBox(height: 40),
                    Text(
                      'nickname'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          flex: 75,
                          child: TextField(
                            controller: _nickNameController,
                            maxLength: _characterLimit,
                            onChanged: (value) {
                              _nicknameChecked = false;
                              setState(() {
                                _nicknameChecking = false;
                              });
                              checkSubmit();
                            },
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              hintText: 'input_nickname'.tr,
                              hintStyle: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF8E8E8E),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 25,
                          child: ElevatedButton(
                            onPressed: _nicknameChecking
                                ? null
                                : () async {
                                    setState(() {
                                      _nicknameChecking = true;
                                    });
                                    try {
                                      dynamic res = await ApiProvider.requestIsDuplicateNickName(_nickNameController.text);
                                      if (kDebugMode) {
                                        print(res.toString());
                                      }

                                      _nicknameDuplicated = res['data'];
                                      if (_nicknameDuplicated) {
                                        setState(() {
                                          _nicknameChecked = false;
                                        });
                                        if (!mounted) {
                                          return;
                                        }
                                        await showAlert(context, '사용 중인 닉네임 입니다.');
                                      } else {
                                        setState(() {
                                          _nicknameChecked = true;
                                        });
                                        if (!mounted) {
                                          return;
                                        }
                                        await showAlert(context, '사용이 가능한 닉네임 입니다.');

                                        checkSubmit();
                                      }
                                    } on Exception catch (e) {
                                      if (kDebugMode) {
                                        print(e);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFC800)),
                            child: const Text(
                              '중복확인',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'about_me'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: _aboutMeController,
                        maxLines: null,
                        maxLength: 50,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          hintText: 'input_after_touch'.tr,
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF8E8E8E),
                          ),
                        ),
                        onChanged: (value) {
                          checkSubmit();
                        },
                        onTap: () {
                          _scrollController.animateTo(120.0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        },
                      ),
                    ),
                  ],
                ),
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

  Future<void> submit() async {
    MemberInfoEntity member = SharedData().owner!;
    member.nickName = _nickNameController.text;
    member.memberIntro = _aboutMeController.text;

    String deleteImages = _deleteImages.join(',');
    try {
      dynamic res = await ApiProvider.requestUpdateMember(member, removePhotoSeqList: deleteImages, profileFiles: _addedImages);
      if (kDebugMode) {
        print(res);
      }

      Get.snackbar('info'.tr, '프로필이 수정 되었습니다.');

      res = await ApiProvider.requestMemberById(member.memberId!);
      Map<String, dynamic> jsonData = res['data'];
      SharedData().owner = MemberInfoEntity.fromMap(jsonData);

      Timer(const Duration(seconds: 1), () {
        Get.back();
      });
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void checkSubmit() {
    setState(() {
      if (_nickNameController.text.isNotEmpty && _aboutMeController.text.isNotEmpty && _nicknameChecked && _imageChanged) {
        _filled = true;
      } else {
        _filled = false;
      }
    });
  }

  // int _getPathCount() {
  //   int pathCount = 0;
  //   for (String path in _imageFilePath) {
  //     if (path.isNotEmpty) {
  //       pathCount++;
  //     }
  //   }
  //   return pathCount;
  // }

  void _processPickedFile(XFile? pickedFile, int index) {
    if (pickedFile != null) {
      var result = false;
      Get.to(() => VerifyPhoto(title: '', path: pickedFile.path))!.then((value) {
        result = value ?? false;

        if (result) {
          setState(() {
            _addedImages.add(pickedFile.path);
            _imageFilePath[index] = pickedFile.path;
            _imageChanged = true;
            checkSubmit();
          });
        }
      });
    }
  }

  void _pickImage(int index) async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    _processPickedFile(pickedFile, index);
  }

  void _takePhoto(int index) async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    _processPickedFile(pickedFile, index);
  }
}
