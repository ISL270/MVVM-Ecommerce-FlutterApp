import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'components/body.dart';
import '../../../utils/size_config.dart';
import '../favourites/favs_screen.dart';
import '../../../views/cart/cart_screen.dart';
import '../../../views/profile/profile_screen.dart';
import '../../view_models/global_vars_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';

  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pageList = [];

  @override
  void initState() {
    _pageList.add(const HomeBody());
    _pageList.add(const FavScreen());
    _pageList.add(const CartScreen());
    _pageList.add(const ProfileScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<GlobalVars>(builder: (_, gv, __) {
      return Scaffold(
        body: IndexedStack(
          index: gv.selectedPage,
          children: _pageList,
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitledBottomNavigationBar(
              curve: Curves.easeInOutQuint,
              activeColor: PrimaryColor,
              reverse: true,
              items: [
                TitledNavigationBarItem(icon: Icons.home_outlined, title: const Text('Home', style: TextStyle(fontFamily: 'PantonBold'))),
                TitledNavigationBarItem(icon: Icons.favorite_border_outlined, title: Text('Favourites', style: TextStyle(fontSize: getProportionateScreenWidth(13), fontFamily: 'PantonBold'))),
                TitledNavigationBarItem(icon: Icons.shopping_cart_outlined, title: const Text('Cart', style: TextStyle(fontFamily: 'PantonBold'))),
                TitledNavigationBarItem(icon: Icons.person_outline_rounded, title: const Text('ProfIle', style: TextStyle(fontFamily: 'PantonBold'))),
              ],
              currentIndex: gv.selectedPage,
              onTap: (index) => _onItemTapped(gv, index),
            ),
            Container(
              color: Colors.white,
              height: Theme.of(context).platform == TargetPlatform.iOS ? getProportionateScreenWidth(16) : 0,
            )
          ],
        ),
      );
    });
  }

  void _onItemTapped(GlobalVars gv, int index) {
    setState(() {
      gv.selectedPage = index;
    });
  }
}
