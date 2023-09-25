import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:expense_tracker2/model/expense_item.dart';

class HiveDatabase {
  //reference our box
  //expense_database got some problem already coz we input the wrong data
  final _mybox = Hive.box('expense_database2');

  //write data
  void saveData(List<ExpenseItem> allExpense) {
    //Hive can only store primitive types like strings, int, dateTime,etc
    //but not custom objects
    //so we need to convert ExpenseItem(custom objects) into basic data types

    //dynamic means we could store diff data types
    List<List<dynamic>> allExpensesFormatted = [];
    for (var expense in allExpense) {
      //convert into storable types
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime
      ];
      allExpensesFormatted.add(expenseFormatted);
    }
//finally, store in our hive database, in key-value form
    _mybox.put('ALL_EXPENSES', allExpensesFormatted);
  }

  //read data
  List<ExpenseItem> readData() {
    //data is stored as list of strings and dateTime, so we needa convert it back to
    //Expense item object
    List savedExpenses = _mybox.get('ALL_EXPENSES') ??
        []; //if null is returned, return empty list
    List<ExpenseItem> allExpenses = [];

    //get the name, amount and dateTime from savedExpenses (List of dynamic list)
    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItem expenseItem =
          ExpenseItem(name: name, amount: amount, dateTime: dateTime);
      allExpenses.add(expenseItem);
    }

    return allExpenses;
  }
}
