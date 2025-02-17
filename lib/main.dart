import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'menu.dart'; // Import menu.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MidtransSDK? _midtrans;
  Map<Book, int> cart = {};
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  void initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "Mid-client-aQlOuFg-HjAYb283",
        merchantBaseUrl: "",
        colorTheme: ColorTheme(
          colorPrimary: Colors.blue,
          colorPrimaryDark: Colors.blueAccent,
          colorSecondary: Colors.lightBlue,
        ),
      ),
    );
    _midtrans?.setUIKitCustomSetting(skipCustomerDetailsPages: true);
    _midtrans!.setTransactionFinishedCallback((result) {
      print(result.toJson());
    });
  }

  void addToCart(Book book) {
    setState(() {
      cart.update(book, (quantity) => quantity + 1, ifAbsent: () => 1);
    });
  }

  void checkout() async {
    if (cart.isEmpty) return;
    
    String snapToken = "ISI_SNAP_TOKEN"; // Gantilah dengan token dari server
    
    _midtrans?.startPaymentUiFlow(token: snapToken);
    setState(() {
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Toko Buku'),
          actions: [
            Stack(
              children: [
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: checkout),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text('${cart.length}', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65,
          ),
          padding: EdgeInsets.all(10),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return BookCard(book: books[index], onAdd: addToCart, currencyFormat: currencyFormat);
          },
        ),
      ),
    );
  }
}
