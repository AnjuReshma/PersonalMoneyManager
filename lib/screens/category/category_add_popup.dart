import 'package:flutter/material.dart';
import 'package:personalmoneymanagement/db/category/category_db.dart';
import 'package:personalmoneymanagement/models/category/category_model.dart';


ValueNotifier<CategoryType> selectedCategoryNotifier=ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  TextEditingController _nameEditingController=TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: Text("Add Category"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameEditingController,
              decoration: InputDecoration(
                  hintText: "Category Name",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,width: 5.0))),
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                RadioButton(title: "Income", type: CategoryType.income),
                RadioButton(title: "Expense", type: CategoryType.expense)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () {
                final _name=_nameEditingController.text.trim();
                if(_name.isEmpty){
                  return;
                }
                final _type=selectedCategoryNotifier.value;
              final _category=  CategoryModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: _name, type: _type);
              CategoryDB.instance.insertCategory(_category);
              Navigator.of(ctx).pop();
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      );
    },
  );
}
class RadioButton extends StatelessWidget{
  final String title;
  final CategoryType type;



   RadioButton({super.key,
    required this.title,
    required this.type
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                value: type,
                groupValue:newCategory ,
                onChanged: (value){
                  if(value==null){
                    return;
                  }
                  selectedCategoryNotifier.value=value;
                  selectedCategoryNotifier.notifyListeners();
                },);
            },),
        Text(title)
      ],
    );
  }
}
