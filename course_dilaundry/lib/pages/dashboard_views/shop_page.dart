import 'dart:io';

import 'package:course_dilaundry/config/app_assets.dart';
import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/failure.dart';
import 'package:course_dilaundry/datasources/shop_datasource.dart';
import 'package:course_dilaundry/models/shop_model.dart';
import 'package:course_dilaundry/providers/home_provider.dart';
import 'package:course_dilaundry/widgets/error_background.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  // late String username = '';
  // late String email = '';
  // late String role = '';
  // logout(context) {
  //   DInfo.dialogConfirmation(
  //     context,
  //     'Logout',
  //     'You sure want to logout?',
  //     textNo: 'Cancel',
  //   ).then((yes) {
  //     if (yes ?? false) {
  //       AppSession.removeUser();
  //       AppSession.removeBearerToken();
  //       Nav.replace(context, const LoginPage());
  //     }
  //   });
  // }
  bool isDelivery = false;
  late bool isPickup;
  File? _image;
  final picker = ImagePicker();

  getShop() {
    ShopDatasource.getAll().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setHomeShopStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setHomeShopStatus(ref, 'Kode Salah');
              break;
            case ForbiddenFailure:
              setHomeShopStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setHomeShopStatus(ref, 'Bad request');
              break;
            case UnauthorisedFailure:
              setHomeShopStatus(ref, 'Unauthorised');
              break;
            default:
              setHomeShopStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setHomeShopStatus(ref, 'Success');
          List data = result['data'];
          List<ShopModel> shops =
              data.map((e) => ShopModel.fromJson(e)).toList();
          ref.read(homeShopCategoryListProvider.notifier).setData(shops);
        },
      );
    });
  }

  void _changeState(bool? value) {
    setState(() {
      isDelivery = value!;
    });
  }

  void _dialogInput() {
    final name = TextEditingController();
    final location = TextEditingController();
    final city = TextEditingController();
    final whatsapp = TextEditingController();
    final category = TextEditingController();
    final description = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Form(
            key: formKey,
            child: SimpleDialog(
              titlePadding: const EdgeInsets.all(16),
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: const Text('Shop Input'),
              children: [
                DInput(
                  controller: name,
                  title: 'Name',
                  radius: BorderRadius.circular(10),
                  inputType: TextInputType.number,
                  autofocus: true,
                ),
                DView.height(20),
                DInput(
                  controller: location,
                  title: 'Location',
                  radius: BorderRadius.circular(10),
                  inputType: TextInputType.number,
                  autofocus: true,
                ),
                DView.height(20),
                DInput(
                  controller: city,
                  title: 'City',
                  radius: BorderRadius.circular(10),
                  inputType: TextInputType.number,
                  autofocus: true,
                ),
                DView.height(20),
                DInput(
                  controller: description,
                  title: 'Description',
                  radius: BorderRadius.circular(10),
                  inputType: TextInputType.number,
                  autofocus: true,
                ),
                DView.height(20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Tambah',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
                DView.height(8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  @override
  void initState() {
    _image = null;
    getShop();
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildImage() {
    if (_image == null) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Text(_image!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => {Navigator.pop(context)},
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        'Shop List',
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, 0),
                    child: OutlinedButton.icon(
                      onPressed: () => {_dialogInput()},
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Add',
                        style: TextStyle(height: 1),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        padding: const MaterialStatePropertyAll(
                          EdgeInsets.fromLTRB(8, 2, 16, 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ])),
        Expanded(
            child: RefreshIndicator(
                onRefresh: () async => getShop(),
                child: Consumer(builder: (_, wiRef, __) {
                  String statusList = wiRef.watch(homeShopStatusProvider);
                  String statusCategory = wiRef.watch(homeCategoryProvider);
                  List<ShopModel> listBackup =
                      wiRef.watch(homeShopCategoryListProvider);

                  if (statusList == '') return DView.loadingCircle();
                  if (statusList != 'Success') {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
                      child: ErrorBackground(
                        ratio: 16 / 9,
                        message: statusList,
                      ),
                    );
                  }

                  List<ShopModel> list = [];
                  if (statusCategory == 'All') {
                    list = List.from(listBackup);
                  } else {
                    list = listBackup
                        .where((element) =>
                            element.categories.contains(statusCategory))
                        .toList();
                  }

                  return Column(children: [
                    if (list.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: ErrorBackground(
                          ratio: 1.52,
                          message: 'No Shop',
                        ),
                      ),
                    if (list.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            ShopModel item = list[index];
                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, bottom: 30),
                                child:
                                    Stack(fit: StackFit.passthrough, children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          AppAssets.placeholderlaundry),
                                      image: NetworkImage(
                                        '${AppConstants.baseImageURL}/shop/${item.image}',
                                      ),
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    bottom: 8,
                                    right: 8,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: item.categories.map((e) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  right: 4),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                  height: 1,
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        DView.height(8),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: GoogleFonts.ptSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              DView.height(4),
                                              // Row(
                                              //   children: [
                                              //     RatingBar.builder(
                                              //       initialRating: item.rate,
                                              //       itemCount: 5,
                                              //       allowHalfRating: true,
                                              //       itemPadding:
                                              //           const EdgeInsets.all(0),
                                              //       unratedColor:
                                              //           Colors.grey[300],
                                              //       itemBuilder:
                                              //           (context, index) =>
                                              //               const Icon(
                                              //         Icons.star,
                                              //         color: Colors.amber,
                                              //       ),
                                              //       itemSize: 12,
                                              //       onRatingUpdate: (value) {},
                                              //       ignoreGestures: true,
                                              //     ),
                                              //     DView.width(4),
                                              //     Text(
                                              //       '(${item.rate})',
                                              //       style: const TextStyle(
                                              //         color: Colors.black87,
                                              //         fontSize: 11,
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              // DView.height(4),
                                              Text(
                                                item.location,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]));
                          },
                        ),
                      ),
                  ]);
                })))
      ],
    );
  }
}
