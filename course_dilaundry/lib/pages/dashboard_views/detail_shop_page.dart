import 'package:course_dilaundry/config/app_assets.dart';
import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/app_format.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/datasources/shop_datasource.dart';
import 'package:course_dilaundry/models/shop_model.dart';
import 'package:course_dilaundry/pages/dashboard_views/order_page.dart';
import 'package:course_dilaundry/pages/dashboard_views/shop_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DetailShopPage extends StatelessWidget {
  const DetailShopPage({super.key, required this.shop, required this.from});
  final ShopModel shop;
  final String from;

  launchWA(BuildContext context, String number) async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Chat via Whatsapp',
      'Yes, to confirm',
    );
    if (yes ?? false) {
      final link = WhatsAppUnilink(
        //phoneNumber : number,
        phoneNumber: '6289649878367',
        text: 'Hello, I want to order a laundry service',
      );
      if (await canLaunchUrl(link.asUri())) {
        launchUrl(
          link.asUri(),
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          headerImage(context),
          DView.height(10),
          groupItemInfo(context),
          DView.height(20),
          category(),
          DView.height(20),
          description(),
          DView.height(20),
          if (from == 'Front')
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  Nav.push(context, Orderpage(shop: shop));
                },
                child: const Text(
                  'Order',
                  style: TextStyle(
                      height: 1,
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     Nav.push(context, Orderpage(shop: shop));
                //   },
                //   child: const Text(
                //     'Update',
                //     style: TextStyle(
                //         height: 1,
                //         fontSize: 18,
                //         color: Colors.white70,
                //         fontWeight: FontWeight.bold),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete'),
                          content: const Text(
                              'Apakah anda ingin menghapus toko ini?'),
                          actions: [
                            Consumer(builder: (_, wiRef, __) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('TIDAK'),
                              );
                            }),
                            TextButton(
                              onPressed: () {
                                ShopDatasource.delete(shop.id).then((value) => {
                                      value.fold(
                                        (failure) {},
                                        (result) {
                                          Navigator.pop(context);
                                          Nav.push(context, const ShopPage());
                                          DInfo.toastSuccess(
                                              'Delete shop success');
                                        },
                                      )
                                    });
                              },
                              child: const Text('YA'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                        height: 1,
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          DView.height(20),
        ],
      ),
    );
  }

  Padding description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle('Description', color: Colors.black87),
          DView.height(8),
          Text(
            shop.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Padding category() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle('Jenis Cucian', color: Colors.black87),
          DView.height(8),
          Wrap(
            spacing: 8,
            children: [
              'Baju',
              'Selimut',
              'Sprei',
              'Boneka',
            ].map((e) {
              return Chip(
                visualDensity: const VisualDensity(vertical: -4),
                label: Text(e, style: const TextStyle(height: 1)),
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.primary),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Padding groupItemInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemInfo(
                  const Icon(
                    Icons.location_city_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  shop.city,
                ),
                DView.height(6),
                itemInfo(
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  shop.location,
                ),
                DView.height(6),
                GestureDetector(
                  onTap: () => launchWA(context, shop.whatsapp),
                  child: itemInfo(
                    Image.asset(
                      AppAssets.wa,
                      width: 20,
                    ),
                    shop.whatsapp,
                  ),
                ),
              ],
            ),
          ),
          DView.width(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormat.longPrice(shop.price_cuci_komplit),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  height: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text('/kg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemInfo(Widget icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 20,
          alignment: Alignment.bottomLeft,
          child: icon,
        ),
        Expanded(
            child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        )),
      ],
    );
  }

  Widget headerImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                '${AppConstants.baseImageURL}/shop/${shop.image}',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DView.height(8),
                      // Row(
                      //   children: [
                      //     // RatingBar.builder(
                      //     //   initialRating: shop.rate,
                      //     //   itemCount: 5,
                      //     //   allowHalfRating: true,
                      //     //   itemPadding: const EdgeInsets.all(0),
                      //     //   unratedColor: Colors.grey[300],
                      //     //   itemBuilder: (context, index) => const Icon(
                      //     //     Icons.star,
                      //     //     color: Colors.amber,
                      //     //   ),
                      //     //   itemSize: 12,
                      //     //   onRatingUpdate: (value) {},
                      //     //   ignoreGestures: true,
                      //     // ),
                      //     // DView.width(4),
                      //     Text(
                      //       '(${shop.rate})',
                      //       style: const TextStyle(
                      //         color: Colors.white70,
                      //         fontSize: 11,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      !shop.pickup && !shop.delivery
                          ? DView.nothing()
                          : Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  if (shop.pickup) childOrder('Pickup'),
                                  if (shop.delivery) DView.width(8),
                                  if (shop.delivery) childOrder('Delivery'),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 16,
              child: SizedBox(
                height: 36,
                child: FloatingActionButton.extended(
                  heroTag: 'fab-back-button',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  icon: const Icon(
                    Icons.navigate_before,
                    color: Colors.black87,
                  ),
                  extendedIconLabelSpacing: 0,
                  extendedPadding: const EdgeInsets.only(
                    left: 10,
                    right: 16,
                  ),
                  label: const Text(
                    'Back',
                    style: TextStyle(
                        height: 1,
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container childOrder(String name) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              height: 1,
            ),
          ),
          DView.width(4),
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 14,
          ),
        ],
      ),
    );
  }
}
