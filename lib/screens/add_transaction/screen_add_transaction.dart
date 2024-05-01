import 'package:flutter/material.dart';
import 'package:personalmoneymanagement/db/category/category_db.dart';
import 'package:personalmoneymanagement/db/transactions/transaction_db.dart';
import 'package:personalmoneymanagement/models/category/category_model.dart';
import 'package:personalmoneymanagement/models/transactions/transaction_model.dart';

class ScreenaddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenaddTransaction({super.key});

  @override
  State<ScreenaddTransaction> createState() => _ScreenaddTransactionState();
}

class _ScreenaddTransactionState extends State<ScreenaddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;
  String? _categoryID;

  final _purposeTextEditingController=TextEditingController();
  final _amountTextEditingController=TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  /*
   Purpose
   Date
   Amount
   Income/Expense
   CategoryType
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //purpose
              TextFormField(
                controller: _purposeTextEditingController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: 'Purpose'),
              ),
              //amount
              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Amount'),
              ),
              //Calender

              TextButton.icon(
                  onPressed: () async {
                    final _selectedDateTemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 30)),
                        lastDate: DateTime.now());

                    if (_selectedDateTemp == null) {
                      return;
                    } else {
                      print(_selectedDateTemp.toString());
                      setState(() {
                        _selectedDate = _selectedDateTemp;
                      });
                    }
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text(_selectedDate == null
                      ? "Select Date"
                      : _selectedDate.toString())),

              //Category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                          value: CategoryType.income,
                          groupValue: _selectedCategorytype,
                          onChanged: (newvalue) {
                            setState(() {
                              _selectedCategorytype = CategoryType.income;
                              _categoryID=null;
                            });
                          }),
                      Text("Income")
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: CategoryType.expense,
                          groupValue: _selectedCategorytype,
                          onChanged: (newvalue) {
                            setState(() {
                              _selectedCategorytype = CategoryType.expense;
                              _categoryID=null;
                            });
                          }),
                      Text("Expense")
                    ],
                  ),
                ],
              ),
              //Category Type
              DropdownButton(
                  hint: Text("Select Category"),
                  value: _categoryID,
                  items: (_selectedCategorytype == CategoryType.income
                          ? CategoryDB().incomeCategoryListListener
                          : CategoryDB().expenseCategoryListListener)
                      .value
                      .map((e) {
                    return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                        onTap: (){
                          _selectedCategoryModel=e;
                        },
                    );
                  }).toList(),
                  onChanged: (selectedValue) {
                    print(selectedValue);
                    setState(() {
                      _categoryID=selectedValue;
                    });
                  },
              ),
              //submit
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed: () {
                    addTransaction();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async{
    final _purposeText=_purposeTextEditingController.text;
    final _amountText=_amountTextEditingController.text;
    if(_purposeText.isEmpty){
      return;
    }
    if(_amountText.isEmpty){
      return;
    }
    // if(_categoryID==null){
    //   return;
    // }
    if(_selectedDate==null){
      return;
    }
    if(_selectedCategoryModel==null){
      return;
    }

   final _parsedAmount= double.tryParse(_amountText);
    if(_parsedAmount==null){
      return;
    }
    //_selectedDate
   // _selectedCategorytype
    //_categoryID

   final _model= TransactionModel(
        purpose:_purposeText ,
        amount: _parsedAmount,
        date: _selectedDate!,
        type: _selectedCategorytype!,
        category: _selectedCategoryModel!);
    await TransactionDB.instance.addTransaction(_model);
    Navigator.pop(context);
    TransactionDB.instance.refresh();
  }
}
