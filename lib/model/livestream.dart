class LiveStream {
  String? channelId;
  String? image;
  String? startedAt;
  String? title;
  String? uid;
  String? username;
  int? viewers;

  LiveStream(
      {required this.channelId,
      required this.image,
      required this.startedAt,
      required this.title,
      required this.uid,
      required this.username,
      required this.viewers});

  LiveStream.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    image = json['image'];
    startedAt = json['startedAt'];
    title = json['title'];
    uid = json['uid'];
    username = json['username'];
    viewers = json['viewers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channelId'] = channelId;
    data['image'] = image;
    data['startedAt'] = startedAt;
    data['title'] = title;
    data['uid'] = uid;
    data['username'] = username;
    data['viewers'] = viewers;
    return data;
  }
}
