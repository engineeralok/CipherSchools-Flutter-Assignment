import 'package:cipherschools_flutter_assignment/ui/budget.dart';
import 'package:cipherschools_flutter_assignment/wgt/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../prov/navigation.dart';
import '../ui/profile.dart';
import '../ui/statistics.dart';
import '../wgt/home.dart';
import '../wgt/add_transaction.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        final screens = [
          _buildHomeScreen(context),
          const StatisticsScreen(),
          const BudgetScreen(),
          const ProfileScreen(),
        ];
        return Scaffold(
          backgroundColor: const Color(0xFFF6F6F6),
          body: SafeArea(child: screens[navigationProvider.currentIndex]),
          bottomNavigationBar: const HomeBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder:
                    (context) => SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: const AddTransactionForm(),
                      ),
                    ),
              );
            },
            backgroundColor: Colors.purple,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    ).setCurrentIndex(2);
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                DropdownButton<String>(
                  value: 'October',
                  items:
                      ['October'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {},
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const BalanceCard(),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: IncomeCard()),
                SizedBox(width: 16),
                Expanded(child: ExpenseCard()),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transaction',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
          ),
          const Expanded(child: TransactionList()),
        ],
      ),
    );
  }
}
