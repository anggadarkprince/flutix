import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LegalScreen extends StatefulWidget {
  final String html;

  LegalScreen(this.html);

  @override
  _LegalScreenState createState() {
    return _LegalScreenState();
  }
}

class _LegalScreenState extends State<LegalScreen> {
  WebViewController _controller;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Privacy Policy'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == 'Further Information') {
                const url = 'mailto:anggadarkprince@gmail.com';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not launch $url'),
                      duration: Duration(milliseconds: 1000)
                    )
                  );
                }
              } else if (value == 'Movie Database') {
                const url = 'https://tmdb.org';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not launch $url'),
                      duration: Duration(milliseconds: 1000)
                    )
                  );
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              const PopupMenuItem<String>(
                value: 'Further Information',
                child: Text('Further Information'),
              ),
              const PopupMenuItem<String>(
                value: 'Movie Database',
                child: Text('Movie Database'),
              ),
              const PopupMenuItem<String>(
                value: 'Close',
                child: Text('Close'),
              ),
            ],
          )
        ],
      ),
      body: WebView(
        //initialUrl: 'https://en.wikipedia.org/wiki/Kraken',
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
      floatingActionButton: RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          elevation: 4,
          color: mainColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Text(
            "I AGREE",
            style: whiteTextFont.copyWith(fontSize: 16),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
    );
  }

  void _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString(widget.html);
    print(fileText);
    _controller.loadUrl(
      Uri.dataFromString(fileText,
      mimeType: 'text/html', 
      encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}
