import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>(); //Membuat key untuk form agar bisa divalidasi
  final TextEditingController _titleController = TextEditingController(); //Kontroler untuk input title
  final TextEditingController _authorController = TextEditingController(); //Kontroler untuk input author
  final TextEditingController _descriptionController = TextEditingController(); //Kontroler untuk input description

  bool _isLoading = false; //Indikator loading untuk menampilkan progress saat data sedang diproses

  //Fungsi untuk menambahkan buku ke database
  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) { //Cek apakah semua field valid
      return;
    }

    setState(() {
      _isLoading = true; //Set loading menjadi true ketika tombol ditekan
    });

    final title = _titleController.text; //Ambil nilai dari field title
    final author = _authorController.text; //Ambil nilai dari field author
    final description = _descriptionController.text; //Ambil nilai dari field description

    //Kirim data buku ke Supabase untuk ditambahkan ke database
    final response = await Supabase.instance.client.from('books').insert({
      'title': title,
      'author': author,
      'description': description
    }).select();

    setState(() {
      _isLoading = false; //Set loading menjadi false setelah proses selesai
    });

    if (response != null && response.isNotEmpty) { //Cek jika data berhasil ditambahkan
      ScaffoldMessenger.of(context).showSnackBar( //Tampilkan pesan sukses
        const SnackBar(content: Text('Book added successfully!')),
      );
      _titleController.clear(); //Kosongkan field title
      _authorController.clear(); //Kosongkan field author
      _descriptionController.clear(); //Kosongkan field description

      //Navigasi kembali ke halaman BookListPage setelah berhasil menambahkan
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BookListPage()));
    } else {
      //Jika respons gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding book. Please try again!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'), //Judul halaman
        centerTitle: true, //Pusatkan judul halaman
      ),
      body: Container(
        padding: const EdgeInsets.all(15), //Tambahkan padding pada body
        child: Form(
          key: _formKey, //Gunakan form key untuk validasi input
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //Atur elemen kolom untuk rata kiri
            children: [
              //Input untuk judul buku
              TextFormField(
                controller: _titleController, //Controller untuk judul buku
                decoration: const InputDecoration(
                  labelText: 'Title', //Teks label untuk input title
                  border: UnderlineInputBorder(), //Buat border bawah pada input
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) { //Cek jika field kosong
                    return 'Please enter the title'; //Pesan error jika kosong
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15), //Space antara elemen input
              //Input untuk penulis buku
              TextFormField(
                controller: _authorController, //Controller untuk author buku
                decoration: const InputDecoration(
                  labelText: 'Author', //Teks label untuk input author
                  border: UnderlineInputBorder(), //Buat border bawah pada input
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) { //Cek jika field kosong
                    return 'Please enter the author'; //Pesan error jika kosong
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15), //Space antara elemen input
              //Input untuk deskripsi buku
              TextFormField(
                controller: _descriptionController, //Controller untuk description buku
                decoration: const InputDecoration(
                  labelText: 'Description', //Teks label untuk input description
                  border: UnderlineInputBorder(), //Buat border bawah pada input
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) { //Cek jika field kosong
                    return 'Please enter the description'; //Pesan error jika kosong
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40), //Space lebih besar di bawah form
              //Tombol untuk menambahkan buku
              Center(
                child: SizedBox(
                  width: 150, //Tentukan lebar tombol
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addBook, //Jika sedang loading, tombol tidak bisa ditekan
                    child: _isLoading //Jika loading true, tampilkan progress indicator
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Add Book'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
