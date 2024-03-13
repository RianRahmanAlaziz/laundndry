import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_response.dart';
import 'package:course_dilaundry/config/failure.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/datasources/shop_datasource.dart';
import 'package:course_dilaundry/datasources/user_datasource.dart';
import 'package:course_dilaundry/models/user_model.dart';
import 'package:course_dilaundry/pages/dashboard_views/user_page.dart';
import 'package:course_dilaundry/providers/user_provider.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailUserPage extends ConsumerStatefulWidget {
  DetailUserPage({super.key, required this.originUser});

  late UserModel originUser;

  @override
  ConsumerState<DetailUserPage> createState() => _DetailUserPage();
}

class _DetailUserPage extends ConsumerState<DetailUserPage> {
  late UserModel user;
  late String role = '';

  getUser() {
    ShopDatasource.getAll().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setUserListStatusProvider(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setUserListStatusProvider(ref, 'Kode Salah');
              break;
            case ForbiddenFailure:
              setUserListStatusProvider(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setUserListStatusProvider(ref, 'Bad request');
              break;
            case UnauthorisedFailure:
              setUserListStatusProvider(ref, 'Unauthorised');
              break;
            default:
              setUserListStatusProvider(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setUserListStatusProvider(ref, 'Success');
          List data = result['data'];
          List<UserModel> users =
              data.map((e) => UserModel.fromJson(e)).toList();
          ref.read(userListProvider.notifier).setData(users);
        },
      );
    });
  }

  void dialogUpdate() {
    final name = TextEditingController();
    final email = TextEditingController();
    final address = TextEditingController();
    final password = TextEditingController();

    final formKey = GlobalKey<FormState>();

    name.text = user.username;
    email.text = user.email;
    address.text = user.address;

    setDropdownRole(ref, user.role);

    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (_, wiRef, __) {
            return Form(
                key: formKey,
                child: SimpleDialog(
                  titlePadding: const EdgeInsets.all(16),
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  title: const Text('Shop Update'),
                  children: [
                    DInput(
                      controller: name,
                      title: 'Username',
                      validator: (input) => input == '' ? "Don't empty" : null,
                      radius: BorderRadius.circular(10),
                      autofocus: true,
                    ),
                    DView.height(20),
                    DInput(
                      controller: email,
                      title: 'Email',
                      validator: (input) => input == '' ? "Don't empty" : null,
                      radius: BorderRadius.circular(10),
                    ),
                    DView.height(20),
                    DInput(
                      controller: address,
                      title: 'Address',
                      validator: (input) => input == '' ? "Don't empty" : null,
                      radius: BorderRadius.circular(10),
                    ),
                    DView.height(20),
                    DropdownButton<String>(
                        hint: const Text("Role"),
                        value: wiRef.watch(dropdownRole) == ''
                            ? user.role
                            : wiRef.watch(dropdownRole),
                        isExpanded:
                            true, // Set isExpanded to true to make the button take up full width
                        onChanged: (String? newValue) {
                          setState(() {
                            user.role = newValue!;
                            setDropdownRole(ref, newValue);
                          });
                        },
                        items: <String>['Admin', 'Kurir', 'User']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()),
                    DView.height(20),
                    DInputPassword(
                      controller: password,
                      title: 'Password',
                      radius: BorderRadius.circular(10),
                    ),
                    DView.height(20),
                    ElevatedButton(
                      onPressed: () {
                        UserDatasource.update(
                                user.id,
                                name.text,
                                email.text,
                                password.text,
                                address.text,
                                wiRef.watch(dropdownRole) == ''
                                    ? user.role
                                    : wiRef.watch(dropdownRole))
                            .then((value) {
                          String newStatus = '';
                          value.fold((failure) {
                            switch (failure.runtimeType) {
                              case ServerFailure:
                                newStatus = 'Server Error';
                                DInfo.toastError(newStatus);
                                break;
                              case NotFoundFailure:
                                newStatus = 'Error Not Found';
                                DInfo.toastError(newStatus);
                                break;
                              case ForbiddenFailure:
                                newStatus = 'You don\'t have acces';
                                DInfo.toastError(newStatus);
                                break;
                              case BadRequestFailure:
                                newStatus = 'Bad request';
                                DInfo.toastError(newStatus);
                                break;
                              case InvalidInputFailure:
                                newStatus = 'Invalid Input';
                                AppResponse.invalidInput(
                                    context, failure.message ?? '{}');
                                break;
                              case UnauthorisedFailure:
                                newStatus = 'Unauthorised';
                                DInfo.toastError(newStatus);
                                break;
                              default:
                                newStatus = 'Request Error';
                                DInfo.toastError(newStatus);
                                newStatus = failure.message ?? '-';
                                break;
                            }
                          }, (result) {
                            setState(() {
                              user = UserModel.fromJson(result['data']);
                            });
                            getUser();
                            Navigator.pop(context);
                            DInfo.toastSuccess('Update User success');
                          });
                        });
                      },
                      child: const Text(
                        'Update',
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
          });
        });
  }

  @override
  void initState() {
    user = widget.originUser;

    role = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
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
                          user.username,
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ])),
          DView.height(20),
          groupItemInfo(context),
          DView.height(20),
          // category(),
          // DView.height(20),
          // description(),
          // DView.height(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  dialogUpdate();
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                      height: 1,
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete'),
                        content:
                            const Text('Apakah anda ingin menghapus user ini?'),
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
                              UserDatasource.delete(user.id).then((value) => {
                                    value.fold(
                                      (failure) {},
                                      (result) {
                                        DInfo.toastSuccess(
                                            'Delete user success');
                                        Navigator.pop(context);
                                        Nav.push(context, const UserPage());
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
          const Text(
            "shop.description",
            style: TextStyle(
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
                    Icons.email,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  user.email,
                ),
                DView.height(6),
                itemInfo(
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  user.address,
                ),
                DView.height(6),
                itemInfo(
                  const Icon(
                    Icons.privacy_tip_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  user.role,
                ),
              ],
            ),
          ),
          // DView.width(),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Text(
          //       AppFormat.longPrice(100000),
          //       textAlign: TextAlign.right,
          //       style: const TextStyle(
          //         height: 1,
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //         color: AppColors.primary,
          //       ),
          //     ),
          //     const Text('/kg'),
          //   ],
          // ),
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

  // Widget headerImage(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Stack(
  //       children: [
  //         // ClipRRect(
  //         //   borderRadius: BorderRadius.circular(30),
  //         //   child: Image.network(
  //         //     '${AppConstants.baseImageURL}/shop/${shop.image}',
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         // ),
  //         // Align(
  //         //   alignment: Alignment.bottomCenter,
  //         //   child: AspectRatio(
  //         //     aspectRatio: 2,
  //         //     child: Container(
  //         //       decoration: BoxDecoration(
  //         //         borderRadius: BorderRadius.circular(10),
  //         //         gradient: const LinearGradient(
  //         //           colors: [
  //         //             Colors.black,
  //         //             Colors.transparent,
  //         //           ],
  //         //           begin: Alignment.bottomCenter,
  //         //           end: Alignment.topCenter,
  //         //         ),
  //         //       ),
  //         //       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  //         //       child: Column(
  //         //         mainAxisAlignment: MainAxisAlignment.end,
  //         //         crossAxisAlignment: CrossAxisAlignment.start,
  //         //         children: [
  //         //           Text(
  //         //             "shop.name",
  //         //             style: const TextStyle(
  //         //               color: Colors.white,
  //         //               fontSize: 24,
  //         //               fontWeight: FontWeight.bold,
  //         //             ),
  //         //           ),
  //         //           DView.height(8),
  //         //           // Row(
  //         //           //   children: [
  //         //           //     // RatingBar.builder(
  //         //           //     //   initialRating: shop.rate,
  //         //           //     //   itemCount: 5,
  //         //           //     //   allowHalfRating: true,
  //         //           //     //   itemPadding: const EdgeInsets.all(0),
  //         //           //     //   unratedColor: Colors.grey[300],
  //         //           //     //   itemBuilder: (context, index) => const Icon(
  //         //           //     //     Icons.star,
  //         //           //     //     color: Colors.amber,
  //         //           //     //   ),
  //         //           //     //   itemSize: 12,
  //         //           //     //   onRatingUpdate: (value) {},
  //         //           //     //   ignoreGestures: true,
  //         //           //     // ),
  //         //           //     // DView.width(4),
  //         //           //     Text(
  //         //           //       '(${shop.rate})',
  //         //           //       style: const TextStyle(
  //         //           //         color: Colors.white70,
  //         //           //         fontSize: 11,
  //         //           //       ),
  //         //           //     ),
  //         //           //   ],
  //         //           // ),
  //         //           // !shop.pickup && !shop.delivery
  //         //           //     ? DView.nothing()
  //         //           //     : Padding(
  //         //           //         padding: const EdgeInsets.only(top: 15),
  //         //           //         child: Row(
  //         //           //           children: [
  //         //           //             if (shop.pickup) childOrder('Pickup'),
  //         //           //             if (shop.delivery) DView.width(8),
  //         //           //             if (shop.delivery) childOrder('Delivery'),
  //         //           //           ],
  //         //           //         ),
  //         //           //       ),
  //         //         ],
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //         Positioned(
  //           top: 36,
  //           left: 16,
  //           child: SizedBox(
  //             height: 36,
  //             child: ,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
