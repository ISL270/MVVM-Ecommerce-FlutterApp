import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../views/sign_in/signin_screen.dart';

class SignInMessage extends StatefulWidget {
  const SignInMessage({Key key}) : super(key: key);

  @override
  _SignInMessageState createState() => _SignInMessageState();
}

class _SignInMessageState extends State<SignInMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: [
              Text(
                'You need to sign-in fIrst',
                style: TextStyle(fontFamily: 'PantonBoldItalic', fontSize: getProportionateScreenHeight(17), color: Colors.grey.shade600),
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              SignInMessage(),
            ],
          ),
        ],
      ),
    );
  }

  Widget SignInMessage() {
    return ElevatedButton(
      child: const Text(
        'Sign-In',
        style: TextStyle(color: Color(0xffeeecec), fontSize: 17, fontFamily: 'PantonBoldItalic'),
      ),
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(125),
              vertical: getProportionateScreenWidth(12),
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          backgroundColor: MaterialStateProperty.all<Color>(PrimaryColor),
          overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            return null;
          })),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, SignInScreen.routeName);
      },
    );
  }
}
