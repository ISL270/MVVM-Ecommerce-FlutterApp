import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../../models/product_card.dart';
import 'package:provider/provider.dart';
import '../../view_models/global_vars_view_model.dart';

class CategoryScreen extends StatelessWidget {
  static String routeName = '/category';

  const CategoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoryDetailsArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: PrimaryLightColor,
      appBar: AppBar(
        elevation: 5,
        shadowColor: SecondaryColorDark.withOpacity(0.2),
        iconTheme: const IconThemeData(color: SecondaryColorDark),
        title: Text(
          args.category,
          style: TextStyle(
            color: SecondaryColorDark,
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.w900,
            fontFamily: 'Panton',
          ),
        ),
        backgroundColor: CardBackgroundColor,
      ),
      body: Consumer<GlobalVars>(builder: (_, gv, __) {
        return GridView.count(
          padding: EdgeInsets.all(getProportionateScreenWidth(25)),
          childAspectRatio: Theme.of(context).platform == TargetPlatform.iOS ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.5) : MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.35),
          crossAxisSpacing: getProportionateScreenWidth(25),
          crossAxisCount: 2,
          children: List.generate(
            gv.AllProds[args.category].length,
            (index) {
              return ProductCard(product: gv.AllProds[args.category][index]);
            },
          ),
        );
      }),
    );
  }
}

class CategoryDetailsArguments {
  final String category;
  CategoryDetailsArguments({@required this.category});
}
