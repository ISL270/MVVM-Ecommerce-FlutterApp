import 'dart:developer';
import 'package:ecommerce_app/models/Product.dart';
import 'package:flutter/material.dart';
import '../../../view_models/global_vars_view_model.dart';
import '../../../utils/size_config.dart';
import '../../../utils/constants.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../view_models/user_info_view_model.dart';
import '../../../view_models/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Body extends StatefulWidget {
  final Product product;
  const Body({Key key, @required this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String size = 'S';
  User user;
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    user = context.read<AuthViewModel>().CurrentUser();
    final UserInfoViewModel u = UserInfoViewModel(uid: user.uid);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 13),
        child: Consumer<GlobalVars>(builder: (_, gv, __) {
          return FloatingActionButton(
            heroTag: UniqueKey(),
            mini: true,
            backgroundColor: const Color(0xfff6f8f8),
            onPressed: () async {
              if (gv.UserInfo != null && gv.UserInfo.containsKey('Favorites') && gv.UserInfo['Favorites'].contains(widget.product.id)) {
                u.removeFromFavs(widget.product.id);
                gv.removeFromFavs(widget.product.id);
              } else {
                u.addToFavs(widget.product.id);
                gv.addToFavs(widget.product.id);
              }
            },
            child: Icon(
              gv.UserInfo == null || !gv.UserInfo.containsKey('Favorites') || !gv.UserInfo['Favorites'].contains(widget.product.id) ? Icons.favorite_border_outlined : Icons.favorite,
              color: PrimaryColor,
            ),
          );
        }),
      ),
      body: Consumer<GlobalVars>(builder: (_, gv, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 7, child: ProductImages(product: widget.product)),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            Flexible(
              flex: 6,
              child: TopRoundedContainer(
                color: const Color(0xfff6f8f8),
                child: Column(
                  children: [
                    Flexible(
                      flex: 16,
                      child: ProductDescription(
                        product: widget.product,
                        pressOnSeeMore: () {},
                      ),
                    ),
                    Flexible(
                      flex: 30,
                      child: TopRoundedContainer(
                        color: PrimaryLightColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: gv.AllProds['Shoes'].contains(widget.product)
                                  ? Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSizeOptions('36'),
                                        buildSizeOptions('39'),
                                        buildSizeOptions('42'),
                                        buildSizeOptions('45'),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSizeOptions('S'),
                                        buildSizeOptions('M'),
                                        buildSizeOptions('L'),
                                        buildSizeOptions('XL'),
                                      ],
                                    ),
                            ),
                            //ColorDots(product: product),
                            Flexible(
                              flex: 10,
                              child: TopRoundedContainer(
                                color: const Color(0xfff6f8f8),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: getProportionateScreenWidth(30),
                                    right: getProportionateScreenWidth(30),
                                    bottom: getProportionateScreenHeight(35),
                                    top: getProportionateScreenHeight(12),
                                  ),
                                  child: Consumer<GlobalVars>(builder: (_, gv, __) {
                                    return buildTextWithIcon(gv, u);
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void onPressedIconWithText(GlobalVars gv, UserInfoViewModel u) async {
    setState(() {
      stateTextWithIcon = ButtonState.loading;
    });
    bool connection = await InternetConnectionChecker().hasConnection;
    if (connection) {
      try {
        String temp = widget.product.id + size;
        List<String> tempLsit = [];

        for (int i = 0; i < gv.userCart.length; i++) {
          tempLsit.add(gv.userCart[i].uid);
        }
        if (!tempLsit.contains(temp) || user.isAnonymous) {
          gv.addToUserCart(widget.product, 1, size);
          u.addToCart(widget.product.id, size, 1);
          setState(() {
            stateTextWithIcon = ButtonState.success;
          });
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!mounted) return;
            setState(() {
              stateTextWithIcon = ButtonState.idle;
            });
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
      } catch (e) {
        log(e);
      }
    } else {
      setState(() {
        stateTextWithIcon = ButtonState.ExtraState1;
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
        height: getProportionateScreenHeight(63),
        radius: 20.0,
        textStyle: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'PantonBoldItalic'),
        iconedButtons: const {
          ButtonState.idle: IconedButton(
              text: 'Add to Cart',
              icon: Icon(
                Icons.add_rounded,
                size: 0.01,
                color: PrimaryColor,
              ),
              color: PrimaryColor),
          ButtonState.loading: IconedButton(text: 'Loading', color: PrimaryColor),
          ButtonState.fail: IconedButton(text: 'Already in cart', icon: Icon(Icons.cancel, color: Colors.white), color: PrimaryColor),
          ButtonState.success: IconedButton(
              text: 'Added successfully',
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: PrimaryColor),
          ButtonState.ExtraState1: IconedButton(
              text: 'Connection Lost',
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              color: PrimaryColor)
        },
        onPressed: () => onPressedIconWithText(gv, u),
        state: stateTextWithIcon);
  }

  GestureDetector buildSizeOptions(String s) {
    return GestureDetector(
      onTap: () {
        setState(() {
          size = s;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6),
        child: AnimatedContainer(
          duration: defaultDuration,
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(8),
          height: getProportionateScreenWidth(48),
          width: getProportionateScreenWidth(48),
          decoration: BoxDecoration(
            color: const Color(0xfff6f8f8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: PrimaryColor.withOpacity(size == s ? 1 : 0)),
          ),
          child: Center(
            child: Text(
              s,
              style: const TextStyle(color: SecondaryColorDark, fontSize: 15, fontFamily: 'PantonBoldItalic'),
            ),
          ),
        ),
      ),
    );
  }
}
