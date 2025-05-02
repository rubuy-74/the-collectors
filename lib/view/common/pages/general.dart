import 'package:usettle/view/common/components/navbar.dart';
import 'package:flutter/material.dart';

abstract class GeneralPageViewState<T extends StatefulWidget> extends State<T> {
  String? getTitle();

  Widget getBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    String? title = getTitle();

    return Scaffold(
      extendBody: false,
      appBar:
          title != null
              ? AppBar(
                title: Text(title),
                centerTitle: true,
                elevation: 0,
                automaticallyImplyLeading: false,
              )
              : null,
      body: getBody(context),
      bottomNavigationBar: const SafeArea(child: CustomBottomNavbar()),
    );
  }
}
