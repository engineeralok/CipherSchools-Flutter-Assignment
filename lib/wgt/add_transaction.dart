import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:cipherschools_flutter_assignment/models/category_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../prov/transaction.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _amountController = TextEditingController();
  String _type = 'expense';
  String _category = 'Food';
  bool get _isIncome => _type == 'income';

  final Map<String, CategoryIcon> _categoryIcons = {
    'Food': CategoryIcon(imagePath: Assets.foodIcon.path, icon: Icons.fastfood),
    'Shopping': CategoryIcon(
      imagePath: Assets.shoppingIcon.path,
      icon: Icons.shopping_bag,
    ),
    'Travel': CategoryIcon(
      imagePath: Assets.travelIcon.path,
      icon: Icons.directions_car,
    ),
    'Subscription': CategoryIcon(
      imagePath: Assets.subscriptionIcon.path,
      icon: Icons.subscriptions,
    ),
    'Entertainment': CategoryIcon(icon: Icons.movie),
    'Bills': CategoryIcon(icon: Icons.receipt),
    'Salary': CategoryIcon(icon: Icons.work),
    'Investment': CategoryIcon(icon: Icons.trending_up),
    'Other': CategoryIcon(icon: Icons.more_horiz),
  };

  final Map<String, Color> categoryColors = {
    'Food': Colors.red,
    'Shopping': Colors.orange,
    'Travel': Colors.blue,
    'Subscription': Color(0xFF7E3DFF),
    'Entertainment': Colors.pink,
    'Bills': Colors.green,
    'Salary': Colors.indigo,
    'Investment': Colors.teal,
    'Other': Colors.grey,
  };

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        amount: double.parse(_amountController.text) * (_isIncome ? 1 : -1),
        type: _type,
        category: _category,
        icon: _categoryIcons[_category]!,
        iconBackgroundColor: categoryColors[_category]!,
        timestamp: DateTime.now(),
      );

      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(transaction);

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(children: [_buildHeader(), _buildForm()]),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              _isIncome
                  ? [Color(0xFF7E3DFF), Colors.deepPurple]
                  : [Color(0xFF0077FF), Colors.blue[500]!],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SegmentedButton<String>(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),

              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            segments: const [
              ButtonSegment(
                value: 'expense',
                label: Text(
                  'Expense',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ButtonSegment(
                value: 'income',
                label: Text(
                  'Income',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _type = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 16),
          Text(
            '₹${_amountController.text.isEmpty ? '0' : _amountController.text}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCategoryDropdown(),
              const SizedBox(height: 16),

              _buildTextField(_titleController, 'Title'),
              const SizedBox(height: 16),
              _buildTextField(_subtitleController, 'Description'),
              const SizedBox(height: 16),
              _buildTextField(
                _amountController,
                '₹ Amount',
                TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7E3DFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, [
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
  ]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixText: prefixText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        if (keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      decoration: InputDecoration(
        labelText: 'Category',
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          _categoryIcons.keys.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  _categoryIcons[value]!.build(color: categoryColors[value]),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _category = newValue;
          });
        }
      },
    );
  }
}
