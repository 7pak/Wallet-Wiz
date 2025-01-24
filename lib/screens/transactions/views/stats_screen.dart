import 'package:flutter/material.dart';
import 'package:wallet_tracker/screens/common_widgets/transactions_list_widget.dart';
import 'package:wallet_tracker/screens/transactions/widgets/pie_chart.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stats',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              ),
            ),
            SizedBox(height: 15),
           PieChartStat(),
            SizedBox(
              height: 12,
            ),
            TransactionsList()
          ],
        ),
      ),
    );
  }
}
