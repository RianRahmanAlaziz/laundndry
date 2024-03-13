import 'dart:io';

import 'package:course_dilaundry/config/app_assets.dart';
import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/app_response.dart';
import 'package:course_dilaundry/config/failure.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/datasources/shop_datasource.dart';
import 'package:course_dilaundry/datasources/user_datasource.dart';
import 'package:course_dilaundry/models/shop_model.dart';
import 'package:course_dilaundry/models/user_model.dart';
import 'package:course_dilaundry/pages/dashboard_views/detail_shop_page.dart';
import 'package:course_dilaundry/pages/dashboard_views/detail_user_page.dart';
import 'package:course_dilaundry/providers/home_provider.dart';
import 'package:course_dilaundry/providers/user_provider.dart';
import 'package:course_dilaundry/widgets/error_background.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
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

  final picker = ImagePicker();

  getUser() {
    UserDatasource.getAll().then((value) {
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

  void _dialogInput() {
    final name = TextEditingController();
    final email = TextEditingController();
    final address = TextEditingController();
    final password = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Consumer(builder: (_, wiRef, __) {
          return Form(
              key: formKey,
              child: SimpleDialog(
                titlePadding: const EdgeInsets.all(16),
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: const Text('Shop Input'),
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
                          ? null
                          : wiRef.watch(dropdownRole),
                      isExpanded:
                          true, // Set isExpanded to true to make the button take up full width
                      onChanged: (String? newValue) {
                        setDropdownRole(ref, newValue!);
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
                    validator: (input) => input == '' ? "Don't empty" : null,
                  ),
                  DView.height(20),
                  ElevatedButton(
                    onPressed: () {
                      UserDatasource.create(
                              name.text,
                              email.text,
                              password.text,
                              address.text,
                              wiRef.watch(dropdownRole))
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
                          getUser();
                          Navigator.pop(context);
                          DInfo.toastSuccess('Add User success');
                        });
                      });
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
        });
      },
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
                        'User List',
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
                onRefresh: () async => getUser(),
                child: Consumer(builder: (_, wiRef, __) {
                  String statusList = wiRef.watch(userListStatusProvider);
                  List<UserModel> listBackup = wiRef.watch(userListProvider);

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

                  List<UserModel> list = [];
                  list = List.from(listBackup);

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
                            UserModel user = list[index];
                            return InkWell(
                                onTap: () {
                                  Nav.push(
                                      context,
                                      DetailUserPage(
                                        originUser: user,
                                      ));
                                },
                                child: Card(
                                  margin: EdgeInsets.all(10.0),
                                  child: ListTile(
                                    title: Text(user.username),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(user.email),
                                          ],
                                        ),
                                        Text('Role: ${user.role}'),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
                  ]);
                })))
      ],
    ));
  }
}
