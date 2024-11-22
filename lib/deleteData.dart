import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> deleteBook(int bookId) async {
  await Supabase.instance.client.from('books').delete().eq('id', bookId); //hapus data
}
