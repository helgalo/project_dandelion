import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // Import necessário para Observer
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/features/tables/entities/table.entity.dart';
import 'package:teste_flutter/features/tables/stores/table_store.dart';
import 'package:teste_flutter/features/tables/stores/tables_store.dart';
import 'package:teste_flutter/features/customers/widgets/create_or_edit_customer_modal.dart';
import 'package:teste_flutter/features/customers/widgets/customer_tile_widget.dart';
import 'package:teste_flutter/shared/widgets/primary_button.widget.dart';
import 'package:teste_flutter/shared/widgets/secondary_button.widget.dart';

class CreateOrEditTableModal extends StatefulWidget {
  final TablesStore tablesStore;
  final CustomersStore customersStore;
  final TableEntity? existingTable;

  const CreateOrEditTableModal({
    Key? key,
    required this.tablesStore,
    required this.customersStore,
    this.existingTable,
  }) : super(key: key);

  @override
  _CreateOrEditTableModalState createState() => _CreateOrEditTableModalState();
}

class _CreateOrEditTableModalState extends State<CreateOrEditTableModal> {
  late TableStore temporalStore;
  final TextEditingController _tableNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late int _numberOfPeople;

  @override
  void initState() {
    super.initState();

    if (widget.existingTable != null) {
      temporalStore = TableStore(tableEntity: widget.existingTable!);
      _tableNameController.text = widget.existingTable!.identification;
      _numberOfPeople = widget.existingTable!.customers.length;
    } else {
      temporalStore = TableStore(
        tableEntity: TableEntity(
          id: -1,
          identification: '',
          customers: [],
        ),
      );
      _tableNameController.text = '';
      _numberOfPeople = 1;
      temporalStore.addCustomer(
        CustomerEntity(id: 0, name: "[Nome]", phone: "[telefone]"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTableNameField(),
            const SizedBox(height: 10),
            _buildTemporaryInfoText(),
            const SizedBox(height: 16),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildCustomerInfoSection(),
            const SizedBox(height: 20),
            _buildNumberOfPeopleRow(),
            const SizedBox(height: 16),
            _buildCustomerList(),
            _buildSearchAndButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      widget.existingTable != null
          ? 'Editar informações da ${widget.existingTable!.identification}'
          : 'Criar Nova Mesa',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTableNameField() {
    return TextField(
      controller: _tableNameController,
      decoration: const InputDecoration(
        labelText: 'Identificação da mesa',
        hintText: 'Mesa 1',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _buildTemporaryInfoText() {
    return const Text(
      'Informação temporária para ajudar na identificação do cliente.',
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.25,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0x1A000000), // #0000001A
            width: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerInfoSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clientes nesta conta',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 24 / 16,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Associe os clientes aos pedidos para salvar o pedido no histórico do cliente, pontuar no fidelidade e fazer pagamentos no fiado.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 0.25,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberOfPeopleRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _tableNameController,
            decoration: InputDecoration(
              labelText: 'Quantidade de pessoas',
              hintText: '$_numberOfPeople',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          child: const Icon(Icons.remove),
          onTap: () {
            if (_numberOfPeople > 1) {
              setState(
                () {
                  _numberOfPeople--;
                  temporalStore.removeCustomer(_numberOfPeople);
                },
              );
            }
          },
        ),
        const SizedBox(width: 8),
        InkWell(
          child: const Icon(Icons.add),
          onTap: () {
            setState(
              () {
                _numberOfPeople++;
                temporalStore.addCustomer(
                  CustomerEntity(
                    id: _numberOfPeople,
                    name: '',
                    phone: '',
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomerList() {
    return Expanded(
      child: Observer(
        builder: (_) => ListView.builder(
          itemCount: temporalStore.totalCustomers,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == temporalStore.totalCustomers - 1 ? 0 : 16,
              ),
              child: CustomerTileWidget(
                icon: index == 0
                    ? const Icon(Icons.link_off)
                    : const Icon(Icons.search, color: Color(0x66000000)),
                index: index,
                customerName: temporalStore.tableEntity.customers[index].name
                        .trim()
                        .isEmpty
                    ? 'Cliente ${index + 1}'
                    : temporalStore.tableEntity.customers[index].name,
                customerPhone: temporalStore.tableEntity.customers[index].phone
                        .trim()
                        .isEmpty
                    ? 'Não informado'
                    : temporalStore.tableEntity.customers[index].phone,
                onTap: () {
                  _showCustomerSelectionDialog(index);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCustomerSelectionDialog(int index) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Dialog(
          shadowColor: Colors.black.withAlpha(122),
          elevation: 10,
          child: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                const SizedBox(height: 16),
                CustomerTileWidget(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: CreateOrEditCustomerModal(
                            onSave: (newCustomer) {
                              widget.customersStore.addCustomer(newCustomer);
                            },
                          ),
                        );
                      },
                    );
                  },
                  isCreateNew: true,
                  hasBorder: false,
                  index: index,
                ),
                Observer(
                  builder: (_) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: widget.customersStore.customers.length,
                        itemBuilder: (context, customerIndex) {
                          final customer =
                              widget.customersStore.customers[customerIndex];
                          return CustomerTileWidget(
                            index: customerIndex,
                            customerName: customer.name,
                            customerPhone: customer.phone,
                            isCreateNew: false,
                            hasBorder: false,
                            onTap: () {
                              setState(
                                () {
                                  temporalStore.tableEntity.customers[index] =
                                      customer;
                                },
                              );
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndButtons() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintStyle: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 24 / 14,
                letterSpacing: 0.5,
              ),
              labelText: 'Pesquise por nome ou telefone',
              suffixIcon: Icon(Icons.search, color: Color(0x66000000)),
              prefixIcon: Icon(
                Icons.person_2_outlined,
                color: Color(0x66000000),
              ),
            ),
            onChanged: (value) {
              if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
              _searchDebounce = Timer(const Duration(milliseconds: 500), () {
                if (value.isNotEmpty) {
                  _showSearchDialog(value);
                }
              });
            },
          ),
        ),
        const SizedBox(height: 21),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SecondaryButton(
              onPressed: () => Navigator.of(context).pop(),
              text: 'Voltar',
            ),
            const SizedBox(width: 8),
            PrimaryButton(
              onPressed: _saveTable,
              text: 'Salvar',
            ),
          ],
        ),
      ],
    );
  }

  Timer? _searchDebounce;

  void _showSearchDialog(String value) {
    final filteredCustomers = widget.customersStore.customers
        .where((customer) =>
            customer.name.toLowerCase().contains(value.toLowerCase()) ||
            customer.phone.contains(value))
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shadowColor: Colors.black.withAlpha(122),
          elevation: 10,
          child: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Selecione um cliente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      return CustomerTileWidget(
                        hasBorder: false,
                        index: index,
                        customerName: customer.name,
                        customerPhone: customer.phone,
                        onTap: () {
                          setState(
                            () {
                              _numberOfPeople++;
                              temporalStore.addCustomer(customer);
                            },
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveTable() {
    Navigator.of(context).pop();
    if (widget.existingTable != null) {
      widget.tablesStore.editTable(
        widget.existingTable!.id,
        TableEntity(
          id: widget.existingTable!.id,
          identification: _tableNameController.text,
          customers: temporalStore.tableEntity.customers,
        ),
      );
    } else {
      widget.tablesStore.addTable(
        TableEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          identification: _tableNameController.text.isEmpty
              ? "Mesa ${widget.tablesStore.tables.length + 1}"
              : _tableNameController.text,
          customers: temporalStore.tableEntity.customers,
        ),
      );
    }
  }
}
