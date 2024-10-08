import 'package:flutter/material.dart';
import 'package:iplanning/models/categoryClass.dart';

class Dropdowncategories extends StatefulWidget {
  Dropdowncategories(
      {super.key, required this.list, required this.onCategoryChanged});
  List<CategoryModel> list;
  final Function(CategoryModel) onCategoryChanged;
  @override
  State<Dropdowncategories> createState() => _DropdowncategoriesState();
}

class _DropdowncategoriesState extends State<Dropdowncategories> {
  CategoryModel? dropValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropValue = widget.list.isNotEmpty ? widget.list.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: MediaQuery.of(context).size.width,
      child: DropdownButton<CategoryModel>(
        dropdownColor: Colors.white,
        underline: SizedBox(),
        isExpanded: true,
        value: dropValue,
        onChanged: (CategoryModel? value) {
          setState(() {
            dropValue = value;
          });
          widget.onCategoryChanged(value!); // Gọi callback khi giá trị thay đổi
        },
        items: widget.list
            .map<DropdownMenuItem<CategoryModel>>((CategoryModel value) {
          return DropdownMenuItem(
              value: value, child: Text(value.name.toString()));
        }).toList(),
      ),
    );
  }
}
