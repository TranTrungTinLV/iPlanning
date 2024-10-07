import 'package:flutter/material.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/widgets/categoriesUI.dart';

class CategoriesSection extends StatelessWidget {
  CategoriesSection({super.key, required this.categories});
  List<CategoryModel> categories;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: (categories != null || categories.isEmpty)
          ? Row(
              children: categories.map((category) {
                return CategoriesUI(
                  titleCate: category.name,
                  colour: Colors.red,
                );
              }).toList(),
            )
          : Container(),
    );
  }
}
