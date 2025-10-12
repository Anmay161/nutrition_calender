import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:nutrition_calender/constants/text_style.dart';
import 'package:nutrition_calender/pages/auth_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool firstanimation = true;
  bool secondanimation = true;

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 10),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthWrapper()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Rectangle_1.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 250,
                width: 300,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child:
                      (firstanimation)
                          ? AnimatedTextKit(
                            animatedTexts: [
                              WavyAnimatedText(
                                'Nutrition Calendar',
                                textStyle: WelcomeTexts.textformat,
                                speed: const Duration(milliseconds: 200),
                              ),
                            ],
                            displayFullTextOnTap: true,
                            isRepeatingAnimation: false,
                            onFinished: () {
                              firstanimation = false;
                              setState(() {});
                            },
                          )
                          : Text(
                            'Nutrition Calendar',
                            style: WelcomeTexts.textformat,
                          ),
                ),
              ),
              SizedBox(height: 200),
              SizedBox(
                width: 300,
                child: FittedBox(
                  child:
                      (firstanimation)
                          ? Text('')
                          : (secondanimation)
                          ? AnimatedTextKit(
                            animatedTexts: [
                              FadeAnimatedText(
                                'Be your best, healthiest self',
                                textStyle: WelcomeTexts.textformat,
                              ),
                            ],
                            isRepeatingAnimation: false,
                            onFinished: () {
                              secondanimation = false;
                              setState(() {});
                            },
                          )
                          : Text(
                            'Be your best, healthiest self',
                            style: WelcomeTexts.textformat,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
