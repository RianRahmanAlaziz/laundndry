import 'package:course_dilaundry/models/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Orderpage extends StatefulWidget {
  final ShopModel shop;

  const Orderpage({Key? key, required this.shop}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrderpageState createState() => _OrderpageState();
}

class _OrderpageState extends State<Orderpage> {
  final List<OrderItem> _orderItems = [];
  double _totalPrice = 0.0;

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
                      subtitle:
                          Text('Quantity: ${_orderItems[index].quantity}'),
                      trailing: Text(
                          '\Rp.${_orderItems[index].totalPrice.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total: \Rp.$_totalPrice',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Warna teks Total
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _completeOrder();
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
                  _addItemToOrder('Cuci Komplit', 20.0, 1);
                  Navigator.pop(context);
                },
              ),
              LaundryOptionButton(
                optionName: 'Dry Clean',
                onPressed: () {
                  _addItemToOrder('Dry Clean', 30.0, 1);
                  Navigator.pop(context);
                },
              ),
              LaundryOptionButton(
                optionName: 'Cuci Satuan',
                onPressed: () {
                  _addItemToOrder('Cuci Satuan', 15.0, 1);
                  Navigator.pop(context);
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
    });
  }

  void _completeOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pesanan Selesai'),
          content: const Text('Terima kasih atas pesanan Anda!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetOrder();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('WhatsApp'),
                      content: const Text(
                          'Apakah anda ingin menghubungi toko lewat WhatsApp?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('TIDAK'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            launchUrl(Uri.parse(
                                "https://wa.me/${widget.shop.whatsapp}"));
                          },
                          child: const Text('YA'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
