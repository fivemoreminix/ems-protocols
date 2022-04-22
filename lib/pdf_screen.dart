import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfScreen extends StatelessWidget {
  const PdfScreen(this.controller, {Key? key}) : super(key: key);

  final PdfControllerPinch controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: PdfViewPinch(
        controller: controller,
        // renderer: (PdfPage page) => page.render(
        //   width: page.width * 2,
        //   height: page.height * 2,
        //   format: PdfPageImageFormat.jpeg,
        //   backgroundColor: '#FFFFFF',
        // ),
      )),
    );
  }
}
