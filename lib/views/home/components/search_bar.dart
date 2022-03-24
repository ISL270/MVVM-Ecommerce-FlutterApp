import 'search_screen.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      decoration: BoxDecoration(
        color: SecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          Navigator.pushNamed(
            context,
            SearchScreen.routeName,
            arguments: SearchKeyword(keyword: value),
          );
        },
        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenWidth(9)), border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, hintText: 'Search product', prefixIcon: const Icon(Icons.search)),
      ),
    );
  }
}
