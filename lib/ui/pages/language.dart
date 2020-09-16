import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/provider_localization.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/widgets/preference_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<Map> languages = [
    {'code': 'en', 'countryCode': 'US', 'language': 'English', 'description': 'English'},
    {'code': 'id', 'countryCode': 'ID', 'language': 'Indonesia', 'description': 'Bahasa Indonesia'},
  ];
  final String prefLanguageKey = 'language';
  final String prefLanguageDefaultValue = 'en';
  final String prefCountryCodeKey = 'countryCode';
  final String prefCountryCodeDefaultValue = 'US';

  @override
  Widget build(BuildContext context) {
    final providerLocalization = Provider.of<ProviderLocalization>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text(MyLocalization.of(context).menuChangeLanguage),
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
        pref: prefLanguageKey,
        prefDefault: prefLanguageDefaultValue,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: languages.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (_, index) {
                String currentLanguageCode = languages[index]['code'];
                String currentCountryCode = languages[index]['countryCode'];
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
                        // save to preference
                        SharedPreferencesBuilder.setData(prefLanguageKey, currentLanguageCode);
                        SharedPreferencesBuilder.setData(prefCountryCodeKey, currentCountryCode);
                        
                        // load language and update UI
                        MyLocalization.load(Locale(currentLanguageCode, currentCountryCode));
                        providerLocalization.setLanguage(Locale(currentLanguageCode, currentCountryCode));
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
