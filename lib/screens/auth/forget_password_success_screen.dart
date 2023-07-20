import 'package:flutter/material.dart';
import 'package:saah/utils/routes.dart';

class ForgetPasswordSuccessScreen extends StatelessWidget {
  final message;
  const ForgetPasswordSuccessScreen({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.authScreen,
                (Route<dynamic> route) => false,
              );
            },
            child: const Text(
              'Click here to login',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
