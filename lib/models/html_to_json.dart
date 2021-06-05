import 'dart:collection';

class ElementToImage {
  String src;
  int width;

  ElementToImage({this.src, this.width});

  ElementToImage.fromJson(LinkedHashMap<dynamic, String> json)
      : src = json['src'] ?? '',
        width = json['width'] != null ? int.parse(json['width']) : 0;
}
