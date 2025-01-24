import 'package:expense_repository/expense_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_tracker/screens/add_expense/blocs/get_categories/get_categories_cubit.dart';

import 'indicator.dart';
class PieChartStat extends StatefulWidget {
  const PieChartStat({super.key});

  @override
  State<StatefulWidget> createState() => _PieChartStatState();
}

class _PieChartStatState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: BlocProvider(
        create: (context) => GetCategoriesCubit(FirebaseExpenseRepo())..getCategories(),
        child: BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
          builder: (context, state) {
            if (state is GetCategoriesFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            if (state is GetCategoriesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }

            List<Category> categories = state is GetCategoriesSuccess
                ? state.categories
                : [];

            return categories.isNotEmpty
                ? Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 3,
                          centerSpaceRadius: 40,
                          sections: _showingSections(categories),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(categories.length, (index) {
                        Category category = categories[index];
                        return Indicator(
                          color: Color(category.color),
                          text: category.name,
                          isSquare: false,
                          size: 12,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            )
                : Center(
              child: Text(
                'No Expense Categories Yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(List<Category> categories) {
    const shadows = [Shadow(color: Colors.black26, blurRadius: 2)];

    if (categories.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey[300]!,
          value: 100,
          title: 'No Data',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        )
      ];
    }

    int totalExpenses = categories
        .map((category) => category.totalExpenses)
        .reduce((a, b) => a + b);

    return List.generate(categories.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 55.0 : 50.0;

      final category = categories[i];
      final percentage = (category.totalExpenses / totalExpenses) * 100;

      return PieChartSectionData(
        color: Color(category.color).withOpacity(0.8),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}