import 'package:flutter/material.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/features/tables/stores/tables_store.dart';
import 'package:teste_flutter/features/tables/widgets/tables_header.widget.dart';
import 'package:teste_flutter/features/tables/widgets/tables_list.widget.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    TablesStore tablesStore = TablesStore();
    CustomersStore customersStore = CustomersStore();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TablesHeader(
          tablesStore: tablesStore,
          customersStore: customersStore,
        ),
        const Divider(),
        TablesList(
          tablesStore: tablesStore,
          customersStore: customersStore,
        ),
      ],
    );
  }
}
