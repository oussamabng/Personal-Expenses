import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './chart.bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  // attributes
  final List<Transaction> recentTransactions;

  // constructor
  Chart(this.recentTransactions);

  // get dates and amount values
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues
                  .map((data) => Flexible(
                      fit: FlexFit.tight,
                      child: ChartBar(
                          data["day"],
                          data["amount"],
                          maxSpending == 0.0
                              ? 0.0
                              : (data["amount"] as double) / maxSpending)))
                  .toList()),
        ));
  }
}
