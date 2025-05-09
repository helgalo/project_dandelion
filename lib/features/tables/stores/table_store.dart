import 'package:mobx/mobx.dart';
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';
import 'package:teste_flutter/features/tables/entities/table.entity.dart';

part 'table_store.g.dart';

class TableStore = _TableStoreBase with _$TableStore;

abstract class _TableStoreBase with Store {
  _TableStoreBase({required this.tableEntity});

  @observable
  TableEntity tableEntity;

  @computed
  int get totalCustomers => tableEntity.customers.length;

  @action
  void updateCustomers(List<CustomerEntity> newCustomers) {
    tableEntity = tableEntity.copyWith(customers: newCustomers);
  }

  @action
  void updateIdentification(String newIdentification) {
    tableEntity = tableEntity.copyWith(identification: newIdentification);
  }

  @action
  void addCustomer(CustomerEntity newCustomer) {
    tableEntity = tableEntity.copyWith(
      customers: [...tableEntity.customers, newCustomer],
    );
  }

  @action
  void removeCustomer(int index) {
    if (index >= 0 && index < tableEntity.customers.length) {
      tableEntity = tableEntity.copyWith(
        customers: [
          ...tableEntity.customers.sublist(0, index),
          ...tableEntity.customers.sublist(index + 1),
        ],
      );
    }
  }
}
