// import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'home_page.dart';

// class AddBookPage extends StatefulWidget {
//   const AddBookPage({super.key});

//   @override
//   State<AddBookPage> createState() => _AddBookPageState();
// }

// class _AddBookPageState extends State<AddBookPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _authorController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   Future<void> _addBook() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     final title = _titleController.text;
//     final author = _authorController.text;
//     final description = _descriptionController.text;
//     final response = await Supabase.instance.client
//         .from('books')
//         .insert({'title': title, 'author': author, 'description': description});

//     if (response != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${response}')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Book added successfully!')));
//       _titleController.clear();
//       _authorController.clear();
//       _descriptionController.clear();
//     }

//     Navigator.pop(context, true);
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => const BookListPage()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add New Book'),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: _titleController,
//               decoration: const InputDecoration(
//                 labelText: 'Title',
//                 border: UnderlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter the title';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             TextFormField(
//               controller: _authorController,
//               decoration: const InputDecoration(
//                 labelText: 'Author',
//                 border: UnderlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter the author';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Description',
//                 border: UnderlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter the description';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Center(
//               child: SizedBox(
//                 width: 150,
//                 child: ElevatedButton(
//                     onPressed: _addBook, child: const Text('Add Book')),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false; // Indikator loading

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final title = _titleController.text;
    final author = _authorController.text;
    final description = _descriptionController.text;

    final response = await Supabase.instance.client.from('books').insert({
      'title': title,
      'author': author,
      'description': description
    }).select();

    setState(() {
      _isLoading = false;
    });

    if (response != null && response.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added successfully!')),
      );
      _titleController.clear();
      _authorController.clear();
      _descriptionController.clear();
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
        title: const Text('Add New Book'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey, // Gunakan form key untuk validasi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addBook,
                    child: _isLoading
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
