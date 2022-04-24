import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class ProtocolImagePage extends StatelessWidget {
  const ProtocolImagePage(this.image, {Key? key}) : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
          child: Image(
            image: image,
          ),
        ),
      ),
    );
  }
}

@Deprecated("Use ProtocolImagePage with images instead")
class ProtocolPdfPage extends StatelessWidget {
  const ProtocolPdfPage(this.controller, {Key? key}) : super(key: key);

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
