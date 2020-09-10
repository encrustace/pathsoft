import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/view/new_doctor.dart';
import 'package:pathsoft/view/new_test.dart';
import 'package:pathsoft/view/new_enrty.dart';

class CustomFloatButton extends StatefulWidget {
  @override
  _CustomFloatButtonState createState() => _CustomFloatButtonState();
}

class _CustomFloatButtonState extends State<CustomFloatButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.00, 1.00, curve: Curves.linear)));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.50,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget entry() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'entry',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewEntry(),
            ),
          );
          animate();
        },
        child: Icon(
          FontAwesomeIcons.plus,
        ),
      ),
    );
  }

  Widget test() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'test',
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewTest()));
          animate();
        },
        child: Icon(
          FontAwesomeIcons.notesMedical,
        ),
      ),
    );
  }

  Widget doctor() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'doctor',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewDoctor(),
            ),
          );
          animate();
        },
        child: Icon(
          FontAwesomeIcons.userMd,
        ),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'toggle',
        backgroundColor: _buttonColor.value,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
        onPressed: animate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: entry(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: test(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 1.0,
            0.0,
          ),
          child: doctor(),
        ),
        toggle(),
      ],
    );
  }
}
