import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key key,
    @required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30), vertical: getProportionateScreenWidth(5)),
          child: Text(
            product.title,
            maxLines: 3,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: SecondaryColorDark, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'PantonItalic'),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(30),
            vertical: getProportionateScreenWidth(5),
          ),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  product.price.toString() + ' EGP',
                  style: const TextStyle(color: PrimaryColor, fontSize: 18, fontFamily: 'PantonBoldItalic'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
