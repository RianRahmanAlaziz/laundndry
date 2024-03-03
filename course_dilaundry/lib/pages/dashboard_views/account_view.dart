import 'package:course_dilaundry/config/app_assets.dart';
import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_response.dart';
import 'package:course_dilaundry/config/app_session.dart';
import 'package:course_dilaundry/config/failure.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/datasources/user_datasource.dart';
import 'package:course_dilaundry/models/user_model.dart';
import 'package:course_dilaundry/pages/dashboard_views/shop_page.dart';
import 'package:course_dilaundry/pages/login_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';

import 'package:d_view/d_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {
  late String username = '';
  late String email = '';
  late String role = '';
  late String address = '';
  logout(context) {
    DInfo.dialogConfirmation(
      context,
      'Logout',
      'You sure want to logout?',
      textNo: 'Cancel',
    ).then((yes) {
      if (yes ?? false) {
        AppSession.removeUser();
        AppSession.removeBearerToken();
        Nav.replace(context, const LoginPage());
      }
    });
  }

  @override
  void initState() {
    username = "";
    email = "";
    role = "";
    AppSession.getUser().then((value) => {
          setState(() {
            username = value!.username;
            email = value.email;
            role = value.role;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
          child: Text(
            'Akun Saya',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      AppAssets.profile,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              DView.width(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DView.height(4),
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    DView.height(12),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DView.height(4),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DView.height(10),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          onTap: () {},
          dense: true,
          horizontalTitleGap: 20,
          leading: const Icon(Icons.image),
          title: const Text('Change Profile'),
          trailing: const Icon(Icons.navigate_next),
          iconColor: Colors.grey[600],
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          onTap: () {
            final edtusername = TextEditingController();
            final edtpassword = TextEditingController();
            final edtemail = TextEditingController();
            final address = TextEditingController();
            final formKey = GlobalKey<FormState>();

            edtusername.text = username;
            edtemail.text = email;

            showDialog(
              context: context,
              builder: (context) {
                return Form(
                  key: formKey,
                  child: SimpleDialog(
                    titlePadding: const EdgeInsets.all(16),
                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    title: const Text('Edit Account'),
                    children: [
                      DInput(
                        controller: edtusername,
                        title: 'Username',
                        radius: BorderRadius.circular(10),
                        validator: (input) =>
                            input == '' ? "Don't empty" : null,
                      ),
                      DView.height(10),
                      DInput(
                        controller: address,
                        title: 'Address',
                        radius: BorderRadius.circular(10),
                        validator: (input) =>
                            input == '' ? "Don't empty" : null,
                      ),
                      DView.height(10),
                      DInput(
                        controller: edtemail,
                        title: 'Email',
                        radius: BorderRadius.circular(10),
                        validator: (input) =>
                            input == '' ? "Don't empty" : null,
                      ),
                      DView.height(10),
                      DInputPassword(
                        controller: edtpassword,
                        title: 'Password',
                        radius: BorderRadius.circular(10),
                        validator: (input) =>
                            input == '' ? "Don't empty" : null,
                      ),
                      DView.height(20),
                      ElevatedButton(
                        onPressed: () {
                          UserDatasource.Uaccount(
                            edtusername.text,
                            edtemail.text,
                            edtpassword.text,
                            address.text,
                          ).then((value) {
                            String newStatus = '';
                            value.fold(
                              (failure) {
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
                              },
                              (result) {
                                AppSession.setUser(result['data']);
                                setState(() {
                                  username = result['data']['username'];
                                  email = result['data']['email'];
                                });
                                Navigator.pop(context);
                                DInfo.toastSuccess('Update Success');
                              },
                            );
                          });
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
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
                  ),
                );
              },
            );
          },
          dense: true,
          horizontalTitleGap: 20,
          leading: const Icon(Icons.edit),
          title: const Text('Edit Account'),
          trailing: const Icon(Icons.navigate_next),
          iconColor: Colors.grey[600],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: OutlinedButton(
            onPressed: () => logout(context),
            child: const Text('Logout'),
          ),
        ),
        DView.height(30),
        if (role == 'Admin') ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Administrator',
              style: TextStyle(
                height: 1,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          DView.height(10),
          // ListTile(
          //   onTap: () {},
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          //   dense: true,
          //   leading: const Icon(Icons.online_prediction_rounded),
          //   horizontalTitleGap: 20,
          //   title: const Text('Order'),
          //   trailing: const Icon(Icons.navigate_next),
          //   iconColor: Colors.grey[600],
          // ),
          ListTile(
            onTap: () {
              Nav.push(context, const ShopPage());
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            dense: true,
            leading: const Icon(Icons.store),
            horizontalTitleGap: 20,
            title: const Text('Shop'),
            trailing: const Icon(Icons.navigate_next),
            iconColor: Colors.grey[600],
          ),
          DView.height(30),
        ] else
          ...[],
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Settings',
            style: TextStyle(
              height: 1,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        // ListTile(
        //   onTap: () {},
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        //   dense: true,
        //   leading: const Icon(Icons.dark_mode),
        //   horizontalTitleGap: 20,
        //   title: const Text('Dark Mode'),
        //   iconColor: Colors.grey[600],
        //   trailing: Switch(
        //     activeColor: AppColors.primary,
        //     value: false,
        //     onChanged: (value) {},
        //   ),
        // ),
        // ListTile(
        //   onTap: () {},
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        //   dense: true,
        //   leading: const Icon(Icons.translate),
        //   horizontalTitleGap: 20,
        //   title: const Text('Language'),
        //   trailing: const Icon(Icons.navigate_next),
        //   iconColor: Colors.grey[600],
        // ),
        ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          dense: true,
          leading: const Icon(Icons.notifications),
          horizontalTitleGap: 20,
          title: const Text('Notification'),
          trailing: const Icon(Icons.navigate_next),
          iconColor: Colors.grey[600],
        ),
        // ListTile(
        //   onTap: () {},
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        //   dense: true,
        //   leading: const Icon(Icons.feedback),
        //   horizontalTitleGap: 20,
        //   title: const Text('Feedback'),
        //   trailing: const Icon(Icons.navigate_next),
        //   iconColor: Colors.grey[600],
        // ),
        // ListTile(
        //   onTap: () {},
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        //   dense: true,
        //   leading: const Icon(Icons.support_agent),
        //   horizontalTitleGap: 20,
        //   title: const Text('Support'),
        //   trailing: const Icon(Icons.navigate_next),
        //   iconColor: Colors.grey[600],
        // ),
        ListTile(
          onTap: () {
            showAboutDialog(
              context: context,
              applicationIcon: const Icon(
                Icons.local_laundry_service,
                size: 50,
                color: AppColors.primary,
              ),
              applicationName: 'Di Laundry',
              applicationVersion: 'v1.0.8',
              children: [
                const Text(
                  'Laundry Market App to Monitor you laundry status',
                ),
              ],
            );
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          dense: true,
          leading: const Icon(Icons.info),
          horizontalTitleGap: 20,
          title: const Text('About'),
          trailing: const Icon(Icons.navigate_next),
          iconColor: Colors.grey[600],
        ),
      ],
    );
  }
}
