import 'package:flutter/material.dart';
import '../../../models/product_card.dart';
import '../views/category/category_screen.dart';
import '../utils/size_config.dart';
import '../views/home/components/section_title.dart';
import 'package:provider/provider.dart';
import '../view_models/global_vars_view_model.dart';

class Category extends StatelessWidget {
  final String cat;

  const Category({Key key, @required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenWidth(20)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: cat,
              press: () {
                Navigator.pushNamed(
                  context,
                  CategoryScreen.routeName,
                  arguments: CategoryDetailsArguments(category: cat),
                );
              }),
        ),
        SizedBox(height: getProportionateScreenHeight(8)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Consumer<GlobalVars>(builder: (_, gv, __) {
            return Row(
              children: [
                ...List.generate(
                  gv.AllProds[cat].length < 5 ? gv.AllProds[cat].length : 5,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ProductCard(product: gv.AllProds[cat][index]),
                    );
                  },
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
              ],
            );
          }),
        ),
      ],
    );
  }
}
