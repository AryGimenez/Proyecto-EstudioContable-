import 'package:flutter/material.dart';
import 'main_handler.dart';
import 'main_styles.dart';

class ClientsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Clientes', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(icon: Icon(Icons.search, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list, color: AppColors.textPrimary), onPressed: () {}),
        ],
      ),
      drawer: buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildSearchBar(),
            Expanded(child: buildClientTable()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}