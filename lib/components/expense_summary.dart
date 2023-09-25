import 'package:expense_tracker2/bar_graph/bar_graph.dart';
import 'package:expense_tracker2/data/expense_data.dart';
import 'package:expense_tracker2/dateTime/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseSummary extends StatelessWidget {
  DateTime startOfWeek; //passed in start of the week date (sunday)
  ExpenseSummary({super.key, required this.startOfWeek});

  double calculateMax(ExpenseData value, String sun, String mon, String tue,
      String wed, String thur, String fri, String sat) {
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sun] ?? 0,
      value.calculateDailyExpenseSummary()[mon] ?? 0,
      value.calculateDailyExpenseSummary()[tue] ?? 0,
      value.calculateDailyExpenseSummary()[wed] ?? 0,
      value.calculateDailyExpenseSummary()[thur] ?? 0,
      value.calculateDailyExpenseSummary()[fri] ?? 0,
      value.calculateDailyExpenseSummary()[sat] ?? 0,
    ];

    values.sort();
    max = values.last * 1.1;
    //if max is 0, return 100 else return max value that we calculated
    return max == 0 ? 100 : max;
  }

  double calculateWeekTotal(ExpenseData value, String sun, String mon,
      String tue, String wed, String thur, String fri, String sat) {
    double total = 0;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sun] ?? 0,
      value.calculateDailyExpenseSummary()[mon] ?? 0,
      value.calculateDailyExpenseSummary()[tue] ?? 0,
      value.calculateDailyExpenseSummary()[wed] ?? 0,
      value.calculateDailyExpenseSummary()[thur] ?? 0,
      value.calculateDailyExpenseSummary()[fri] ?? 0,
      value.calculateDailyExpenseSummary()[sat] ?? 0,
    ];

    for (var amount in values) {
      total += amount;
    }
    ;

    return total;
  }

  //TODO: add animatioin so that the bar graph looks juiced up when entering the app and added expenses

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(startOfWeek.add(Duration(days: 0)));
    String monday = convertDateTimeToString(startOfWeek.add(Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(Duration(days: 4)));
    String friday = convertDateTimeToString(startOfWeek.add(Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(Duration(days: 6)));
    return Consumer<ExpenseData>(
      builder: (context, data, child) => Column(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                'Week total: ',
                style: GoogleFonts.lobster(
                  textStyle: TextStyle(fontSize: 25),
                ),
              ),
              Text(
                '${calculateWeekTotal(data, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}\$',
                style: GoogleFonts.lobster(
                  textStyle: TextStyle(fontSize: 25),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: MyBarGraph(
              maxY: calculateMax(data, sunday, monday, tuesday, wednesday,
                  thursday, friday, saturday),
              sunAmount: data.calculateDailyExpenseSummary()[sunday] ??
                  0, // if it is null return 0 (not yet input)
              monAmount: data.calculateDailyExpenseSummary()[monday] ?? 0,
              tueAmount: data.calculateDailyExpenseSummary()[tuesday] ?? 0,
              wedAmount: data.calculateDailyExpenseSummary()[wednesday] ?? 0,
              thurAmount: data.calculateDailyExpenseSummary()[thursday] ?? 0,
              friAmount: data.calculateDailyExpenseSummary()[friday] ?? 0,
              satAmount: data.calculateDailyExpenseSummary()[saturday] ?? 0),
        ),
      ]),
    );
  }
}
