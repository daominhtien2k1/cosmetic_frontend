import 'package:equatable/equatable.dart';

class EventList {
  final List<Event>? happeningEventList;
  final List<Event>? endedEventList;

  EventList({this.happeningEventList, this.endedEventList});

  EventList.initial(): happeningEventList = List<Event>.empty(growable: true), endedEventList = List<Event>.empty(growable: true);

  EventList copyWith({List<Event>? happeningEventList, List<Event>? endedEventList,}) {
    return EventList(
      happeningEventList: happeningEventList ?? this.happeningEventList,
      endedEventList: endedEventList ?? this.endedEventList,
    );
  }

  factory EventList.fromJson(Map<String, dynamic> json) {
    final happeningEventListData = json["data"]["happeningEventList"] as List<dynamic>?;
    final endedEventListData = json["data"]["endedEventList"] as List<dynamic>?;
    return EventList(
      happeningEventList: happeningEventListData?.map((hpe) => Event.fromJson(hpe)).toList(),
      endedEventList: endedEventListData?.map((ee) => Event.fromJson(ee)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (happeningEventList != null) "happeningEventList": happeningEventList!.map((hpe) => hpe.toJson()).toList(),
      if (endedEventList != null) "endedEventList": endedEventList!.map((ee) => ee.toJson()).toList(),
    };
  }

}

class Event {
  final String id;
  final EventImage image;
  final String title;
  final int clicks;
  final String remainingTime;

  Event({required this.id, required this.image, required this.title, required this.clicks, required this.remainingTime,});

  Event copyWith({String? id, EventImage? image, String? title, int? clicks, String? remainingTime,}) {
    return Event(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      clicks: clicks ?? this.clicks,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"] as String,
      image: EventImage.fromJson(json["image"]),
      title: json["title"] as String,
      clicks: json["clicks"] as int,
      remainingTime: json["remainingTime"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image.toJson(),
      "title": title,
      "clicks": clicks,
      "remainingTime": remainingTime,
    };
  }

}


class EventImage {
  final String? filename;
  final String url;
  final String? publicId;

  EventImage({this.filename, required this.url, this.publicId});

  EventImage copyWith({String? filename, String? url, String? publicId}) {
    return EventImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
        filename: json['filename'] as String?,
        url: json['url'] as String,
        publicId: json['publicId'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if(filename != null) 'filename': filename,
      'url': url,
      if(publicId != null) 'publicId': publicId
    };
  }
}
