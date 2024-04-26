import 'package:finance_tracker/screens/Addbudget.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budgets'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Periodic'),
            Tab(text: 'One-time'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Periodic Tab Content
          Center(
            child: Text('Periodic Tab Content'),
          ),
          // One-time Tab Content
          Center(
            child: Text('One-time Tab Content'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBudgetPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: BudgetScreen(),
  ));
}
