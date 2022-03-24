import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import '../../view_models/global_vars_view_model.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../view_models/user_info_view_model.dart';
import 'package:nanoid/nanoid.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../profile/components/userInfo/user_info.dart';

class CheckoutBottomSheet extends StatefulWidget {
  bool paymentSection = false;
  bool addressSection = false;
  bool TotalSection = false;

  CheckoutBottomSheet({Key key}) : super(key: key);

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  User user;
  ButtonState stateTextWithIcon = ButtonState.idle;

  void onPressedIconWithText(GlobalVars gv, UserInfoViewModel u) async {
    setState(() {
      stateTextWithIcon = ButtonState.loading;
    });
    bool connection = await InternetConnectionChecker().hasConnection;
    if (connection == true) {
      Future.delayed(const Duration(milliseconds: 600), () {
        try {
          if (gv.paymentMethod != 'Select Method') {
            List<dynamic> tempCart = [];
            Map map = new Map<String, dynamic>();
            for (int i = 0; i < gv.userCart.length; i++) {
              tempCart.add(map = {
                'id': gv.userCart[i].product.id,
                'option1': gv.userCart[i].option1,
                'quantity': gv.userCart[i].quantity,
                'total': gv.userCart[i].quantity * gv.userCart[i].product.price,
              });
            }
            String orderID = customAlphabet('0123456789', 18);
            u.addOrder(orderID, tempCart, gv.paymentMethod, gv.total);
            u.DeleteAttribute('cart');
            gv.resetCart();
            gv.resetPmethod();
            setState(() {
              stateTextWithIcon = ButtonState.success;
            });
            Future.delayed(const Duration(milliseconds: 1250), () {
              Navigator.pop(context);
            });
            gv.selectedPage = 0;
          } else {
            setState(() {
              stateTextWithIcon = ButtonState.ExtraState1;
            });
            Future.delayed(const Duration(milliseconds: 2000), () {
              setState(() {
                stateTextWithIcon = ButtonState.idle;
              });
            });
          }
        } catch (e) {
          setState(() {
            stateTextWithIcon = ButtonState.fail;
          });
          Future.delayed(const Duration(milliseconds: 1500), () {
            setState(() {
              stateTextWithIcon = ButtonState.idle;
            });
          });
          log(e);
        }
      });
    } else {
      setState(() {
        stateTextWithIcon = ButtonState.fail;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() {
          stateTextWithIcon = ButtonState.idle;
        });
      });
    }
  }

  Widget buildTextWithIcon(GlobalVars gv, UserInfoViewModel u) {
    return ProgressButton.icon(
        radius: 20.0,
        textStyle: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'PantonBoldItalic'),
        iconedButtons: {
          ButtonState.idle: const IconedButton(
              text: 'Place Order',
              icon: Icon(
                Icons.add_rounded,
                size: 0.01,
                color: PrimaryColor,
              ),
              color: PrimaryColor),
          ButtonState.loading: const IconedButton(text: 'Loading', color: PrimaryColor),
          ButtonState.fail: const IconedButton(
              text: 'Connection Lost',
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              color: PrimaryColor),
          ButtonState.success: IconedButton(
              text: 'Order Placed',
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400),
          ButtonState.ExtraState1: const IconedButton(
              text: 'Choose payment method',
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              color: PrimaryColor),
        },
        onPressed: () => onPressedIconWithText(gv, u),
        state: stateTextWithIcon);
  }

  @override
  Widget build(BuildContext context) {
    user = context.read<AuthViewModel>().CurrentUser();
    final UserInfoViewModel u = UserInfoViewModel(uid: user.uid);
    return Consumer<GlobalVars>(builder: (_, gv, __) {
      gv.getUserInfo(user);
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 30,
        ),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: [
                const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 24,
                    color: PrimaryColor,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 25,
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            getDivider(),
            InkWell(
              child: checkoutRow('Payment', widget.paymentSection, false, trailingText: gv.paymentMethod),
              onTap: () {
                setState(() {
                  widget.paymentSection = !widget.paymentSection;
                  widget.addressSection = false;
                  widget.TotalSection = false;
                });
              },
            ),
            AnimatedSizeAndFade.showHide(
              fadeInCurve: Curves.easeInOutQuint,
              fadeOutCurve: Curves.easeInOutQuint,
              sizeCurve: Curves.easeInOutQuint,
              show: widget.paymentSection,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          gv.changePaymentMethod('Cash on Delivery');
                          widget.paymentSection = !widget.paymentSection;
                        });
                      },
                      child: const ListTile(
                        title: Text('Cash on Delivery'),
                        trailing: Icon(Icons.local_atm_outlined),
                      ),
                    ),
                    const Divider(
                      indent: 17,
                      endIndent: 17,
                      thickness: 1,
                      color: Color(0xFFE2E2E2),
                    ),
                    InkWell(
                      enableFeedback: true,
                      onTap: () {
                        setState(() {
                          gv.changePaymentMethod('Credit/Debit Card');
                          widget.paymentSection = !widget.paymentSection;
                        });
                      },
                      child: const ListTile(
                        title: Text('Credit/Debit Card'),
                        trailing: Icon(Icons.credit_card),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            getDivider(),
            InkWell(
              child: checkoutRow('Address', widget.addressSection, true, trailingText: gv.UserInfo['Address']),
              onTap: () {
                setState(() {
                  widget.addressSection = !widget.addressSection;
                  widget.paymentSection = false;
                  widget.TotalSection = false;
                });
              },
            ),
            AnimatedSizeAndFade.showHide(
              fadeInCurve: Curves.easeInOutQuint,
              fadeOutCurve: Curves.easeInOutQuint,
              sizeCurve: Curves.easeInOutQuint,
              show: widget.addressSection,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${gv.UserInfo['Governorate']}, ${gv.UserInfo['Address']}",
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, UserInfoScreen.routeName).then((_) => setState(() {
                              widget.addressSection = false;
                            }));
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'PantonBoldItalic'),
                      ),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(PrimaryColor), fixedSize: MaterialStateProperty.all<Size>(Size(double.infinity, getProportionateScreenHeight(30))), elevation: MaterialStateProperty.all<double>(0), shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                    ),
                  )
                ],
              ),
            ),
            getDivider(),
            InkWell(
              child: checkoutRow('Total Cost', widget.TotalSection, false, trailingText: '${(gv.total).toString()} EGP'),
              onTap: () {
                setState(() {
                  widget.addressSection = false;
                  widget.paymentSection = false;
                  widget.TotalSection = !widget.TotalSection;
                });
              },
            ),
            AnimatedSizeAndFade.showHide(
                fadeInCurve: Curves.easeInOutQuint,
                fadeOutCurve: Curves.easeInOutQuint,
                sizeCurve: Curves.easeInOutQuint,
                show: widget.TotalSection,
                child: Column(
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: gv.userCart.length,
                        itemBuilder: (context, index) => ListTile(
                              title: Text(
                                '${gv.userCart[index].option1} - ${gv.userCart[index].product.title}',
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Text('${gv.userCart[index].quantity.toString()}x'),
                              trailing: Text((gv.userCart[index].quantity * gv.userCart[index].product.price).toString()),
                            )),
                    const ListTile(
                      title: Text('Shipping fees'),
                      trailing: Text('40'),
                    )
                  ],
                )),
            getDivider(),
            const SizedBox(
              height: 30,
            ),
            termsAndConditionsAgreement(context),
            Container(
              margin: const EdgeInsets.only(
                top: 25,
              ),
              child: buildTextWithIcon(gv, u),
            ),
          ],
        ),
      );
    });
  }

  Widget getDivider() {
    return const Divider(
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }

  Widget termsAndConditionsAgreement(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: 'By placing an order you agree to our',
          style: TextStyle(
            color: const Color(0xFF7C7C7C),
            fontSize: 14,
            fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
            fontWeight: FontWeight.w600,
          ),
          children: const [
            TextSpan(text: ' Terms', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            TextSpan(text: ' And'),
            TextSpan(text: ' Conditions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ]),
    );
  }

  Widget checkoutRow(String label, bool b, bool overflow, {String trailingText, Widget trailingWidget}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF7C7C7C),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          trailingText == null
              ? trailingWidget
              : overflow
                  ? Expanded(
                      child: Text(
                        trailingText,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Text(
                      trailingText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          const SizedBox(
            width: 20,
          ),
          Icon(
            b ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
            size: 25,
          )
        ],
      ),
    );
  }
}
