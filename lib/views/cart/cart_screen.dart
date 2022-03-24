import 'package:flutter/material.dart';
import 'components/cart_body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart';

  const CartScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: Scaffold(
        body: CartBody(),
        bottomNavigationBar: CheckoutCard(),
      ),
    );
  }
}
