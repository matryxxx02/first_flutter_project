import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'beer_model.dart';
import 'dart:convert';

class BeerService {
  final String urlApi = "api.openbrewerydb.org";

  Future<List<Beer>> getBeers() async {
    try {
      var res = await get(Uri.https(urlApi, "/breweries"));

      print(res);
      List<dynamic> body = jsonDecode(res.body);
      List<Beer> beers = body.map((dynamic item) => Beer.fromJson(item)).toList();
      print(beers);
      return beers;
    } on ClientException catch (e) {
      print("error");
      print(e.message);
    }

    return [];
  }
}
