import 'package:flutter/material.dart';
import 'package:possystem/models/order/order_ingredient_model.dart';
import 'package:possystem/models/order/order_product_model.dart';
import 'package:possystem/models/repository/menu_model.dart';

class OrderMap {
  num paid;
  final num totalPrice;
  final int totalCount;
  final DateTime createdAt;
  final Iterable<OrderProductMap> products;

  OrderMap({
    this.paid,
    this.totalPrice,
    this.totalCount,
    this.products,
    DateTime createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  List<OrderProductModel> parseToProduct() {
    return products.map<OrderProductModel>((productMap) {
      final product = MenuModel.instance.getProduct(productMap.productId);
      if (product == null) return null;

      final ingredients = <OrderIngredientModel>[];
      for (var ingredientMap in productMap.ingredients.values) {
        if (ingredientMap.quantityId == null) continue;

        final ingredient = product[ingredientMap.ingredientId];

        ingredients.add(
          OrderIngredientModel(
            ingredient: ingredient,
            quantity: ingredient[ingredientMap.quantityId],
          ),
        );
      }

      return OrderProductModel(
        product,
        count: productMap.count,
        singlePrice: productMap.singlePrice,
        ingredients: ingredients,
      );
    }).toList();
  }

  Map<String, dynamic> output() {
    return {
      'paid': paid,
      'totalPrice': totalPrice,
      'totalCount': totalCount,
      'products': products.map((e) => e.output()).toList(),
    };
  }

  factory OrderMap.build(Map<String, dynamic> data) {
    if (data == null) return null;

    final List<Map<String, dynamic>> products = data['products'];

    return OrderMap(
      paid: data['paid'],
      totalPrice: data['totalPrice'],
      totalCount: data['totalCount'],
      products: products.map((product) => OrderProductMap.input(product)),
    );
  }
}

class OrderProductMap {
  final num singlePrice;
  final int count;
  final String productId;
  final String productName;
  final bool isDiscount;
  final Map<String, OrderIngredientMap> ingredients;

  OrderProductMap({
    @required this.singlePrice,
    @required this.count,
    @required this.productId,
    @required this.productName,
    @required this.isDiscount,
    @required this.ingredients,
  });

  Map<String, dynamic> output() {
    return {
      'singlePrice': singlePrice,
      'count': count,
      'productId': productId,
      'productName': productName,
      'isDiscount': isDiscount,
      'ingredients': ingredients.values.map((e) => e.output()),
    };
  }

  factory OrderProductMap.input(Map<String, dynamic> data) {
    return OrderProductMap(
      singlePrice: data['singlePrice'],
      count: data['count'],
      productId: data['productId'],
      productName: data['productName'],
      isDiscount: data['isDiscount'],
      ingredients: {
        for (var ingredient in data['ingredients'])
          ingredient['ingredientId']: OrderIngredientMap.input(ingredient)
      },
    );
  }
}

class OrderIngredientMap {
  final String name;
  final String ingredientId;
  int price;
  int amount;
  num cost;
  String quantityId;

  OrderIngredientMap({
    @required this.name,
    @required this.ingredientId,
    this.price,
    @required this.amount,
    @required this.cost,
    this.quantityId,
  });

  void update({
    @required price,
    @required amount,
    @required cost,
    @required quantityId,
  }) {
    this.price = price;
    this.amount = amount;
    this.cost = cost;
    this.quantityId = quantityId;
  }

  Map<String, dynamic> output() {
    return {
      'name': name,
      'ingredientId': ingredientId,
      'price': price,
      'amount': amount,
      'cost': cost,
      'quantityId': quantityId,
    };
  }

  factory OrderIngredientMap.input(Map<String, dynamic> data) {
    return OrderIngredientMap(
      name: data['name'],
      ingredientId: data['ingredientId'],
      price: data['price'],
      amount: data['amount'],
      cost: data['cost'],
      quantityId: data['quantityId'],
    );
  }
}
