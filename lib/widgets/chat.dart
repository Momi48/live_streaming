import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/firebase/firestore_method.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/widgets/custom_textfield.dart';
import 'package:twitch_clone/widgets/loader.dart';

class Chat extends StatefulWidget {
  final String channelId;
  const Chat({super.key, required this.channelId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void dispose() {
    super.dispose();
    chatController.dispose();
  }

  final chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width > 600 ? size.width * 0.25 : double.infinity,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('livestream')
                  .doc(widget.channelId)
                  .collection('comments')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Loader());
                }
                final data = snapshot.data!.docs;
                print('Data is $data');
                return ListView.builder(
                  shrinkWrap: true,
                  
                  itemCount: data.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      data[index]['username'],
                      style: TextStyle(color: Colors.blue),
                    ),
                    subtitle: Text(
                      data[index]['message'],
                      style: TextStyle(
                        color:
                            snapshot.data!.docs[index]['uuid'] ==
                                userProvider.user.uuid
                            ? Colors.blue
                            : Colors.pink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CustomTextField(
            controller: chatController,
            onTap: (val) {
              FirestoreMethod().chat(
                chatMessage: chatController.text,
                channelId: widget.channelId,
                context: context,
              );
              setState(() {
                chatController.clear();
              });
            },
          ),
        ],
      ),
    );
  }
}
