import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/firebase/firestore_method.dart';
import 'package:twitch_clone/model/livestream.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/screens/broadcast_screen.dart';
import 'package:twitch_clone/widgets/loader.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
        child: Column(
          children: [
            Text(
              'Welcome  ${Provider.of<UserProvider>(context,listen: false).user.username}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(height: size.height * 0.03),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('livestream')
                  .snapshots(),
              builder: (context, snapshot) {
                print('Snashot ${snapshot.data} and ${snapshot.hasData}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loader();
                }
                if (snapshot.data == null) {
                  return Center(
                    child: Text(
                      'No Live Stream has Started yet Or Start your Own Live Stream',
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index].data();
                        final post = LiveStream.fromJson(data);
                        return InkWell(
                          onTap: () async{
                            await FirestoreMethod()
                                .updateViewsCount( post.channelId!, true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BroadcastScreen(
                                  channelId: post.channelId!,
                                  isBroadcast: false,
                                ),
                              ),
                            );
                           
                          },
                          child: Center(
                            child: Container(
                              width: 320,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Thumbnail section
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Image.network(
                                          post.image!.toString(),
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            'LIVE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  // Info section
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.black,
                                          child: Text(
                                            post.username![0],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.username
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                post.title.toString(),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                post.viewers.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'Started ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.more_vert,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
