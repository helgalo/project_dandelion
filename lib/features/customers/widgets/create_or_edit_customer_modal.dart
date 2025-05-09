import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/shared/widgets/modal.widget.dart';
import 'package:teste_flutter/shared/widgets/primary_button.widget.dart';
import 'package:teste_flutter/shared/widgets/secondary_button.widget.dart';

class CreateOrEditCustomerModal extends StatefulWidget {
  const CreateOrEditCustomerModal({Key? key, this.customerEntity, this.onSave})
      : super(key: key);

  final CustomerEntity? customerEntity;
  final Function(CustomerEntity)? onSave;

  @override
  State<CreateOrEditCustomerModal> createState() =>
      _CreateOrEditCustomerModalState();
}

class _CreateOrEditCustomerModalState extends State<CreateOrEditCustomerModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CustomersStore customersStore = GetIt.I<CustomersStore>();

  CustomerEntity? get customer => widget.customerEntity;

  @override
  void initState() {
    super.initState();
    nameController.text = customer?.name ?? '';
    phoneController.text = customer?.phone ?? '';
  }

  void handleSave() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final newCustomer = CustomerEntity(
      id: customer?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      phone: phoneController.text,
    );

    if (widget.onSave != null) {
      widget.onSave!(newCustomer);
    } else if (customer == null) {
      customersStore.addCustomer(newCustomer);
    } else {
      customersStore.updateCustomer(newCustomer);
    }

    Navigator.of(context).pop();
  }

  String? inputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ModalWidget(
        width: 280,
        title: '${customer == null ? 'Novo' : 'Editar'} cliente',
        content: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: inputValidator,
            autofocus: true,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Telefone'),
            validator: inputValidator,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter(),
            ],
          ),
        ],
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'Cancelar',
          ),
          PrimaryButton(
            onPressed: handleSave,
            text: 'Salvar',
          ),
        ],
      ),
    );
  }
}
