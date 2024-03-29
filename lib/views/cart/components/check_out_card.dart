import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../utils/signin_message.dart';
import '../../../view_models/auth_view_model.dart';
import '../../../view_models/global_vars_view_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import 'package:provider/provider.dart';
import '../../../views/check_out/checkout_bottom_sheet.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(20),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.95),
          )
        ],
      ),
      child: Consumer<GlobalVars>(builder: (_, gv, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                text: 'Total:\n',
                style: const TextStyle(color: SecondaryColorDark, fontSize: 12, fontFamily: 'PantonBoldItalic'),
                children: [
                  TextSpan(
                    text: '${gv.total} EGP',
                    style: const TextStyle(color: PrimaryColor, fontSize: 20, fontFamily: 'PantonBoldItalic'),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(190),
              child: ElevatedButton(
                child: Text('Checkout', style: TextStyle(fontFamily: 'PantonBoldItalic', fontSize: getProportionateScreenWidth(17))),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(17),
                    ),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  backgroundColor: MaterialStateProperty.all<Color>(PrimaryColor),
                ),
                onPressed: () {
                  if (gv.userCart.isNotEmpty) {
                    if (context.read<AuthViewModel>().CurrentUser().isAnonymous) {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext bc) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: const SignInMessage(),
                            );
                          });
                    } else {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext bc) {
                            return CheckoutBottomSheet();
                          });
                    }
                  } else {
                    log('Cart is empty');
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
