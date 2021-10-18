import 'package:flutter/foundation.dart';

class Beer {
  final String name;
  final String urlImage;
  final String abv;

  Beer({
    required this.name,
    required this.urlImage,
    required this.abv,
  });
  
  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
        name: json["name"],
        urlImage: "rer",
        abv: "rere");
  }

  // Beer(
  //   this.name,
  //   this.urlImage,
  //   this.abv,
  //  );
}
