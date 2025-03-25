import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../prov/transaction.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Statistics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            final categoryTotals = provider.getCategoryTotals();
            final totalAmount = categoryTotals.values.fold(
              0.0,
              (a, b) => a + b,
            );

            if (categoryTotals.isEmpty) {
              return const Center(child: Text('No transactions yet'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Container(
                    height: 200,
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    child: PieChart(
                      PieChartData(
                        sections:
                            categoryTotals.entries.map((entry) {
                              final category = entry.key;
                              final amount = entry.value;
                              final percentage = (amount / totalAmount) * 100;

                              return PieChartSectionData(
                                color: _getCategoryColor(category),
                                value: amount,
                                title: '${percentage.toStringAsFixed(1)}%',
                                radius: 80,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Expense by Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryTotals.length,
                    itemBuilder: (context, index) {
                      final category = categoryTotals.keys.elementAt(index);
                      final amount = categoryTotals[category]!;
                      final percentage = (amount / totalAmount) * 100;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getCategoryColor(category),
                          child: Icon(
                            _getCategoryIcon(category),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(category),
                        subtitle: Text('₹${amount.toStringAsFixed(2)}'),
                        trailing: Text('${percentage.toStringAsFixed(1)}%'),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.red;
      case 'Shopping':
        return Colors.orange;
      case 'Travel':
        return Colors.blue;
      case 'Subscription':
        return Color(0xFF7E3DFF);
      case 'Entertainment':
        return Colors.pink;
      case 'Bills':
        return Colors.green;
      case 'Salary':
        return Colors.indigo;
      case 'Investment':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Travel':
        return Icons.directions_car;
      case 'Subscription':
        return Icons.subscriptions;
      case 'Entertainment':
        return Icons.movie;
      case 'Bills':
        return Icons.receipt;
      case 'Salary':
        return Icons.work;
      case 'Investment':
        return Icons.trending_up;
      default:
        return Icons.more_horiz;
    }
  }
}
