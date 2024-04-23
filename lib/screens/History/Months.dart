import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Months extends StatefulWidget {
  const Months({super.key, required this.onChanged});

  final ValueChanged<String?> onChanged;

  @override
  State<Months> createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  String currentmonth = "";
  List<String> months = [];
  final scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime currentdate = DateTime.now();
    for (int i = -23; i <= 0; i++) {
      months.add(DateFormat("MMM y")
          .format(DateTime(currentdate.year, currentdate.month + i, 1)));
    }
    currentmonth = DateFormat("MMM y").format(currentdate);
    Future.delayed(Duration(seconds: 1), () {
      scrollSeclectedMonth();
    });
  }

  scrollSeclectedMonth() {
    final selectedmonthindex = months.indexOf(currentmonth);
    if (selectedmonthindex != -1) {
      final scrollOffset = (selectedmonthindex * 100.00) - 170;
      scrollController.animateTo(scrollOffset,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
          controller: scrollController,
          itemCount: months.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentmonth = months[index];
                  widget.onChanged(months[index]);
                });
                scrollSeclectedMonth();
              },
              child: Container(
                width: 80,
                margin: EdgeInsets.all(8),
                child: Center(child: Text(months[index])),
                decoration: BoxDecoration(
                  color: currentmonth == months[index]
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
