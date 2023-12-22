

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartPoint {
  final DateTime x;
  final double y;
  ChartPoint({required this.x, required this.y});
}

Future<SfCartesianChart> getChart(int id) async {
  SfCartesianChart result;
  List<ChartPoint> data = [];
  final response = await http.get(Uri.parse("https://www.binance.com/bapi/composite/v1/public/promo/cmc/cryptocurrency/detail/chart?id=$id&range=1D"));
  var body = jsonDecode(response.body) as Map<String, dynamic>;
  var points = body['data']['body']['data']['points'];
  points.forEach((point, value) => data.add
    (ChartPoint(x: DateTime.fromMillisecondsSinceEpoch(int.parse(point) * 1000), y: value['v'][0].toDouble())));

  List<ChartPoint> endData = [];
  try {
    for (int i = 0; i < data.length; i = i + 7) {
      endData.add(data[i]);
    }
  }
  on RangeError catch(exception) { }


  result = SfCartesianChart(
    plotAreaBorderColor: Colors.grey,
    plotAreaBorderWidth: 0.1,
    borderColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    primaryYAxis: NumericAxis(axisLine: AxisLine(color: Colors.transparent), majorTickLines: MajorTickLines(width: 0, size: 10), opposedPosition: true, majorGridLines: const MajorGridLines(width: 0.1), labelStyle: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF6C6D78))),
    primaryXAxis: CategoryAxis(axisLine: AxisLine(color: Colors.transparent), majorTickLines: MajorTickLines(width: 0.1), majorGridLines: const MajorGridLines(width: 0), minorGridLines: const MinorGridLines(width: 0), borderWidth: 0, labelStyle: TextStyle(color: Colors.transparent)),
    legend: const Legend(isVisible: false),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: <ChartSeries<ChartPoint, String>>[
      LineSeries(
          width: 3,
          color: Colors.orange,
          dataSource: endData.reversed.toList(),
          xValueMapper:  (ChartPoint points, _) => DateFormat.Hms().format(points.x),
          yValueMapper: (ChartPoint points, _) => points.y
      )
    ]
  );

  return result;
}


class LineChartWidget extends StatelessWidget {
  final int id;

  const LineChartWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FutureBuilder<SfCartesianChart>(
        future: getChart(id),
        builder: (BuildContext context, AsyncSnapshot<SfCartesianChart> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: return const Text('Error');
            case ConnectionState.waiting: return Container(width: 200, height: 200, alignment: Alignment.center, child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                Container(
                  margin: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                  child: Text('Loading',
                      style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w400, color: const Color(0xFFFFFFFF))),
                )
              ],
            ));
            case ConnectionState.active: return const CircularProgressIndicator();
            case ConnectionState.done: return Container(
              margin: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
              child: snapshot.requireData
            );
          }
        }
      )
    );
  }
}