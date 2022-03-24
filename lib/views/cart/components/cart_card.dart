import 'package:flutter/material.dart';
import '../../../view_models/global_vars_view_model.dart';
import '../../../models/cart_item.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartItem cart;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: CardBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.cart.product.images[0].toString(),
                memCacheHeight: 500,
                memCacheWidth: 500,
                maxHeightDiskCache: 500,
                maxWidthDiskCache: 500,
                progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                  width: getProportionateScreenWidth(4),
                  height: getProportionateScreenWidth(4),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      strokeWidth: 4,
                      color: PrimaryLightColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cart.product.title,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'PantonItalic'),
              ),
              Text(
                widget.cart.option1,
                style: const TextStyle(color: SecondaryColorDark, fontSize: 14, fontFamily: 'PantonBoldItalic'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.cart.product.price} EGP',
                    style: const TextStyle(color: PrimaryColor, fontSize: 16, fontFamily: 'PantonBoldItalic'),
                  ),
                  Consumer<GlobalVars>(builder: (_, gv, __) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () => gv.decrementQ(widget.cart.uid),
                          icon: const Icon(Icons.remove),
                          color: PrimaryColor,
                          enableFeedback: false,
                        ),
                        Text(
                          '${widget.cart.quantity}',
                          style: const TextStyle(fontFamily: 'PantonBoldItalic'),
                        ),
                        IconButton(
                          onPressed: () => gv.incrementQ(widget.cart.uid),
                          icon: const Icon(Icons.add),
                          color: PrimaryColor,
                          enableFeedback: false,
                        )
                      ],
                    );
                  }),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
