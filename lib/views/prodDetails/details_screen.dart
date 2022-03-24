import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/constants.dart';
import '../../../models/product.dart';
import 'components/details_body.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = '/details';

  const DetailsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments args = ModalRoute.of(context).settings.arguments;
    return Container(
      color: PrimaryLightColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: PrimaryLightColor,
          body: Body(product: args.product),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: FloatingActionButton(
              heroTag: UniqueKey(),
              mini: true,
              backgroundColor: const Color(0xfff6f8f8),
              onPressed: () => Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/icons/Back ICon.svg',
                height: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;
  ProductDetailsArguments({@required this.product});
}
