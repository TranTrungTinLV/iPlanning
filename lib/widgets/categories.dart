import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/services/categories.service.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';
import 'package:iplanning/widgets/categoriesUI.dart';
import 'package:uuid/uuid.dart';

class CategoriesSection extends StatefulWidget {
  CategoriesSection(
      {super.key,
      required this.categories,
      required this.onCategorySelected,
      required this.onAllEvents});
  List<CategoryModel> categories;
  final Function(String) onCategorySelected;
  final Function() onAllEvents;

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  TextEditingController categoryNameController = TextEditingController();

  void _saveCategory(String name, Color color) async {
    String result = await CategoriesMethod().createCategory(
      name: name,
      color: color,
    );

    if (result == 'successfully') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Danh mục đã được tạo thành công!')),
      );

      CategoryModel newCategory = CategoryModel(
        createAt: Timestamp.now(),
        category_id: const Uuid().v4().split('-')[0],
        name: name,
        color: color.value,
        event_ids: [],
      );
      setState(() {
        widget.categories.add(newCategory);
      });
      categoryNameController.clear();
      currentColor = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    sheetAnimationStyle:
                        AnimationStyle(duration: Duration(milliseconds: 1000)),
                    builder: (ctx) {
                      return StatefulBuilder(builder: (context, setStateModal) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldCustom(
                                title: 'Tên Danh Mục',
                                controller: categoryNameController,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await showPicker(setStateModal);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      currentColor == null
                                          ? "Chọn Màu Danh Mục"
                                          : "${currentColor!.value.toRadixString(16).toUpperCase()}",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03),
                                    ),
                                  ),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.black54,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (categoryNameController.text.length >
                                          13) {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Tên danh mục không được vượt quá 12 ký tự.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        return; // Không đóng BottomSheet
                                      }
                                      if (categoryNameController
                                              .text.isNotEmpty &&
                                          currentColor != null) {
                                        _saveCategory(
                                          categoryNameController.text,
                                          currentColor!,
                                        );
                                        Navigator.of(context).pop();
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Vui lòng nhập thông tin",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff3D56F0),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Center(
                                          child: Text(
                                        'Tạo danh mục',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    });
              },
              child: CategoriesUI(
                titleCate: 'Thêm danh mục',
                colour: Colors.white,
                textColour: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: widget.onAllEvents,
              child: CategoriesUI(
                titleCate: 'All',
                colour: Colors.red,
              ),
            ),
            (widget.categories != null || widget.categories.isEmpty)
                ? Row(
                    children: widget.categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          widget.onCategorySelected(category.category_id);
                        },
                        child: CategoriesUI(
                          titleCate: category.name,
                          colour: category.color != null
                              ? Color(category.color!)
                              : Colors.grey,
                        ),
                      );
                    }).toList(),
                  )
                : Container(),
          ],
        ));
  }

  Color pickerColor = Color(0xff443a49);
  Color? currentColor;
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future showPicker(Function setStateModal) {
    return showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) {
              setState(() => pickerColor = color);
              setStateModal(() => pickerColor = color);
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() {
                currentColor = pickerColor;
              });
              setStateModal(() {
                currentColor = pickerColor;
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      context: context,
    );
  }
}
