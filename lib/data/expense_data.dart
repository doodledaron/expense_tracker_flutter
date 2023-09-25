//handles of the data of expenses, including getters, methods, and etc

import 'package:expense_tracker2/dateTime/datetime_helper.dart';

import 'package:expense_tracker2/model/expense_item.dart';
import 'package:flutter/material.dart';
import 'hive_database.dart';

class ExpenseData extends ChangeNotifier {
  //list ALL the expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  //prepare data for database
  final db = HiveDatabase(); //HiveDatabase from our class

  //no need to notify listener's as it doesn't involve any direct modifications
  //it does not trigger any UI rebuild, it is just a initialization proccess in init state

  void prepareData() {
    //replace overall Expense list with the saved List
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //whenever we need to modify the data, we need to notify
  //But, when we call the setters, we need to set listen:false explicitly
  //while we invoke the getters, the listen:true is set implicitly as we need to
  //listen for changes

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    //whenever we add new expenses, save the list
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    //whenever we delete a expense, save the list
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  //get weekday (mon, tues, etc) from a dateTime project
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  //get the date for the start of the week (sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

//get today's date
    DateTime today = DateTime.now();

    //go backwards from today to find to start of week
    for (int i = 0; i < 7; i++) {
      //keep subtracting today's date to find the date of start of the week (from Sunday)
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

/*

  convert overall list of expenses into a daily expense summary

  for example:

  dateTime format -> yyyy-mm-dd
  [
    [food, 2023/8/25, $10],
    [hat, 2023/8/25, $5],
    [drinks, 2023/8/26, $3],
    [food, 2023/8/27, $10],
    [food, 2023/8/27, $10],
  ]

  into

  Daily Expense Summary: in a map pattern

  [
    [2023825:$25],
    [2023826:$3],
    [2023827:$20]
  ]
*/
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(
          expense.dateTime); // get the datetime of the ExpenseItem
      double amount =
          double.parse(expense.amount); // get the amount to the ExpenseItem

      //check if there is already an entry with this key in map
      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount =
            dailyExpenseSummary[date]!; //get the current amount
        currentAmount += amount; // add up the amount
        dailyExpenseSummary[date] = currentAmount; //assign the value via key
      } else {
        dailyExpenseSummary.addAll({date: amount}); // add into map
      }
    }

    return dailyExpenseSummary;
  }
}
//notifyListeners is  used when you want to inform the UI that the data it's displaying has changed.
// You call it after you make changes to the data that should be reflected in the UI.
