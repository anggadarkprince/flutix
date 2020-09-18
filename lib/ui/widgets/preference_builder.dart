import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppPrefs {
  language,
  countryCode,
  recentSearch,
}

class SharedPreferencesBuilder<T> extends StatelessWidget {
	final String pref;
	final String prefDefault;
	final AsyncWidgetBuilder<T> builder;
	
	const SharedPreferencesBuilder({
		Key key,
		@required this.pref,
		@required this.builder,
		this.prefDefault,
	}) : super(key: key);
	
	@override
	Widget build(BuildContext context) {
		return FutureBuilder<T>(
			future: _future(),
			builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
				return this.builder(context, snapshot);
			});
	}
	
	Future<T> _future() async {
		return (await SharedPreferences.getInstance()).get(pref) ?? prefDefault;
	}

	static Future getData(pref, prefDefault) async{
		return (await SharedPreferences.getInstance()).get(pref) ?? prefDefault;
	}

  static Future<bool> setData(String pref, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is String) {
      return prefs.setString(pref, value);
    }
    if (value is int) {
      return prefs.setInt(pref, value);
    }
    if (value is bool) {
      return prefs.setBool(pref, value);
    }
    if (value is double) {
      return prefs.setDouble(pref, value);
    }
    if (value is List) {
      return prefs.setStringList(pref, value);
    }

    return null;
  }
  
}