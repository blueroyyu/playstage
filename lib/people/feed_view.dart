import 'package:flutter/material.dart';
import 'package:playstage/factory.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    return makeFeedList(member, feedList);
  }
}