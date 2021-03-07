import 'package:flutter/widgets.dart';
import 'package:possystem/services/database.dart';

import 'catalog_model.dart';

class MenuModel extends ChangeNotifier {
  MenuModel() {
    loadFromDb();
  }

  Map<String, CatalogModel> catalogs;

  // I/O

  Future<void> loadFromDb() async {
    var snapshot = await Database.service.get(Collections.menu);
    // TODO: handle exception
    catalogs = {};
    buildFromMap(snapshot.data());

    notifyListeners();
  }

  void buildFromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    try {
      data.forEach((key, value) {
        if (value is Map) {
          catalogs[key] = CatalogModel.fromMap(key, value);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Map<String, Map<String, dynamic>> toMap() {
    return {for (var entry in catalogs.entries) entry.key: entry.value.toMap()};
  }

  // STATE CHANGER

  Future<void> add(CatalogModel catalog) async {
    await Database.service.update(Collections.menu, {
      catalog.name: catalog.toMap(),
    });

    catalogs[catalog.name] = catalog;
    notifyListeners();
  }

  // SETTER

  Future<void> changeCatalog({String oldName, String newName}) async {
    if (oldName != newName) {
      catalogs[newName] = catalogs[oldName];
      catalogs.remove(oldName);
    }

    notifyListeners();
  }

  // HELPER

  bool has(String key) {
    return catalogs.containsKey(key);
  }

  // GETTER

  CatalogModel operator [](String name) {
    return catalogs[name];
  }

  List<CatalogModel> get catalogList {
    final catalogList = catalogs.values.toList();
    catalogList.sort((a, b) => a.index.compareTo(b.index));
    return catalogList;
  }

  bool get isNotReady => catalogs == null;

  int get length => catalogs.length;
}
