import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';
import 'categories.dart';
import '../../../utils/constants.dart';
import '../../../models/category.dart';
import 'package:provider/provider.dart';
import '../../../view_models/global_vars_view_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'search_bar.dart';
import 'home_shimmer.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Future _futureProds;
  Future _futureHomeImages;
  bool _connection;

  @override
  void initState() {
    _futureProds = Provider.of<GlobalVars>(context, listen: false).getAllProds();
    _futureHomeImages = Provider.of<GlobalVars>(context, listen: false).getHomeImages();
    super.initState();
  }

  Future connection_checker() async {
    _connection = await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: connection_checker(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_connection == true) {
                    return Consumer<GlobalVars>(builder: (_, gv, __) {
                      return FutureBuilder(
                          future: Future.wait([_futureProds, _futureHomeImages]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Column(
                                children: [
                                  SizedBox(height: getProportionateScreenHeight(15)),
                                  const SearchBar(),
                                  SizedBox(height: getProportionateScreenWidth(5)),
                                  const Categories(),
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      viewportFraction: 0.9,
                                      autoPlay: true,
                                      aspectRatio: 1.7,
                                      enlargeCenterPage: true,
                                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                                    ),
                                    items: gv.imgList
                                        .map((item) => Container(
                                              margin: const EdgeInsets.all(7.5),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(10))),
                                                child: CachedNetworkImage(
                                                    imageUrl: item,
                                                    progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                                                          width: getProportionateScreenWidth(6),
                                                          height: getProportionateScreenWidth(6),
                                                          child: Center(
                                                            child: CircularProgressIndicator(
                                                              value: downloadProgress.progress,
                                                              strokeWidth: 5,
                                                              color: PrimaryLightColor,
                                                              backgroundColor: CardBackgroundColor,
                                                            ),
                                                          ),
                                                        ),
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    placeholderFadeInDuration: Duration.zero,
                                                    width: double.infinity),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  Column(
                                    children: List.generate(gv.categories.length, (index) => Category(cat: gv.categories[index])),
                                  ),
                                  SizedBox(height: getProportionateScreenWidth(30))
                                ],
                              );
                            } else {
                              return const HomeShimmer();
                            }
                          });
                    });
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: SecondaryColor,
                            size: 23,
                          ),
                          Text(
                            '   No Internet Connection',
                            style: TextStyle(fontSize: 16, color: SecondaryColor, fontFamily: 'PantonBoldItalic'),
                          ),
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        IconButton(
                          onPressed: () => setState(() {}),
                          icon: const Icon(
                            Icons.replay_circle_filled,
                            color: PrimaryColor,
                          ),
                          iconSize: 53,
                        )
                      ],
                    );
                  }
                } else {
                  return const HomeShimmer();
                }
              }),
        ),
      ),
    );
  }
}
