import 'package:flutter/material.dart';

class MemberCard extends StatefulWidget {
  const MemberCard({super.key});

  @override
  MemberCardState createState() => MemberCardState();
}

class MemberCardState extends State<MemberCard> {
  int _currentIndex = 0;
  List<String> _backgroundImages = [
    'https://playstage-upload.s3.ap-northeast-2.amazonaws.com/ab946ff4-ee4a-4e9c-ab9d-41efb3914218/profile/202304081c484513-d8ee-44e2-ab3f-835c81cc8329.jpg',
    'https://playstage-upload.s3.ap-northeast-2.amazonaws.com/ab946ff4-ee4a-4e9c-ab9d-41efb3914218/profile/20230408e1474827-bf1e-438a-9dbe-f9d9a2f0eb9f.jpg',
    'https://playstage-upload.s3.ap-northeast-2.amazonaws.com/c314ca0d-ed3c-4756-9da9-7209f0180351/profile/20230407fc0c85aa-e268-42e5-853c-4bca127c3bb4.jpg'
  ];
  List<String> _userNames = ['John', 'Jane', 'Bob'];
  List<String> _userAges = ['25', '30', '45'];
  List<String> _userJobs = ['Engineer', 'Designer', 'Manager'];

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0) return;

    if (details.primaryVelocity?.compareTo(0) == -1) {
      setState(() {
        _currentIndex =
        (_currentIndex < _backgroundImages.length - 1) ? _currentIndex + 1 : 0;
      });
    } else {
      setState(() {
        _currentIndex =
        (_currentIndex > 0) ? _currentIndex - 1 : _backgroundImages.length - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDrag,
      child: Card(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                _backgroundImages[_currentIndex],
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userNames[_currentIndex],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _userAges[_currentIndex],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    _userJobs[_currentIndex],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}