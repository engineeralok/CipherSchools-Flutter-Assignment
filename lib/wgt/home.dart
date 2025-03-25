import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:cipherschools_flutter_assignment/models/category_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../prov/transaction.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Account Balance',
          style: TextStyle(
            color: const Color(0xFF90909F),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Consumer<TransactionProvider>(
          builder:
              (context, provider, child) => Text(
                provider.balance < 0
                    ? '-₹${provider.balance.abs().toStringAsFixed(2)}'
                    : '₹${provider.balance.toStringAsFixed(2)}',
                style: TextStyle(
                  color:
                      provider.balance < 0
                          ? Color(0xFFFD3C4A)
                          : Color(0xFF161719),
                  fontSize: 40,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      ],
    );
  }
}

class IncomeCard extends StatelessWidget {
  const IncomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF00A86B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(Assets.incomeIcon.path),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Income',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Consumer<TransactionProvider>(
                  builder:
                      (context, provider, child) => Text(
                        '₹${provider.totalIncome.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFD3C4A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(Assets.expenseIcon.path, width: 40, height: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Expenses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<TransactionProvider>(
                  builder:
                      (context, provider, child) => Text(
                        '₹${provider.totalExpense.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionFilterTabs extends StatelessWidget {
  const TransactionFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final filters = ['Today', 'Week', 'Month', 'Year'];
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                filters.map((filter) {
                  final isSelected = provider.selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () => provider.setFilter(filter),
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFFFCEED4)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFFFCB64F)
                                    : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? const Color(0xFFFCAC12)
                                    : const Color(0xFF90909F),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        if (provider.transactions.isEmpty) {
          return const Center(
            child: Text(
              'No transactions for this period',
              style: TextStyle(fontSize: 16, color: Color(0xFF91919F)),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.transactions.length,
          itemBuilder: (context, index) {
            final transaction = provider.transactions[index];
            return Dismissible(
              key: Key(transaction.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                provider.deleteTransaction(transaction);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${transaction.title} deleted')),
                );
              },
              child: TransactionItem(
                icon: transaction.icon,
                title: transaction.title,
                subtitle: transaction.subtitle,
                amount: transaction.amount,
                time:
                    '${transaction.timestamp.hour}:${transaction.timestamp.minute.toString().padLeft(2, '0')}',
                iconBackgroundColor: transaction.iconBackgroundColor,
              ),
            );
          },
        );
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  final CategoryIcon icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final double amount;
  final String time;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          icon.imagePath != null
              ? Image.asset(icon.imagePath!)
              : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: iconBackgroundColor.withAlpha(50),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon.icon, color: iconBackgroundColor, size: 40),
              ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF292B2D),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: const Color(0xFF90909F),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount < 0
                    ? '-₹${amount.abs().toStringAsFixed(2)}'
                    : '+₹${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: amount < 0 ? Color(0xFFFD3C4A) : Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: const Color(0xFF90909F),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
