import 'package:book_list_riverpod_sample_app/presentation/add_book/add_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../domain/book.dart';
import '../edit_book/edit_book_page.dart';
import 'book_list_model.dart';

class BookListPage extends ConsumerWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            if (book.books == null) {
              return const CircularProgressIndicator();
            }
            final List<Widget> widgets = book.books!
                .map(
                  (bookInfo) => Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditBookPage(bookInfo),
                              ),
                            );
                            book.fetchBookList();
                          },
                          icon: Icons.edit,
                          label: '編集',
                          backgroundColor: Colors.black54,
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            await showConfirmDialog(context, bookInfo, book);
                          },
                          icon: Icons.delete,
                          label: '削除',
                          backgroundColor: Colors.red,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: bookInfo.imgURL != null
                          ? Image.network(bookInfo.imgURL!)
                          : null,
                      title: Text(bookInfo.title),
                      subtitle: Text(bookInfo.author),
                    ),
                  ),
                )
                .toList();
            return ListView(
              children: widgets,
            );
          },
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddBookPage(),
                  fullscreenDialog: true,
                ),
              );
              book.fetchBookList();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  Future showConfirmDialog(
      BuildContext context, Book bookInfo, BookListModel book) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('消すのか？'),
          content: const Text('本当にいいのか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(_);
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                book.delete(bookInfo);
                book.fetchBookList();
                Navigator.pop(_);
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
