import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

// Future<File>? pickImages({required BuildContext context}) async {
//   File? imgFile;
//   ImagePicker picker = ImagePicker();
//   final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//   if (image == null) {
//     showSnackBar(context, 'No Images Selected');
//   }
//   try {
//     if (image != null) {
      
//       imgFile = File(image.path);
//     }
//   } catch (e) {
//     showSnackBar(context, 'Error picking image: ${e.toString()}');
//   }
//   return imgFile!;
// }


Future<Uint8List?> pickFileImage({required BuildContext context}) async {
  FilePickerResult? pickedImage =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if (pickedImage != null) {
    if (kIsWeb) {
      return pickedImage.files.single.bytes;
    }
    return await File(pickedImage.files.single.path!).readAsBytes();
  }
  return null;
}
