import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/firebase/storage_method.dart';
import 'package:twitch_clone/model/livestream.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StorageMethod storageMethod = StorageMethod();
  Future<String> startLiveChannel({
    required BuildContext context,
    required Uint8List? image,
    required String title,
  }) async {
    String channelId = '';
    try {
      final now = DateTime.now();
      final startedAt = '${now.hour}:${now.minute}';
      final user = Provider.of<UserProvider>(context, listen: false).user;
      channelId = "${user.uuid}${user.username}";
      //check if no livestream has started then start one
      if (!(await firebaseFirestore
              .collection('livestream')
              .doc(channelId.toString())
              .get())
          .exists) {
        final supbaseUrlImage = await storageMethod.uploadImages(
          context: context,
          image: image!,
        );

        print('Image URL in Start Live channel FUnction is $supbaseUrlImage');
        LiveStream liveStream = LiveStream(
          channelId: channelId,
          image: supbaseUrlImage,
          startedAt: startedAt,
          title: title,
          uid: user.uuid,
          username: user.username,
          viewers: 0,
        );
        await firebaseFirestore
            .collection('livestream')
            .doc(channelId)
            .set(liveStream.toJson());
      } else {
        showSnackBar(context, 'Live Stream has Already Starting');
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
    return channelId;
  }

  Future<void> endLiveStream(String channelId, BuildContext context) async {
    final snapshot = await firebaseFirestore
        .collection('livestream')
        .doc(channelId)
        .collection('comments')
        .get();
    for (var data in snapshot.docs) {
      await data.reference.delete();
    }

    await firebaseFirestore.collection('livestream').doc(channelId).delete();
  }

  //
  Future<void> chat({
    required String chatMessage,
    required String channelId,
    required BuildContext context,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    String commentId = Uuid().v1();
    await firebaseFirestore
        .collection('livestream')
        .doc(channelId)
        .collection('comments')
        .doc(commentId)
        .set({
          'username': user.username,
          'message': chatMessage,
          'uuid': user.uuid,
          'commentId': commentId,
          'createdAt': DateTime.now(),
        });
  }

  Future<void> updateViewsCount(String channelId, bool isIncrease) async {
    // isIncrease = true mean user coming from feed and false mean user coming from go live
    await firebaseFirestore.collection('livestream').doc(channelId).update({
      'viewers': FieldValue.increment(isIncrease ? 1 : -1),
    });
  }
}
