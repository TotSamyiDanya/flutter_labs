import 'dart:convert';
import 'dart:ffi';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/cryptocurrency_parser.dart';
import 'package:untitled/models/chartPoints.dart';
import 'package:untitled/price.dart';
import 'package:untitled/widget_generator.dart';

import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart' as fl;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binance App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cryptocurrency Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  CryptocurrencyParser parser = CryptocurrencyParser();
  List<Price> prices = [];

  _MyHomePageState() {
    loadPrices();
  }

  void loadPrices() async {
    prices = await parser.fetchCurrency();
    setState(() {
      prices.removeLast();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202229),
      appBar: AppBar(
        backgroundColor: Color(0xFF202229),
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF)
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,

                    itemCount: prices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2E39),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              spreadRadius: 0,
                              blurRadius: 7,
                              blurStyle: BlurStyle.normal,
                              offset: Offset(0, 2),
                            ),
                          ],
                          shape: BoxShape.rectangle,
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MySecondPage(title: "", price: prices[index])));
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(

                                      child: Image.network(
                                        "https://s2.coinmarketcap.com/static/img/coins/64x64/${prices[index].id}.png",
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.topCenter,
                                      ),
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                      height: 50,
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0, 15, 5, 5),
                                              child: Text(
                                                prices[index].symbol,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFFFFFFFF)
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(0.00, 1.00),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 7),
                                                child: Text(
                                                  prices[index].name,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w400,
                                                      color: Color(0xFF6C6D78)
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                              child: Text(
                                                "\$ ${prices[index].price}",
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFFFFFFFF)
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    );
                  }

                )
                )
              ]
          ),
        ),
      ),
    );
  }
}

class MySecondPage extends StatefulWidget {
  const MySecondPage({super.key, required this.title, required this.price});
  final String title;
  final Price price;
  @override
  State<MySecondPage> createState() => _MySecondPageState(price);
  
  
}

class _MySecondPageState extends State<MySecondPage> {

  CryptocurrencyParser parser = CryptocurrencyParser();
  WidgetGenerator generator = WidgetGenerator();
  Price? price = null;

  _MySecondPageState(Price this.price) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202229),
      appBar: AppBar(
        backgroundColor: Color(0xFF202229),
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFFFFFF)
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(child: generator.generateCryptocurrencyHeader(price)),
            Text('Price change for the last 24hr', textAlign: TextAlign.left ,style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
            Container(
                      height: 350,
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      margin: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF2D2E39),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), spreadRadius: 0, blurRadius: 7,
                      blurStyle: BlurStyle.normal, offset: Offset(0, 2))]),
                      child: LineChartWidget(id: price!.id))
        ]
        ),
      ),
    );
  }
}