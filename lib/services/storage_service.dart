import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadProductImage({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final fileName =
        'prod_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    await _supabase.storage
        .from('product-images')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$fileExtension'),
        );
    return _supabase.storage.from('product-images').getPublicUrl(fileName);
  }
}
