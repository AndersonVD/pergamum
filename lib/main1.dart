import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _username = '';
  String _password = '';
  String _statusMessage = '';

  Future<void> _login() async {
    var url = Uri.parse('http://example.com/login.php');
    var response = await http
        .post(url, body: {'username': _username, 'password': _password});
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var statusElement = document.querySelector('#status');
      if (statusElement != null) {
        setState(() {
          _statusMessage = statusElement.text;
        });
      } else {
        setState(() {
          _statusMessage = 'Login successful!';
        });
        // Parsing example - extract data from HTML table
        var tableElement = document.querySelector('table');
        var rows = tableElement?.getElementsByTagName('tr');
        var data = [];
        for (var row in rows!) {
          var cells = row.getElementsByTagName('td');
          if (cells.length == 2) {
            var key = cells[0].text;
            var value = cells[1].text;
            data.add({'key': key, 'value': value});
          }
        }
        print(data);
      }
    } else {
      setState(() {
        _statusMessage = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (text) {
                _username = text;
              },
              decoration: InputDecoration(
                hintText: 'Username',
              ),
            ),
            TextField(
              onChanged: (text) {
                _password = text;
              },
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
