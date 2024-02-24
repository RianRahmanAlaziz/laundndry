import 'package:course_dilaundry/config/app_assets.dart';
import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/app_format.dart';
import 'package:course_dilaundry/config/app_session.dart';
import 'package:course_dilaundry/config/failure.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/datasources/laundry_datasource.dart';
import 'package:course_dilaundry/models/laundry_model.dart';
import 'package:course_dilaundry/models/user_model.dart';
import 'package:course_dilaundry/pages/dashboard_views/detail_shop_page.dart';
import 'package:course_dilaundry/providers/my_laundry_provider.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailLaundryPage extends ConsumerStatefulWidget {
  final LaundryModel laundry;

  const DetailLaundryPage({super.key, required this.laundry});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<DetailLaundryPage> createState() => _DetailLaundryPageState();
}

class _DetailLaundryPageState extends ConsumerState<DetailLaundryPage> {
  late UserModel user;
  late String role = '';

  getMyLaundry() {
    if (user.role == 'Admin') {
      LaundryDatasource.readAll().then((value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                setMyLaundryStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setMyLaundryStatus(ref, 'Kode Salah');
                break;
              case ForbiddenFailure:
                setMyLaundryStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setMyLaundryStatus(ref, 'Bad request');
                break;
              case UnauthorisedFailure:
                setMyLaundryStatus(ref, 'Unauthorised');
                break;
              default:
                setMyLaundryStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setMyLaundryStatus(ref, 'Success');
            List data = result['data'];
            List<LaundryModel> laundries =
                data.map((e) => LaundryModel.fromJson(e)).toList();
            ref.read(myLaundryListProvider.notifier).setData(laundries);
          },
        );
      });
    } else {
      LaundryDatasource.readByUser(user.id).then((value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                setMyLaundryStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setMyLaundryStatus(ref, 'Kode Salah');
                break;
              case ForbiddenFailure:
                setMyLaundryStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setMyLaundryStatus(ref, 'Bad request');
                break;
              case UnauthorisedFailure:
                setMyLaundryStatus(ref, 'Unauthorised');
                break;
              default:
                setMyLaundryStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setMyLaundryStatus(ref, 'Success');
            List data = result['data'];
            List<LaundryModel> laundries =
                data.map((e) => LaundryModel.fromJson(e)).toList();
            ref.read(myLaundryListProvider.notifier).setData(laundries);
          },
        );
      });
    }
  }

  @override
  void initState() {
    role = "";
    AppSession.getUser().then((value) {
      setState(() {
        user = value!;
        role = value.role;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          headerCover(context),
          DView.height(10),
          Center(
            child: Container(
              width: 90,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey,
              ),
            ),
          ),
          DView.height(),
          itemInfo(Icons.sell, AppFormat.longPrice(widget.laundry.total)),
          divider(),
          itemInfo(Icons.event, AppFormat.fullDate(widget.laundry.createdAt)),
          divider(),
          InkWell(
            onTap: () {
              Nav.push(context, DetailShopPage(shop: widget.laundry.shop));
            },
            child: itemInfo(Icons.store, widget.laundry.shop.name),
          ),
          divider(),
          itemInfo(Icons.shopping_basket, '${widget.laundry.weight} kg'),
          divider(),
          if (widget.laundry.withPickup) itemInfo(Icons.shopping_bag, 'Pickup'),
          if (widget.laundry.withPickup)
            itemDescription(widget.laundry.pickupAddress),
          if (widget.laundry.withPickup) divider(),
          if (widget.laundry.withDelivery)
            itemInfo(Icons.local_shipping, 'Delivery'),
          if (widget.laundry.withDelivery)
            itemDescription(widget.laundry.deliveryAddress),
          if (widget.laundry.withDelivery) divider(),
          itemInfo(Icons.description, 'Description'),
          itemDescription(widget.laundry.description ?? ''),
          divider(),
        ],
      ),
    );
  }

  Divider divider() {
    return Divider(
      indent: 30,
      endIndent: 30,
      color: Colors.grey[400],
    );
  }

  Widget itemInfo(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          DView.width(10),
          Text(info),
        ],
      ),
    );
  }

  Widget itemDescription(String? text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          const Icon(
            Icons.abc,
            color: Colors.transparent,
          ),
          DView.width(10),
          Expanded(
            child: Text(
              text ?? '',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Padding headerCover(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppAssets.emptyBG,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ]),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 30,
                    ),
                    child: role != 'Admin'
                        ? Text(
                            widget.laundry.status,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 40,
                              height: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : DropdownMenu<String>(
                            initialSelection: widget.laundry.status,
                            onSelected: (String? value) {
                              LaundryDatasource.updateStatus(
                                      widget.laundry.id!, value!)
                                  .then((value) => {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              titlePadding:
                                                  const EdgeInsets.all(16),
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 0, 16, 16),
                                              title: const Text('Weight'),
                                              children: [
                                                const Text(
                                                    "Laundry status successfully updated"),
                                                DView.height(20),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    getMyLaundry();
                                                  },
                                                  child: const Text(
                                                    'Ok',
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      });
                            },
                            dropdownMenuEntries: AppConstants
                                .laundryStatusCategory
                                .where((element) => element != 'All')
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList())
                    // child: Dropd,
                    ),
              ),
              Positioned(
                top: 36,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     Text(
                    //       'ID: ${laundry.id}',
                    //       style: const TextStyle(
                    //         fontSize: 18,
                    //         color: Colors.white,
                    //         height: 1,
                    //         fontWeight: FontWeight.bold,
                    //         shadows: [
                    //           Shadow(
                    //             blurRadius: 6,
                    //             color: Colors.black87,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    FloatingActionButton.small(
                      heroTag: 'fab-back',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
