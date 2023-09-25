import 'package:expense_tracker2/dateTime/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final Function(BuildContext)? deleteTapped;
  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          //TODO we can add a edit button
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.redAccent,
            borderRadius: BorderRadius.circular(15),
          )
        ],
      ),
      child: ListTile(
        title: Text(name),
        subtitle: Text(convertDateTimeToString(dateTime)),
        trailing: Text(amount),
      ),
    );
  }
}
