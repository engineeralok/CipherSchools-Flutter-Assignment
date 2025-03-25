import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:cipherschools_flutter_assignment/ui/budget.dart';
import 'package:cipherschools_flutter_assignment/wgt/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_icon_widget/svg_icon_widget.dart';
import '../prov/navigation.dart';
import '../prov/home_screen.dart';
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
            backgroundColor: Color(0xFF7E3DFF),
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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.53, 0.07),
                end: Alignment(0.48, 1.30),
                colors: [Color.fromARGB(255, 252, 241, 220), Color(0x00F7ECD7)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                          ).setCurrentIndex(3);
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF7E3DFF),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),

                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDatePickerMode: DatePickerMode.day,
                          );
                          if (picked != null && context.mounted) {
                            Provider.of<HomeScreenProvider>(
                              context,
                              listen: false,
                            ).setSelectedMonth(picked);
                          }
                        },
                        child: Row(
                          children: [
                            SvgIcon(SvgIconData(SvgAssets.downArrowIcon.path)),
                            const SizedBox(width: 8),
                            Consumer<HomeScreenProvider>(
                              builder: (context, provider, child) {
                                final now =
                                    provider.selectedMonth ?? DateTime.now();
                                return Text(
                                  '${now.day} ${provider.getMonthName(now.month)} ${now.year}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: SvgIcon(
                          SvgIconData(SvgAssets.notificationIcon.path),
                          color: const Color(0xFF7E3DFF),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const BalanceCard(),
                const SizedBox(height: 27),
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
                const SizedBox(height: 23),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          const TransactionFilterTabs(),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transaction',
                  style: TextStyle(
                    color: Color(0xFF292B2D),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 78,
                  height: 32,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      backgroundColor: Color(0xFFEEE5FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFF7E3DFF),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: TransactionList()),
        ],
      ),
    );
  }
}
