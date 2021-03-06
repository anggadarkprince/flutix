import 'package:flushbar/flushbar.dart';
import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/registration.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutix/ui/pages/register_confirmation.dart';
import 'package:flutix/ui/widgets/selectable_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreferenceScreen extends StatefulWidget {
  final List<String> genres = [
    "Horror",
    "Music",
    "Action",
    "Drama",
    "War",
    "Crime"
  ];
  final List<String> languages = [
    "Bahasa",
    "English",
    "Japanese",
    "Korean",
  ];
  
  final Registration registrationData;

  PreferenceScreen(this.registrationData);

  @override
  _PreferenceScreenState createState() {
    return _PreferenceScreenState();
  }
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  List<String> selectedGenres = [];
  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {  
    var mediaQuery = MediaQuery.of(context);
    
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(defaultMargin),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildPreferableContent(mediaQuery),
              _buildSubmitButton(),
              SizedBox(height: 20),
            ],
          ),
        ]
      )
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        SizedBox(height: 25),
        Container(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                  child: Icon(Icons.arrow_back, color: darkColor),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      MyLocalization.of(context).moviePreferences,
                      style: darkTextFont.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildPreferableContent(MediaQueryData mediaQuery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Text(
          "Hi ${this.widget.registrationData.name},",
          style: greyTextFont.copyWith(fontSize: 14), 
        ),
        SizedBox(height: 10),
        Text(
          MyLocalization.of(context).yourFavoriteGenre,
          style: purpleTextFont.copyWith(
            fontSize: 22, fontWeight: FontWeight.w600
          )
        ),
        SizedBox(height: defaultMargin),
        Wrap(
          direction: Axis.horizontal,
          spacing: defaultMargin,
          runSpacing: defaultMargin / 2,
          children: generateGenreWidgets(mediaQuery),
        ),
        SizedBox(height: 30),
        Text(
          MyLocalization.of(context).languageYourPrefer,
          style: purpleTextFont.copyWith(
            fontSize: 22, fontWeight: FontWeight.w600
          )
        ),
        SizedBox(height: defaultMargin),
        Wrap(
          direction: Axis.horizontal,
          spacing: defaultMargin,
          runSpacing: defaultMargin / 2,
          children: generateLangWidgets(mediaQuery),
        ),
        SizedBox(height: 40),
      ]
    );
  }
  
  List<Widget> generateGenreWidgets(MediaQueryData mediaQuery) {
    double width = (mediaQuery.size.width - 2 * defaultMargin - 24) / 2;

    var boxList = widget.genres.map((genre) {
      return SelectableBox(
        genre,
        width: width,
        isSelected: selectedGenres.contains(genre),
        onTap: (title) {
          onSelectGenre(genre);
        },
      );
    });

    return boxList.toList();
  }
  
  void onSelectGenre(String genre) {
    if (selectedGenres.contains(genre)) {
      setState(() {
        selectedGenres.remove(genre);
      });
    } else {
      if (selectedGenres.length < 4) {
        setState(() {
          selectedGenres.add(genre);
        });
      }
    }
  }

  List<Widget> generateLangWidgets(MediaQueryData mediaQuery) {
    double width = (mediaQuery.size.width - 2 * defaultMargin - 24) / 2;

    var boxList = widget.languages
      .map((language) => SelectableBox(
        language,
        width: width,
        isSelected: selectedLanguage == language,
        onTap: (title) {
          setState(() {
            selectedLanguage = language;
          });
        },
      ));

    return boxList.toList();
  }

  Widget _buildSubmitButton() {
    return Center(
      child: FloatingActionButton(
        elevation: 4,
        backgroundColor: mainColor,
        child: Icon(Icons.arrow_forward, color: Colors.white),
        onPressed: () {
          if (selectedGenres.length != 4) {
            Flushbar(
              duration: Duration(milliseconds: 1500),
              flushbarPosition: FlushbarPosition.BOTTOM,
              backgroundColor: Color(0xFFFF5C83),
              message: MyLocalization.of(context).selectGenreMessage,
            )..show(context);
          } else {
            widget.registrationData.selectedGenres = selectedGenres;
            widget.registrationData.selectedLang = selectedLanguage;
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterConfirmationScreen(widget.registrationData)));
          }
        }
      ),
    );
  }
}