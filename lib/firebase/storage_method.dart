import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitch_clone/utils/utils.dart';

class StorageMethod {
  Future<String> uploadImages({
    required BuildContext context,
    Uint8List? image,
  }) async {
    String imageUrl = '';
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';

      Supabase.instance.client.storage
          .from('twtichy')
          .uploadBinary(path, image!);

      final publicUrlResponse = Supabase.instance.client.storage
          .from('twtichy')
          .getPublicUrl(path);
          
      imageUrl = publicUrlResponse;

      showSnackBar(context, 'Thumbnail updated successfully! File: $imageUrl');
      return imageUrl;
    } on StorageException  catch (e) {
      showSnackBar(context, e.toString());
    }
    return imageUrl;
  }
}
