import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/firebase/firestore_method.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/screens/home_screen.dart';
import 'package:twitch_clone/utils/global_variables.dart';
import 'package:twitch_clone/utils/utils.dart';
import 'package:twitch_clone/widgets/chat.dart';

class BroadcastScreen extends StatefulWidget {
  final String channelId;
  final bool isBroadcast;
  const BroadcastScreen({
    super.key,
    required this.channelId,
    required this.isBroadcast,
  });

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FirestoreMethod firestoreMethod = FirestoreMethod();
  RtcEngine? engine;
  List<int> remoteUid = [];
  bool isScreenSharing = false;
  bool isSwitched = false;
  bool isMuted = false;
  @override
  void initState() {
    super.initState();
    initEngine();
  }

  void initEngine() async {
    engine = createAgoraRtcEngine();

    await engine!.initialize(RtcEngineContext(appId: appId));
    addListeners();
    await engine!.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );
    print('Engine is running $appId ');
    await engine!.enableAudio();
    await engine!.enableVideo();

    await engine!.setLocalVideoMirrorMode(
      VideoMirrorModeType.videoMirrorModeDisabled,
    );

    await engine!.startPreview();

    if (widget.isBroadcast) {
      print('User is BroadCaster ');
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      print('User is Audience ');
      await engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
    }
  }

  Future<void> addListeners() async {
    print('Hello');
    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onRejoinChannelSuccess: (connection, elapsed) {
          print('Channel Joined Again');
        },
        onError: (ErrorCodeType err, String msg) {},
        onJoinChannelSuccess: (RtcConnection connection, int id) {
          print('joinChannelSuccess  $id');
        },
        onUserJoined: (connection, id, elapsed) {
          print('Remote user joined: $id and remote uid $remoteUid');
          setState(() {
            remoteUid.add(id);
          });
        },
        onUserInfoUpdated: (int uid, UserInfo info) {
          print('[onUserInfoUpdated] uid: $uid UserInfo: ${info.toJson()}');
        },
        onUserOffline: (connection, id, reason) {
          setState(() {
            remoteUid.removeWhere((element) => id == element);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          setState(() { 
            remoteUid.clear();
          });
        },
        onTokenPrivilegeWillExpire: (connection, token) async {
          await getToken();
          await engine!.renewToken(token);
        },
      ),
    );

    joinChannel();
  }

  String baseUrl = 'http://192.168.0.107:8080/';

  String? token;

  //http://localhost:8080/rtc/{channelName}/{role}/{tokentype}/{uid}
  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(
        '${baseUrl}rtc/test123/publisher/userAccount/${Provider.of<UserProvider>(context, listen: false).user.uuid}',
      ),
    );
    print('Res ${res.body}');
    if (res.statusCode == 200) {
      token = res.body;
      token = jsonDecode(token!)['rtcToken'];
      print('Token OF RTC is  $token');
    } else {
      debugPrint("Fail To Fetch Tokens");
    }
  }

  Future<void> startScreenShare() async {
    ScreenCaptureParameters2 captureParams = ScreenCaptureParameters2(
      captureAudio: true,
      captureVideo: true,
    );

    await engine!.startScreenCapture(captureParams);

    setState(() => isScreenSharing = true);
  }

  Future<void> stopScreenShare() async {
    await engine!.stopScreenCapture();
    setState(() => isScreenSharing = false);
  }

  void joinChannel() async {
    await getToken();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.camera, Permission.microphone].request();
    }

    await engine!.joinChannelWithUserAccount(
      token: token!,
      channelId: widget.channelId,

      userAccount: Provider.of<UserProvider>(
        context,
        listen: false,
      ).user.uuid.toString(),
    );
    print('Channel ID ${widget.channelId}');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        leaveStreamChannel();
      },

      child: Scaffold(
        // bottomNavigationBar: widget.isBroadcast
        //     ? CustomButton(onTap: leaveStreamChannel, text: 'End Stream ')
        //     : null,
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Live Streaming'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      color: Colors.black,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: widget.isBroadcast
                            ? isScreenSharing
                                  ? Center(
                                      child: Text(
                                        "You Are Screen Sharing",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    )
                                  : AgoraVideoView(
                                      controller: VideoViewController(
                                        rtcEngine: engine!,
                                        canvas: VideoCanvas(uid: 0),
                                      ),
                                    )
                            : remoteUid.isNotEmpty
                            ? AgoraVideoView(
                                controller: VideoViewController.remote(
                                  rtcEngine: engine!,
                                  canvas: VideoCanvas(uid: remoteUid[0]),
                                  connection: RtcConnection(
                                    channelId: widget.channelId,
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  "You Have Joined Stream",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    if (widget.isBroadcast)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: swtichCameraChannel,
                            child: Text('Switch Camera'),
                          ),

                          InkWell(
                            onTap: onToggleMute,
                            child: Text(isMuted ? 'Unmute' : "Mute"),
                          ),
                          InkWell(
                            onTap: isScreenSharing
                                ? stopScreenShare
                                : startScreenShare,
                            child: Text(
                              isScreenSharing
                                  ? 'Stop Screen Sharing'
                                  : "Start Screen Sharing",
                            ),
                          ),
                           
                            
                        ],
                      ),
                      SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Chat(channelId: widget.channelId),
                            ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void swtichCameraChannel() {
    engine!.switchCamera().then((_) {
      setState(() {
        isSwitched = !isSwitched;
      });
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await engine!.muteLocalAudioStream(isMuted);
  }

  void leaveStreamChannel() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    await engine!.leaveChannel();
    if ("${user.uuid}${user.username}" == widget.channelId) {
      await firestoreMethod.endLiveStream(
        widget.channelId,
        scaffoldKey.currentContext!,
      );
      showSnackBar(scaffoldKey.currentContext!, "You Have Left The Channel");
    } else {
      firestoreMethod.updateViewsCount(widget.channelId, false);
    }
    Navigator.pushReplacementNamed(
      scaffoldKey.currentContext!,
      HomeScreen.routeName,
    );
  }
}
