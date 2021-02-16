import 'package:dexter/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static final String routeName = '/splash-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _ip = '192.168.29.181';
  String _status = 'Toggle to get status';
  String _toggleBell = 'OFF';
  IconData _bellIcon = CupertinoIcons.bell;
  Color _bellBackgroundColor = Colors.white54;

  sendResponse() async {
    try {
      if (_ip != null) {
        var url = 'http://$_ip/ledstate';
        var response = await http.post(url);
        if (response.statusCode == 200) {
          print('Response status: ${response.statusCode} - Request Sent');

          print('Response body: ${response.body}');
          // setState(() {});
          _status =
              'Response status: ${response.statusCode} - Request Sent\nResponse body: ${response.body}\nResponse Status:\nbell status $_toggleBell';
          _toggleBell = response.body;

          setState(() {});
          return true;
        } else {
          _status =
              'Could not get Response. Possible issues:\n1. NodeMCU Power Down\nSol: Turn on Power of NodeMCU and Press Reset pin\n2. NodeMCU Not connected to WIFI\nSol: Re-start NodeMCU and press Hard Reset pin\n3. IP Address of NodeMCU is changed\nSol: Change the IP Address and add correct IP for NodeMCU';
          setState(() {});
          return false;
        }
      } else {
        _status = 'IP Address is Empty!';
        setState(() {});
        return false;
      }
    } catch (err) {
      setState(() {});
      _status =
          'Could not get Response. Possible issues:\n1. NodeMCU Power Down\nSol: Turn on Power of NodeMCU and Press Reset pin\n2. NodeMCU Not connected to WIFI\nSol: Re-start NodeMCU and press Hard Reset pin\n3. IP Address of NodeMCU is changed\nSol: Change the IP Address and add correct IP for NodeMCU\n\nDetails-\n$err';
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '101',
                    style: TextStyle(
                      fontSize: 150,
                      color: Colors.white54,
                      fontFamily: 'gilroy',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Santosh Kale',
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white38,
                      fontFamily: 'gilroy',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 95, right: 95, top: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: _bellBackgroundColor,
                  ),
                  child: GestureDetector(
                    onTapDown: (v) async {
                      if (await sendResponse()) {
                        setState(() {
                          _bellIcon = CupertinoIcons.bell_solid;
                          _bellBackgroundColor = Colors.white54;
                        });
                      } else {
                        print('no good');
                        setState(() {
                          _bellBackgroundColor = Colors.red.withOpacity(0.6);
                        });
                      }
                    },
                    onHorizontalDragUpdate: null,
                    onVerticalDragUpdate: null,
                    onTapUp: (v) async {
                      if (await sendResponse()) {
                        setState(() {
                          _bellIcon = CupertinoIcons.bell;
                          _bellBackgroundColor = Colors.white54;
                        });
                      } else {
                        print('No good');
                        setState(() {
                          _bellBackgroundColor = Colors.red.withOpacity(0.6);
                        });
                      }
                    },
                    child: Icon(
                      _bellIcon,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width * 0.40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 3, top: 20),
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white70,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
