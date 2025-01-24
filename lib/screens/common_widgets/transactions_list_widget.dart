import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wallet_tracker/blocs/navigation/navigation_cubit.dart';
import 'package:wallet_tracker/screens/home/blocs/get_expenses/get_expenses_cubit.dart';
import 'package:wallet_tracker/screens/home/blocs/get_incomes/get_incomes_cubit.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final aDate = DateTime(date.year, date.month, date.day);

    if (aDate == today) {
      return 'Today';
    } else if (aDate == yesterday) {
      return 'Yesterday';
    } else if (aDate.year == today.year) {
      return DateFormat('d MMMM').format(date);
    } else {
      return DateFormat('d/M/yyyy').format(date);
    }
  }

  Widget _transactionItem(dynamic transaction) {
    final bool isExpense = transaction is Expense;
    final int amount = isExpense ? transaction.amount : transaction.amount;
    final String name = isExpense ? transaction.category.name : transaction.name;
    final int color = isExpense ? transaction.category.color : 0xFFFFFFFF;
    final String icon = isExpense ? transaction.category.icon : "income.png";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            // Category Icon with Gradient Background
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(color).withOpacity(0.7),
                    Color(color),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(color).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/$icon',
                  color: isExpense
                      ? (Color(color).computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white)
                      : null,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Transaction Name
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 10),

            // Amount and Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isExpense ? '-' : '+'} \$$amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isExpense ? Colors.redAccent : Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.date),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesCubit, GetExpensesState>(
      builder: (context, expensesState) {
        return BlocBuilder<GetIncomesCubit, GetIncomesState>(
          builder: (context, incomesState) {
            if (expensesState is GetExpensesSuccess &&
                incomesState is GetIncomesSuccess) {
              List<dynamic> items = [
                ...expensesState.expenses,
                ...incomesState.incomes
              ];

              items.sort((a, b) => b.date.compareTo(a.date));

              return Expanded(
                child: BlocBuilder<NavigationCubit, NavigationState>(
                  builder: (context, state) {
                    if (state.selectedIndex == 0) {
                      if (items.length > 4) {
                        items = items.sublist(0, 4);
                      }
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.selectedIndex == 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recent Transactions',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<NavigationCubit>()
                                        .setSelectedIndex(1);
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: items.length,
                            itemBuilder: (context, int i) {
                              return _transactionItem(items[i]);
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }
          },
        );
      },
    );
  }
}
