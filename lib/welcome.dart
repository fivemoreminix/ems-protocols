import 'package:carousel_slider/carousel_slider.dart';
import 'package:ems_protocols/login.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMS Protocols')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 8.0, right: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SigninPage()));
                      },
                      child: const Text('Sign in')),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Register'))
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                  'A digital protocol handbook for EMTs and Paramedics.',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Theme.of(context).canvasColor,
                      backgroundColor: Theme.of(context).backgroundColor,
                      height: 1.3),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: CarouselSlider(
                    items: [
                      Image(image: AssetImage('assets/images/one.jpg')),
                      Image(image: AssetImage('assets/images/two.jpg')),
                      Image(image: AssetImage('assets/images/three.jpg'))
                    ].map((img) => Card(child: img)).toList(),
                    options: CarouselOptions(enableInfiniteScroll: false))),
          ],
        ),
      ),
    );
  }
}
