import 'package:flutter/material.dart';
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String option1;
  final String uid;

  CartItem({@required this.product, @required this.quantity, @required this.option1, @required this.uid});
}
