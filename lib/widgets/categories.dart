import 'package:flutter/material.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/widgets/categoriesUI.dart';

class CategoriesSection extends StatelessWidget {
  CategoriesSection(
      {super.key,
      required this.categories,
      required this.onCategorySelected,
      required this.onAllEvents});
  List<CategoryModel> categories;
  final Function(String) onCategorySelected;
  final Function() onAllEvents;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: onAllEvents,
              child: CategoriesUI(
                titleCate: 'All',
                colour: Colors.red,
              ),
            ),
            (categories != null || categories.isEmpty)
                ? Row(
                    children: categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          onCategorySelected(category.category_id);
                        },
                        child: CategoriesUI(
                          titleCate: category.name,
                          colour: Colors.red,
                        ),
                      );
                    }).toList(),
                  )
                : Container(),
          ],
        ));
  }
}
