import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String)? onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: cat == selectedCategory,
                  selectedColor: Colors.red,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: cat == selectedCategory ? Colors.white : Colors.black,
                  ),
                  onSelected: onCategorySelected != null
                      ? (selected) {
                          if (selected) {
                            onCategorySelected!(cat);
                          }
                        }
                      : null,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}