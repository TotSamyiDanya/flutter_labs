import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/price.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptocurrencyParser {
  Future<List<Price>> fetchCurrency() async {
    final response = await http.get(Uri.parse('https://www.binance.com/bapi/composite/v1/public/promo/cmc/cryptocurrency/listings/latest?limit=100&start=1'));
    List<Price> result = [];

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body) as Map<String, dynamic>;
      var prices = body['data']['body']['data'];
      for(int i = 0; i < prices.length; i++) {
        result.add(Price(id: prices[i]['id'], symbol: prices[i]['symbol'], name: prices[i]['name'], price: prices[i]['quote']['USD']['price'].toString().substring(0, 7), change: prices[i]['quote']['USD']['percent_change_24h'].toString().substring(0, 5)));
      }

      return result;
    }
    else {
      throw Exception('Failed to load prices');
    }
  }

    Future<List<double>> fetchChart(int id) async {
    List<double> result = [];
    final response = await http.get(Uri.parse("https://www.binance.com/bapi/composite/v1/public/promo/cmc/cryptocurrency/detail/chart?id=$id&range=1D"));
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    var points = body['data']['body']['data']['points'];
    points.forEach((point, value) => result.add(value['v'][0]));
    return result;
  }
}