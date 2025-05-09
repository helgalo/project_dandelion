import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/features/tables/stores/tables_store.dart';
import 'package:teste_flutter/features/tables/widgets/create_or_edit_table_modal.dart';
import 'package:teste_flutter/features/customers/widgets/customers_counter.widget.dart';
import 'package:teste_flutter/shared/widgets/search_input.widget.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

class TablesHeader extends StatelessWidget {
  final TablesStore tablesStore;
  final CustomersStore customersStore;
  const TablesHeader({
    super.key,
    required this.tablesStore,
    required this.customersStore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Text(
              'Mesas',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(width: 20),
            Observer(
              builder: (context) {
                return SearchInput(
                  onChanged: (value) {
                    tablesStore.searchTables(value ?? '');
                  },
                );
              },
            ),
            const SizedBox(width: 20),
            Observer(
              builder: (context) {
                return CustomersCounter(
                  label: customersStore.customers.length.toString(),
                );
              },
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: CreateOrEditTableModal(
                        tablesStore: tablesStore,
                        customersStore: customersStore,
                      ),
                    );
                  },
                );
              },
              tooltip: 'Criar nova mesa',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
