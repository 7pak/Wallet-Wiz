import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallet_tracker/screens/home/blocs/get_expenses/get_expenses_cubit.dart';
import 'package:wallet_tracker/screens/home/blocs/get_incomes/get_incomes_cubit.dart';

import 'package:intl/intl.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var expenses = context.select((GetExpensesCubit bloc) => bloc.state);
      var incomes = context.select((GetIncomesCubit bloc) => bloc.state);

      int totalExpense = _calculateTotal(expenses, isExpense: true);
      int totalIncome = _calculateTotal(incomes, isExpense: false);
      int totalBalance = totalIncome - totalExpense;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: _buildCardDecoration(context),
        child: _buildCardContent(context, totalBalance, totalIncome, totalExpense),
      );
    });
  }

  int _calculateTotal<T>(dynamic state, {required bool isExpense}) {
    DateTime today = DateTime.now();

    if ((isExpense && state is GetExpensesSuccess) ||
        (!isExpense && state is GetIncomesSuccess)) {
      final List<dynamic> items = isExpense
          ? (state as GetExpensesSuccess).expenses
          : (state as GetIncomesSuccess).incomes;

      if (items.isNotEmpty) {
        return items
            .where((element) =>
        element.date.isBefore(today) ||
            element.date.isAtSameMomentAs(today))
            .map((element) => element.amount)
            .reduce((a, b) => a + b);
      }
    }
    return 0;
  }

  BoxDecoration _buildCardDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.tertiary,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: const GradientRotation(pi / 4),
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildCardContent(
      BuildContext context,
      int totalBalance,
      int totalIncome,
      int totalExpense
      ) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            currencyFormat.format(totalBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWalletDetail(
                icon: FontAwesomeIcons.arrowUpLong,
                iconColor: Colors.green.shade300,
                title: 'Income',
                detail: currencyFormat.format(totalIncome),
              ),
              _buildWalletDetail(
                icon: FontAwesomeIcons.arrowDownLong,
                iconColor: Colors.red.shade300,
                title: 'Expenses',
                detail: currencyFormat.format(totalExpense),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletDetail({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String detail,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}