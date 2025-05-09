import 'package:mobx/mobx.dart';
import 'package:teste_flutter/features/tables/entities/table.entity.dart';

part 'tables_store.g.dart';

class TablesStore = _TablesStoreBase with _$TablesStore;

abstract class _TablesStoreBase with Store {
  @observable
  ObservableList<TableEntity> tables = ObservableList<TableEntity>();

  @observable
  ObservableList<TableEntity> searchedTables = ObservableList<TableEntity>();

  @observable
  String currentSearchTerm = '';

  @action
  void addTable(TableEntity table) {
    tables.add(table);
  }

  @action
  void editTable(int id, TableEntity updatedTable) {
    final index = tables.indexWhere((table) => table.id == id);
    if (index != -1) {
      tables[index] = updatedTable;
    }
  }

  @action
  void removeTable(int index) {
    if (index >= 0 && index < tables.length) {
      tables.removeAt(index);
    }
  }

  @action
  void searchTables(String searchTerm) {
    currentSearchTerm = searchTerm;
    final lowerCaseTerm = searchTerm.toLowerCase();
    searchedTables = ObservableList.of(
      tables.where(
        (table) {
          final matchesIdentifier =
              table.identification.toLowerCase().contains(lowerCaseTerm);
          final matchesCustomer = table.customers.any((customer) =>
              customer.name.toLowerCase().contains(lowerCaseTerm) ||
              customer.phone.toLowerCase().contains(lowerCaseTerm));
          return matchesIdentifier || matchesCustomer;
        },
      ),
    );
  }
}
