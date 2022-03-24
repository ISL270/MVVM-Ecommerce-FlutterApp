import 'package:flutter/widgets.dart';
import '../../../views/cart/cart_screen.dart';
import '../../../views/category/categoryScreen.dart';
import '../../../views/prodDetails/details_screen.dart';
import '../../../views/home/home_screen.dart';
import '../../../views/home/components/searchScreen.dart';
import '../../../views/profile/profile_screen.dart';
import '../../../views/sign_in/SignInScreen.dart';
import '../../../views/favourites/Favs_screen.dart';
import '../../../views/sign_up/SignUpScreen.dart';
import '../../../views/profile/components/orders/ordersScreen.dart';
import '../../../views/profile/components/userInfo/userInfo.dart';

final Map<String, WidgetBuilder> routes = {
  FavScreen.routeName: (context) => FavScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CategoryScreen.routeName: (context) => CategoryScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
  UserInfoScreen.routeName: (context) => UserInfoScreen(),
  SearchScreen.routeName: (context) => SearchScreen(),
};
