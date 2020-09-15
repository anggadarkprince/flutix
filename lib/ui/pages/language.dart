import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/widgets/preference_builder.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<Map> languages = [
    {'code': 'en', 'language': 'English', 'description': 'English'},
    {'code': 'id', 'language': 'Indonesia', 'description': 'Bahasa Indonesia'},
  ];
  final String prefKey = 'language';
  final String prefDefaultValue = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text('Language'),
        backgroundColor: mainColor,
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [],
      ),
      body: SharedPreferencesBuilder<String>(
        pref: prefKey,
        prefDefault: prefDefaultValue,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: languages.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (_, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: RadioListTile(
                    title: Text(languages[index]['language']),
                    subtitle: Text(languages[index]['description']),
                    value: languages[index]['code'],
                    groupValue: snapshot.data,
                    activeColor: mainColor,
                    selected: languages[index]['code'] == snapshot.data,
                    controlAffinity: ListTileControlAffinity.platform,
                    onChanged: (code) {
                      setState(() {
                        SharedPreferencesBuilder.setData(prefKey, code);
                      });
                    },
                  )
                );
              }
            );
          }
          else {
            return Container();
          }
        },
      )
		);
  }

}
