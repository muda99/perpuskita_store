import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class BookCard extends StatelessWidget {
  final Book book;
  final Function(Book) onAdd;
  final NumberFormat currencyFormat;

  BookCard({required this.book, required this.onAdd, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                book.image,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 100, color: Colors.grey);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(currencyFormat.format(book.price), style: TextStyle(color: Colors.blue)),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () => onAdd(book),
                  child: Text('Tambah'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
