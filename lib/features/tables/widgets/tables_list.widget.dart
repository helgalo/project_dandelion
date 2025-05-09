import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/features/tables/stores/tables_store.dart';
import 'package:teste_flutter/features/tables/widgets/create_or_edit_table_modal.dart';
import 'package:teste_flutter/features/tables/widgets/table_card.widget.dart';

class TablesList extends StatelessWidget {
  final TablesStore tablesStore;
  final CustomersStore customersStore;
  TablesList({
    super.key,
    required this.tablesStore,
    required this.customersStore,
  });

  final tables = List.generate(10, (index) => index).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Observer(
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tablesStore.currentSearchTerm.isEmpty
                  ? tablesStore.tables
                      .map(
                        (table) => TableCard(
                          table: table,
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: CreateOrEditTableModal(
                                tablesStore: tablesStore,
                                customersStore: customersStore,
                                existingTable: table,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()
                  : tablesStore.searchedTables
                      .map(
                        (table) => TableCard(
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: CreateOrEditTableModal(
                                tablesStore: tablesStore,
                                customersStore: customersStore,
                                existingTable: table,
                              ),
                            ),
                          ),
                          table: table,
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
