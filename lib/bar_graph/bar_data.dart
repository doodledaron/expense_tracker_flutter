import 'package:flutter/material.dart';
import 'individual_bar.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  BarData(
      {required this.sunAmount,
        required this.monAmount,
        required this.tueAmount,
        required this.wedAmount,
        required this.thurAmount,
        required this.friAmount,
        required this.satAmount});

  List<IndividualBar> barData = [];

  void initializeBarData() {
    //x is the x-axis position of individual bars
    //y is the y-axis position of individual bars
    barData = [
      IndividualBar(x: 1, y: sunAmount),
      IndividualBar(x: 2, y: monAmount),
      IndividualBar(x: 3, y: tueAmount),
      IndividualBar(x: 4, y: wedAmount),
      IndividualBar(x: 5, y: thurAmount),
      IndividualBar(x: 6, y: friAmount),
      IndividualBar(x: 7, y: satAmount)
    ]; //create 7 individual bars with barData properties in barData
  }
}
