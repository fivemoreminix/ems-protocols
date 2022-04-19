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
            child: Container(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                          builder: (context) =>
                                              const SigninPage()));
                                },
                                child: const Text('Sign in')),
                            ElevatedButton(
                                onPressed: () {}, child: const Text('Register'))
                          ],
                        ),
                      ),
                      Text(
                        'A digital handbook for Northwest Arkansas Regional EMS Protocols.',
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0).copyWith(top: 32.0),
                        child: Text(
                          'The app provides every entry of your EMS protocols, with powerful search and bookmarking so Paramedics and EMTs can access the pertinent information they need, quickly.',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: CarouselSlider(
                              items: [
                                Image(image: AssetImage('images/one.jpg')),
                                Image(image: AssetImage('images/two.jpg')),
                                Image(image: AssetImage('images/three.jpg'))
                              ]
                                  .map((img) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: img,
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                  enableInfiniteScroll: false))),
                    ],
                  ),
                ))));
  }
}
