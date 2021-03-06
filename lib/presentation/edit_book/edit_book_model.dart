import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/book.dart';

final editBookProvider = ChangeNotifierProvider.family(
  (ref, Book book) => EditBookModel(book),
);

class EditBookModel extends ChangeNotifier {
  EditBookModel(this.book) {
    titleController.text = book.title;
    authorController.text = book.author;
  }
  final Book book;
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  String? title;
  String? author;

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }

  bool isUpdated() {
    return title != null || author != null;
  }

  Future addBook() async {
    title = titleController.text;
    author = authorController.text;
    await FirebaseFirestore.instance.collection('books').doc(book.id).update({
      'title': title,
      'author': author,
    });
    notifyListeners();
  }
}
