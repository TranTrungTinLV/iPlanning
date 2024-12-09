import 'package:flutter/material.dart';
import 'package:iplanning/models/categoryClass.dart';

class Dropdowncategories extends StatefulWidget {
  Dropdowncategories({
    super.key,
    required this.list,
    required this.onCategoryChanged,
    this.selectedCategory,
  });
  List<CategoryModel> list;
  final Function(CategoryModel) onCategoryChanged;
  final CategoryModel? selectedCategory;
  @override
  State<Dropdowncategories> createState() => _DropdowncategoriesState();
}

class _DropdowncategoriesState extends State<Dropdowncategories> {
  CategoryModel? dropValue;

  @override
  void initState() {
    super.initState();

    dropValue = widget.selectedCategory != null
        ? widget.list.firstWhere(
            (category) =>
                category.category_id == widget.selectedCategory!.category_id,
            orElse: () => widget.list.isNotEmpty
                ? widget.list.first
                : CategoryModel(
                    category_id: '', name: 'Không rõ', event_ids: []),
          )
        : (widget.list.isNotEmpty ? widget.list.first : null);
  }

  @override
  void didUpdateWidget(covariant Dropdowncategories oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      setState(() {
        dropValue = widget.selectedCategory != null
            ? widget.list.firstWhere(
                (category) =>
                    category.category_id ==
                    widget.selectedCategory!.category_id,
                orElse: () => widget.list.isNotEmpty
                    ? widget.list.first
                    : CategoryModel(
                        category_id: '', name: 'Không rõ', event_ids: []),
              )
            : (widget.list.isNotEmpty ? widget.list.first : null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Categories List: ${widget.list.map((e) => e.name).toList()}');
    print('Selected Category: ${dropValue?.name}');
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
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
          if (value != null) {
            widget
                .onCategoryChanged(value); // Gọi callback khi giá trị thay đổi
          }
        },
        items: widget.list.isNotEmpty
            ? widget.list
                .map<DropdownMenuItem<CategoryModel>>((CategoryModel value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.name),
                );
              }).toList()
            : [
                DropdownMenuItem(
                  value: null,
                  child: Text("Không có danh mục"),
                ),
              ],
      ),
    );
  }
}
