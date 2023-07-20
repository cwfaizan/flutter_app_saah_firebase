import 'package:flutter/material.dart';
import 'package:saah/models/donate.dart';
import 'package:share_plus/share_plus.dart';

class CharityScreen extends StatefulWidget {
  final imageFile;
  const CharityScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<CharityScreen> createState() => _CharityScreenState();
}

class _CharityScreenState extends State<CharityScreen> {
  final charitiesList = [
    Donate(label: 'Contact Kiswah Charity', path: 'assets/charities/ch3.png'),
    Donate(label: 'Contact Kiswaksa Charity', path: 'assets/charities/ch1.jpg'),
    Donate(label: 'Contact Ahtwa Charity', path: 'assets/charities/ch2.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: charitiesList.length,
          itemBuilder: (ctx, index) => Row(
            children: [
              Column(
                children: [
                  Text(
                    charitiesList[index].label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: shareImage,
                    icon: const Icon(
                      Icons.share,
                      size: 50,
                    ),
                  )
                ],
              ),
              Image.asset(
                charitiesList[index].path,
                fit: BoxFit.fill,
                height: 200,
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void shareImage() async {
    await Share.shareFiles([widget.imageFile.path]);
  }
}
