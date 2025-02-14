import 'package:flutter/material.dart';



class BookStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Buku',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BookListScreen(),
    );
  }
}

class Book {
  final String title;
  final String author;
  final double price;
  final String image;

  Book({required this.title, required this.author, required this.price, required this.image});
}

List<Book> books = [
  Book(title: 'Flutter for Beginners', author: 'John Doe', price: 120000, image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Gambar_Buku.png/640px-Gambar_Buku.png'),
  Book(title: 'Dart Programming', author: 'Jane Doe', price: 95000, image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Gambar_Buku.png/640px-Gambar_Buku.png'),
];

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> cart = [];

  void addToCart(Book book) {
    setState(() {
      cart.add(book);
    });
  }

  void goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartScreen(cart: cart, onRemove: removeFromCart)),
    );
  }

  void removeFromCart(Book book) {
    setState(() {
      cart.remove(book);
    });
  }

  void goToDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toko Buku'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: goToCart,
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        padding: EdgeInsets.all(10),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => goToDetail(books[index]),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(books[index].image, fit: BoxFit.cover, width: double.infinity),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(books[index].title, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${books[index].price} IDR', style: TextStyle(color: Colors.blue)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => addToCart(books[index]),
                      child: Text('Tambah'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookDetailScreen extends StatelessWidget {
  final Book book;
  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Buku')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(book.image, height: 200),
            ),
            SizedBox(height: 16),
            Text(book.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Penulis: ${book.author}', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            SizedBox(height: 8),
            Text('${book.price} IDR', style: TextStyle(fontSize: 20, color: Colors.blue)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Beli'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Book> cart;
  final Function(Book) onRemove;
  CartScreen({required this.cart, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, book) => sum + book.price);
    return Scaffold(
      appBar: AppBar(title: Text('Keranjang')),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(cart[index].image),
            title: Text(cart[index].title),
            subtitle: Text('${cart[index].price} IDR'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => onRemove(cart[index]),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Total: ${total.toStringAsFixed(0)} IDR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}