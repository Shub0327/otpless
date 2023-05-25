import 'package:flutter/material.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class LoginWithWhatsapp extends StatefulWidget {
  const LoginWithWhatsapp({Key? key}) : super(key: key);

  @override
  State<LoginWithWhatsapp> createState() => _LoginWithWhatsappState();
}

class _LoginWithWhatsappState extends State<LoginWithWhatsapp> {


  Map<String, dynamic>? _userDetails;
  final _otplessFlutterPlugin = Otpless();

  Future<void> verifyWaid({required String? waId}) async {
    try {
      Map<String, String?> requestBody = {"waId": waId};
      Map<String, String> headers = {
        "clientId": "6355bteo",
        "clientSecret": "a3m4kgx29ss5yycb",
        "Content-Type": "application/json"
      };
      String url = "https://ternaengg.authlink.me?redirectUri=ternaenggotpless://otpless";
      await http
          .post(Uri.parse(url),
          headers: headers, body: json.encode(requestBody))
          .then((response) {
        Logger().i(response.body);
        setState(() {
          _userDetails = json.decode(response.body);
        });
      });
    } catch (error) {
      Logger().e(error);
    }
  }

  void initiateWhatsappLogin(String intentUrl) async {
    try {
      var result =
      await _otplessFlutterPlugin.loginUsingWhatsapp(intentUrl: intentUrl);
      Logger().i(result);
    } catch (error) {
      Logger().e(error);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _otplessFlutterPlugin.authStream.listen((token) async {
      await verifyWaid(waId: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap:(){initiateWhatsappLogin("https://ternaengg.authlink.me?redirectUri=ternaenggotpless://otpless");},
                  child: Text(
                    'Login With Whatsapp',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Icon(
                  Icons.ac_unit,
                  color: Colors.green,
                  size: 30,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                margin: EdgeInsets.all(30),
                child: Text(_userDetails.toString())),
          )
        ],
      ),
    );
  }
}
