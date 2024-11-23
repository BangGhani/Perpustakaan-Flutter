import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'deleteData.dart';
import 'insert.dart';
import 'update.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> books = []; //Untuk menyimpan data buku

  @override
  void initState() {
    super.initState();
    fetchBooks(); //Memanggil fungsi fetch data buku
  }

  // Fungsi untuk mengambil data dari Supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('books').select();

    setState(() {
      books = List<Map<String, dynamic>>.from(response); //Menyimpan data buku
    });
  }

  // Tampilan utama halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Books List', //Judul halaman
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, //Judul dibuat center
        backgroundColor: Colors.purple[100], //Warna background Appbar
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), //Ikon Tombol refresh
            onPressed:
                fetchBooks, //Memanggil fungsi fetchBooks ketika tombpl ditekan
          ),
        ],
      ),
      body: books.isEmpty
          ? const Center(
              child: CircularProgressIndicator(), //Menampilkan loading
            )
          : ListView.builder(
              //Menampilkan daftar buku
              itemCount: books.length, //Jumlah data
              itemBuilder: (context, index) {
                final book = books[index]; //variable book berisi data buku
                return ListTile(
                  title: Text(
                    book['title'] ??
                        'Tidak Ada Judul', //field title pada database, jika tidak ada data, maka output Tidak ada judul
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['author'] ??
                            '-', //Field author pada database, jika data kosong, output -
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        book['description'] ?? '-', //Field description paa database. jika kosong maka output -
                        maxLines: 2, //maksimal baris teks adalah 2
                        overflow: TextOverflow.ellipsis, //Jika lebih dari 2 baris gantikan dengan tiga titik (...)
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors
                                .blue), //ikon tombol edit dengan warna biru
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book: book),
                            ),
                          ).then((_) {
                            fetchBooks();
                          });
                        },
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ), //Ikon tombol hapus dengan warna merah
                          onPressed: () {
                            //Menampilkan konfirmasi ke user sebelum menghapus data
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Book'),
                                    content: Text(
                                        'Are you sure want to delete this data?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //Tutup alert jika tombol cancel ditekan
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await deleteBook(book[
                                              'id']); //Hapus buku berdasarkan ID
                                          await fetchBooks(); //Panggil ulang fungsi fetch data setelah dihapus
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                });
                          })
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookPage(),
            ),
          );
        },
        backgroundColor: Colors.purple[100],
        child: const Icon(Icons.add), //Ikon tambah
      ),
    );
  }
}
