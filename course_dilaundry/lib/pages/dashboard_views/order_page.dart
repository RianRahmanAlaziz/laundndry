import 'package:course_dilaundry/config/app_session.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/datasources/laundry_datasource.dart';
import 'package:course_dilaundry/models/laundry_model.dart';
import 'package:course_dilaundry/models/shop_model.dart';
import 'package:course_dilaundry/models/user_model.dart';
import 'package:course_dilaundry/pages/dashboard_page.dart';
import 'package:course_dilaundry/pages/dashboard_views/my_laundry_view.dart';
import 'package:course_dilaundry/providers/dashboard_provider.dart';
import 'package:course_dilaundry/providers/my_laundry_provider.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Orderpage extends StatefulWidget {
  final ShopModel shop;

  const Orderpage({Key? key, required this.shop}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  State<Orderpage> createState() => _OrderpageState();
}

class _OrderpageState extends State<Orderpage> {
  late UserModel user;
  final List<OrderItem> _orderItems = [];
  double _totalPrice = 0.0;
  int _totalWeight = 0;

  void cetakPdf() async {
    final doc = pw.Document();
    // final image = await imageFromAssetBundle('assets/images/sobatcoding.png');
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now).toString();

    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(children: [
        pw.Text("Kingz Laundry"),
        pw.Text("Solusi cepat kering dan wangi"),
        pw.SizedBox(height: 15),
        pw.Column(children: [
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child: pw.Text("Nama Pelanggan",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(user.username,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child:
                    pw.Text("Alamat", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(user.address,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child: pw.Text("Tgl", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(formattedDate,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
        ]),
        pw.SizedBox(height: 15),
        pw.Column(children: [
          pw.Row(children: [
            pw.SizedBox(
                width: 150,
                child: pw.Text("Layanan",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 50,
                child:
                    pw.Text("Weight", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text("Price",
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text("Subtotal",
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.ListView.builder(
            itemCount: _orderItems.length,
            itemBuilder: (context, index) {
              return pw.Row(children: [
                pw.SizedBox(
                    width: 150,
                    child: pw.Text(_orderItems[index].itemName,
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 50,
                    child: pw.Text('${_orderItems[index].quantity}',
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 100,
                    child: pw.Text('Rp.${_orderItems[index].price}',
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 100,
                    child: pw.Text('Rp.${_orderItems[index].totalPrice}',
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(fontSize: 11))),
              ]);
            },
          ),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            pw.SizedBox(
                width: 300,
                child:
                    pw.Text("Total", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text('Rp.$_totalPrice',
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
          ])
        ]),
      ]); // Center
    }));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<void> generateInvoice() async {
    final doc = pw.Document();
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now).toString();

    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(children: [
        pw.Text("Kingz Laundry"),
        pw.Text("Solusi cepat kering dan wangi"),
        pw.SizedBox(height: 15),
        pw.Column(children: [
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child: pw.Text("Nama Pelanggan",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(user.username,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child:
                    pw.Text("Alamat", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(user.address,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child: pw.Text("Tgl", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(formattedDate,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
        ]),
        pw.SizedBox(height: 15),
        pw.Column(children: [
          pw.Row(children: [
            pw.SizedBox(
                width: 150,
                child: pw.Text("Layanan",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 50,
                child:
                    pw.Text("Weight", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text("Price",
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text("Subtotal",
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.ListView.builder(
            itemCount: _orderItems.length,
            itemBuilder: (context, index) {
              return pw.Row(children: [
                pw.SizedBox(
                    width: 150,
                    child: pw.Text(_orderItems[index].itemName,
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 50,
                    child: pw.Text('${_orderItems[index].quantity}',
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 100,
                    child: pw.Text('Rp.${_orderItems[index].price}',
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 100,
                    child: pw.Text('Rp.${_orderItems[index].totalPrice}',
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(fontSize: 11))),
              ]);
            },
          ),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            pw.SizedBox(
                width: 300,
                child:
                    pw.Text("Total", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text('Rp.$_totalPrice',
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
          ])
        ]),
      ]); // Center
    }));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  void displayPdf() {
    final doc = pw.Document();

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now).toString();

    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(children: [
        pw.Text("Kingz Laundry"),
        pw.Text("Solusi cepat kering dan wangi"),
        pw.SizedBox(height: 15),
        pw.Column(children: [
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child: pw.Text("Nama Pelanggan",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(user.username,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child:
                    pw.Text("Alamat", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(user.address,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.Row(children: [
            pw.SizedBox(
                width: 80,
                child: pw.Text("Tgl", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 5,
                child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                child: pw.Text(formattedDate,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
        ]),
        pw.SizedBox(height: 15),
        pw.Column(children: [
          pw.Row(children: [
            pw.SizedBox(
                width: 150,
                child: pw.Text("Layanan",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 50,
                child:
                    pw.Text("Weight", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text("Price",
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text("Subtotal",
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.ListView.builder(
            itemCount: _orderItems.length,
            itemBuilder: (context, index) {
              return pw.Row(children: [
                pw.SizedBox(
                    width: 150,
                    child: pw.Text(_orderItems[index].itemName,
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 50,
                    child: pw.Text('${_orderItems[index].quantity}',
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 100,
                    child: pw.Text('Rp.${_orderItems[index].price}',
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(fontSize: 11))),
                pw.SizedBox(
                    width: 100,
                    child: pw.Text('Rp.${_orderItems[index].totalPrice}',
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(fontSize: 11))),
              ]);
            },
          ),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            pw.SizedBox(
                width: 300,
                child:
                    pw.Text("Total", style: const pw.TextStyle(fontSize: 11))),
            pw.SizedBox(
                width: 100,
                child: pw.Text('Rp.$_totalPrice',
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(fontSize: 11))),
          ])
        ]),
      ]); // Center
    }));

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(doc: doc),
        ));
  }

  void generatePdf() async {
    const title = 'Test PDF';
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, title));
  }

  void printExistedPdf() async {
    final pdf = await rootBundle.load('assets/files/test.pdf');
    await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  void initState() {
    AppSession.getUser().then((value) {
      user = value!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Pesanan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Warna teks Daftar Pesanan
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _orderItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(_orderItems[index].itemName),
                      subtitle: Text('Kg: ${_orderItems[index].quantity}'),
                      trailing: Text(
                          '\Rp.${_orderItems[index].totalPrice.toStringAsFixed(0)}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Price: \Rp.$_totalPrice',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Warna teks Total
              ),
            ),
            Text(
              'Total Weight: $_totalWeight',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Warna teks Total
              ),
            ),
            const SizedBox(height: 16),
            if (_orderItems.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  LaundryDatasource.create(
                          user.id,
                          widget.shop.id,
                          double.parse(_totalWeight.toString()),
                          _totalPrice,
                          widget.shop.location,
                          user.address,
                          '')
                      .then((value) => {
                            value.fold(
                              (failure) {},
                              (result) {
                                _completeOrder();
                              },
                            )
                          });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green, // Warna tombol Selesaikan Pesanan
                ),
                child: const Text(
                  'Selesaikan Pesanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLaundryOptions();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLaundryOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LaundryOptionButton(
                optionName: 'Cuci Komplit',
                onPressed: () {
                  _showDialogKg('Cuci Komplit', widget.shop.price_cuci_komplit);
                },
              ),
              LaundryOptionButton(
                optionName: 'Dry Clean',
                onPressed: () {
                  _showDialogKg('Dry Clean', widget.shop.price_dry_clean!);
                },
              ),
              LaundryOptionButton(
                optionName: 'Cuci Satuan',
                onPressed: () {
                  _showDialogKg('Cuci Satuan', widget.shop.price_cuci_satuan!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addItemToOrder(String itemName, double price, int quantity) {
    setState(() {
      OrderItem newItem = OrderItem(
        itemName: itemName,
        price: price,
        quantity: quantity,
      );
      _orderItems.add(newItem);
      _totalPrice += newItem.totalPrice;
      _totalWeight += newItem.quantity;
    });
    Navigator.pop(context);
  }

  void _showDialogKg(String itemName, double price) {
    final kg = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Form(
            key: formKey,
            child: SimpleDialog(
              titlePadding: const EdgeInsets.all(16),
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: const Text('Weight'),
              children: [
                DInput(
                  controller: kg,
                  title: 'Kg',
                  radius: BorderRadius.circular(10),
                  inputType: TextInputType.number,
                  autofocus: true,
                ),
                DView.height(20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      _addItemToOrder(itemName, price, int.parse(kg.text));
                    }
                  },
                  child: const Text(
                    'Tambah',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ));
      },
    );
  }

  void _completeOrder() {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Consumer(builder: (_, wiRef, __) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pesanan Selesai",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Warna teks Total
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                LaundryOptionButton(
                  onPressed: () {
                    cetakPdf();
                  },
                  optionName: "Buat & Cetak PDF",
                ),
                const SizedBox(height: 15),
                LaundryOptionButton(
                  onPressed: () {
                    generateInvoice();
                  },
                  optionName: "Cetak",
                ),
                const SizedBox(height: 15),
                LaundryOptionButton(
                  onPressed: () {
                    displayPdf();
                  },
                  optionName: "Display PDF",
                ),
                const SizedBox(height: 15),
                LaundryOptionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    launchUrl(
                        Uri.parse("https://wa.me/${widget.shop.whatsapp}"));
                  },
                  optionName: "Hubungi Toko",
                ),
                const SizedBox(height: 15),
                LaundryOptionButton(
                  onPressed: () {
                    _resetOrder();
                    wiRef.read(dashboardNavIndexProvider.notifier).state = 1;

                    Nav.replace(context, const DashboardPage());
                  },
                  optionName: "Selesai",
                ),
              ],
            ),
          );
        });
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Pesanan Selesai'),
    //       content: const Text('Terima kasih atas pesanan Anda!'),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             showDialog(
    //               context: context,
    //               builder: (BuildContext context) {
    //                 return AlertDialog(
    //                   title: const Text('WhatsApp'),
    //                   content: const Text(
    //                       'Apakah anda ingin menghubungi toko lewat WhatsApp?'),
    //                   actions: [
    //                     Consumer(builder: (_, wiRef, __) {
    //                       return TextButton(
    //                         onPressed: () {
    //                           // int navIndex =
    //                           //     wiRef.watch(dashboardNavIndexProvider);

    //                           wiRef
    //                               .read(dashboardNavIndexProvider.notifier)
    //                               .state = 1;

    //                           Nav.replace(context, const DashboardPage());
    //                         },
    //                         child: const Text('TIDAK'),
    //                       );
    //                     }),
    //                     TextButton(
    //                       onPressed: () {
    //                         Navigator.of(context).pop();
    //                         launchUrl(Uri.parse(
    //                             "https://wa.me/${widget.shop.whatsapp}"));
    //                       },
    //                       child: const Text('YA'),
    //                     ),
    //                   ],
    //                 );
    //               },
    //             );
    //           },
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void _resetOrder() {
    setState(() {
      _orderItems.clear();
      _totalPrice = 0.0;
    });
  }
}

class LaundryOptionButton extends StatelessWidget {
  final String optionName;
  final VoidCallback onPressed;

  const LaundryOptionButton({
    super.key,
    required this.optionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          optionName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class OrderItem {
  final String itemName;
  final double price;
  final int quantity;

  OrderItem({
    required this.itemName,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;
}

// void main() {
//   runApp(const MaterialApp(
//     home: Orderpage(wid),
//   ));
// }

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}
