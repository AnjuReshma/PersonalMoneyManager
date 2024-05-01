import 'package:flutter/material.dart';
import 'package:personalmoneymanagement/db/category/category_db.dart';
import 'package:personalmoneymanagement/models/category/category_model.dart';
import 'package:personalmoneymanagement/screens/add_transaction/screen_add_transaction.dart';
import 'package:personalmoneymanagement/screens/category/category_add_popup.dart';
import 'package:personalmoneymanagement/screens/category/screen_category.dart';
import 'package:personalmoneymanagement/screens/home/widgets/bottom_navigation.dart';
import 'package:personalmoneymanagement/screens/transactions/screen_transactions.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = const [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "MONEY MANAGER",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, Widget? child) {
          return _pages[updatedIndex];
        },
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print("Add transaction");
            Navigator.pushNamed(context, ScreenaddTransaction.routeName);
          } else {
            print("Add category");
            showCategoryAddPopup(context);
            // final _sample=CategoryModel(
            //     id: DateTime.now().millisecondsSinceEpoch.toString(),
            //     name: 'Travel',
            //     type: CategoryType.expense);
            // CategoryDB().insertCategory(_sample);
          }
        },
      ),
    );
  }
}
