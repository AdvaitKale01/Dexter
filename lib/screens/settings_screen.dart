import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  static final String routeName = '/settings-screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, bool> userSettings = {
    'AlwaysOn': false,
  };
  String _ip = '192.168.29.181';

  sendResponse() async {
    try {
      if (_ip != null) {
        var url = 'http://$_ip/ledstate';
        var response = await http.post(url);
        if (response.statusCode == 200) {
          print('Response status: ${response.statusCode} - Request Sent');

          print('Response body: ${response.body}');

          setState(() {});
          return true;
        } else {
          print('ESP not ON!');
          setState(() {});
          return false;
        }
      } else {
        print('No IP found! Try diff IP.');
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userSettings.keys.toList()[0],
                    style: TextStyle(color: Colors.white54),
                  ),
                  Switch(
                    value: userSettings['AlwaysOn'],
                    inactiveTrackColor: Colors.white54,
                    onChanged: (value) async {
                      if (await sendResponse()) {
                        userSettings['AlwaysOn'] = value;
                      } else {
                        print('no switch');
                      }
                      setState(() {
                        print(userSettings);
                      });
                    },
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
