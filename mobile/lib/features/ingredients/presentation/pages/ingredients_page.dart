import 'package:flutter/material.dart';

import '../widgets/add_ingredient_sheet.dart';
import '../widgets/ingredient_card.dart';
import '../../domain/ingredient_item.dart';

class IngredientsPage extends StatelessWidget {
  const IngredientsPage({super.key});

  static const _mockIngredients = [
    IngredientItem(
      name: 'Чеснок',
      type: IngredientType.vegetable,
      amount: 3,
    ),
    IngredientItem(
      name: 'Паприка',
      type: IngredientType.spice,
      status: IngredientStockStatus.medium,
    ),
    IngredientItem(
      name: 'Куриная грудка',
      type: IngredientType.meat,
      status: IngredientStockStatus.few,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ингредиенты'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _mockIngredients.length,
        itemBuilder: (context, index) {
          return IngredientCard(item: _mockIngredients[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddIngredientSheet(),
          );
        },
        tooltip: 'Добавить ингредиент',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
