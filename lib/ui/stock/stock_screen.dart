import 'package:flutter/material.dart';

import 'ingredient/ingredient_screen.dart';
import 'widgets/stock_body.dart';

class StockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('庫存'),
          actions: [
            TextButton(
              onPressed: () => print('hi'),
              child: Text('設定份量'),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => IngredientScreen(),
            ),
          ),
          tooltip: '新增成份',
          child: Icon(Icons.add),
        ),
        body: WillPopScope(
          onWillPop: () async => false,
          child: StockBody(),
        ),
      ),
    );
  }
}
