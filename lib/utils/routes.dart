import 'package:flutter/widgets.dart';
import '../../../views/cart/cart_screen.dart';
import '../views/category/category_screen.dart';
import '../../../views/prodDetails/details_screen.dart';
import '../../../views/home/home_screen.dart';
import '../views/home/components/search_screen.dart';
import '../../../views/profile/profile_screen.dart';
import '../views/sign_in/signin_screen.dart';
import '../views/favourites/favs_screen.dart';
import '../views/sign_up/signup_screen.dart';
import '../views/profile/components/orders/orders_screen.dart';
import '../views/profile/components/userInfo/user_info.dart';

final Map<String, WidgetBuilder> routes = {
  FavScreen.routeName: (context) => const FavScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  CategoryScreen.routeName: (context) => const CategoryScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  OrdersScreen.routeName: (context) => const OrdersScreen(),
  UserInfoScreen.routeName: (context) => const UserInfoScreen(),
  SearchScreen.routeName: (context) => const SearchScreen(),
};
