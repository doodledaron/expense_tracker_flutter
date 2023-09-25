import 'components/expense_summary.dart';
import 'data/expense_data.dart';

import 'package:expense_tracker2/model/expense_item.dart';
import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';
import 'package:flutter_gif/flutter_gif.dart';

import 'package:provider/provider.dart';

import 'components/expense_tile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();
  bool isLoading = true;

  void addExpenses() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add new expenses'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //expense name
              TextField(
                decoration: InputDecoration(hintText: 'Expense name'),
                controller: newExpenseNameController,
              ),
              //expense amount

              //when we have two text fields in a row, we need to give them a width ( Expanded is also a choice)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'dollars'),
                      controller: newExpenseDollarController,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'cents'),
                      controller: newExpenseCentsController,
                    ),
                  )
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: save,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                // You can add other style properties as needed.
              ),
              child: Text('Save'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                // You can add other style properties as needed.
              ),
              onPressed: cancel,
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  //TODO if all fields are not filled, give an alert
  void save() {
    if (newExpenseNameController.text.isEmpty &&
        newExpenseDollarController.text.isEmpty &&
        newExpenseCentsController.text.isEmpty) {
      showCustomDialog();
    } else {
      if (newExpenseCentsController.text.isEmpty) {
        if (newExpenseDollarController.text.isEmpty) {
          newExpenseDollarController.text = '0';
        }
        newExpenseCentsController.text = '0';
      }
      //only save if all fields are filed
      if (newExpenseNameController.text.isNotEmpty &&
          newExpenseDollarController.text.isNotEmpty &&
          newExpenseCentsController.text.isNotEmpty) {
        String totalAmount = newExpenseDollarController.text +
            '\.' +
            newExpenseCentsController.text;
        ExpenseItem expense = ExpenseItem(
            name: newExpenseNameController.text,
            amount: totalAmount,
            dateTime: DateTime.now());
        //add the new Expense
        Provider.of<ExpenseData>(context, listen: false).addNewExpense(expense);
      }
      Navigator.pop(context);
      clear();
    }
  }

  void showCustomDialog() {
    FlutterGifController controller = FlutterGifController(vsync: this);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Input :)'),
            content: Text('Oopsie, did you forgot something?'),
            actions: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  // You can add other style properties as needed.
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Roger that!'),
              )
            ],
          );
        });
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    //clear the textfield of both using controllers
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
    newExpenseNameController.clear();
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        isLoading = false;
      });
    });
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        //value means : Provider.of<ExpenseData>(context)
        return Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: addExpenses,
              child: const Icon(Icons.add),
            ),
            body: isLoading
                ? LoadingScreen()
                : ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ExpenseSummary(startOfWeek: value.startOfWeekDate()),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.getAllExpenseList().length,
                        itemBuilder: (context, index) {
                          return ExpenseTile(
                            name: value.getAllExpenseList()[index].name,
                            amount:
                                '\$${value.getAllExpenseList()[index].amount}',
                            dateTime: value.getAllExpenseList()[index].dateTime,
                            deleteTapped: (context) {
                              //delete the particular expense
                              deleteExpense(value.getAllExpenseList()[index]);
                            },
                          );
                        },
                      ),
                    ],
                  ));
      },
    );
  }
}
