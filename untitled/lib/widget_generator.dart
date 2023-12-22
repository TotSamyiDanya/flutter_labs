import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/price.dart';

class WidgetGenerator {
  Container generateCryptocurrencyHeader(Price? price){
    return Container(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
          height: 100,
          margin: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
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
            onTap: (){},
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
                          "https://s2.coinmarketcap.com/static/img/coins/64x64/${price!.id}.png",
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
                                  price.symbol,
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
                                    price.name,
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
                                  "\$ ${price.price}",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFFFFFFF)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                child: Text(
                                  "${price.change}%",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: price.change[0] != '-' ? Colors.green : Colors.red
                                    ),
                                )
                                ),
                            ],
                          ),
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
}