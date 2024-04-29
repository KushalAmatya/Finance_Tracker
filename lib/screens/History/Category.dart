import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Category extends StatefulWidget {
  const Category({super.key, required this.onChanged});

  final ValueChanged<String?> onChanged;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String currentcategory = "";
  final scrollController = ScrollController();
  final List<String> _item = [
    "All",
    "Food",
    "Entertainment",
    "Rent",
    "Transportation",
    "Education",
    "Health",
    "Others",
    "Salary",
    "Bonus",
    "Interest",
  ];
  @override
  void initState() {
    // TODO: implement initState
    currentcategory = "All";
    scrollSeclectedCategory();
    super.initState();
  }

  scrollSeclectedCategory() {
    final selectedcategoryindex = _item.indexOf(currentcategory);
    if (selectedcategoryindex != -1) {
      final scrollOffset = (selectedcategoryindex * 100.00) - 170;
      scrollController.animateTo(scrollOffset,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
          controller: scrollController,
          itemCount: _item.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentcategory = _item[index];
                  widget.onChanged(_item[index]);
                  scrollSeclectedCategory();
                });
              },
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.all(8),
                child: Center(child: Text(_item[index])),
                decoration: BoxDecoration(
                  color: currentcategory == _item[index]
                      ? Colors.greenAccent
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }),
    );
  }
}
