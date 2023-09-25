import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;
  const MyBarGraph(
      {super.key,
        required this.maxY,
        required this.sunAmount,
        required this.monAmount,
        required this.tueAmount,
        required this.wedAmount,
        required this.thurAmount,
        required this.friAmount,
        required this.satAmount});

  @override
  Widget build(BuildContext context) {
    //initialize bar data
    BarData myBarData = BarData(
        sunAmount: sunAmount,
        monAmount: monAmount,
        tueAmount: tueAmount,
        wedAmount: wedAmount,
        thurAmount: thurAmount,
        friAmount: friAmount,
        satAmount: satAmount);
    myBarData
        .initializeBarData(); // create 7 individual bars with the properties from barData in barData list
    return BarChart(
      BarChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: getBottomTitles),
            ),
          ),
          // maxY: 30,
          minY: 5,
          barGroups: myBarData.barData
          //x is the x axis of the bar
          //barRods is the y axis of the bar
          //BarChartGroupData represents a group of bars
          //The map function iterates over each element in the myBarData.barData list, and for each element, it creates a new BarChartGroupData object.
              .map(
                (data) => BarChartGroupData(x: data.x, barRods: [
              BarChartRodData(
                  toY: data.y,
                  color: Colors.grey[800],
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                      show: true, color: Colors.grey[200], toY: maxY)),
            ]),
          )
              .toList()),
    );
  }

  SideTitleWidget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
    Widget text;
    switch (value.toInt()) {
      case 1: // Start from 1
        text = Text(
          'S',
          style: style,
        );
        break;
      case 2:
        text = Text(
          'M',
          style: style,
        );
        break;
      case 3:
        text = Text(
          'T',
          style: style,
        );
        break;
      case 4:
        text = Text(
          'W',
          style: style,
        );
        break;
      case 5:
        text = Text(
          'T',
          style: style,
        );
        break;
      case 6:
        text = Text(
          'F',
          style: style,
        );
        break;
      case 7:
        text = Text(
          'S',
          style: style,
        );
        break;
      default:
        text = Text(
          '',
          style: style,
        );
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
