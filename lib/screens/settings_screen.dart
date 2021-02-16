import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  static final String routeName = '/settings-screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _ip = '192.168.29.181';
  Color _sliderBackgroundColor = Colors.white;
  Map<String, bool> userSettings = {'AlwaysOn': false};
  bool isPasswordCorrect = false;
  String _pass = '';
  TextEditingController _controller = TextEditingController();

  getSettings() async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    var a = json.decode(pr.getString('userSettings'));
    userSettings['AlwaysOn'] = a['AlwaysOn'];
    setState(() {});
  }

  saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String a = json.encode(userSettings);
    await prefs.setString('userSettings', a);
  }

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
  void initState() {
    getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getSettings();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: isPasswordCorrect
          ? SafeArea(
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
                          value: userSettings['AlwaysOn'] ?? false,
                          inactiveThumbColor: _sliderBackgroundColor,
                          inactiveTrackColor: Colors.white54,
                          onChanged: (value) async {
                            if (await sendResponse()) {
                              userSettings['AlwaysOn'] = value;
                              await saveSettings();
                              _sliderBackgroundColor = Colors.white;
                            } else {
                              _sliderBackgroundColor = Colors.red;
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
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      obscureText: true,
                      cursorColor: Colors.white24,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      keyboardAppearance: Brightness.dark,
                      maxLength: 4,
                      controller: _controller,
                      onChanged: (v) {
                        _pass = v;
                      },
                      style: TextStyle(
                        color: Colors.white54,
                        letterSpacing: 16,
                        fontSize: 30,
                        fontFamily: 'gilroy',
                      ),
                      decoration: InputDecoration(
                        focusColor: Colors.white54,
                        fillColor: Colors.white54,
                        hintText: 'XXXX',
                        hintStyle: TextStyle(
                          color: Colors.white24,
                          letterSpacing: 12,
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    color: Colors.white54,
                    child: Text(
                      'Unlock',
                    ),
                    onPressed: () {
                      if (_pass == '2001') {
                        isPasswordCorrect = true;
                        setState(() {});
                      } else {
                        _controller.clear();
                        _pass = '';
                        setState(() {});
                      }
                    },
                  )
                ],
              ),
            ),
    );
  }
}
