import 'package:flutter/material.dart';

class CustomerTileWidget extends StatelessWidget {
  final int index;
  final String? customerName;
  final String? customerPhone;
  final bool isCreateNew;
  final bool hasBorder;
  final Icon? icon;
  final Function()? onTap;

  const CustomerTileWidget({
    Key? key,
    required this.index,
    this.onTap,
    this.customerName,
    this.customerPhone,
    this.isCreateNew = false,
    this.hasBorder = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      shape: RoundedRectangleBorder(
        side: hasBorder
            ? const BorderSide(color: Color(0x1A000000))
            : BorderSide.none,
        borderRadius: BorderRadius.circular(8.0),
      ),
      leading: isCreateNew
          ? const Icon(
              Icons.person_add,
              color: Color(0xFF1FB76C),
            )
          : const Icon(
              Icons.person_2_outlined,
              color: Color(0x66000000),
            ),
      title: Text(
        isCreateNew ? "Novo cliente" : customerName ?? 'Não informado',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          height: 24 / 14,
          letterSpacing: 0.5,
          overflow: TextOverflow.ellipsis,
          textBaseline: TextBaseline.alphabetic,
          color:
              isCreateNew ? const Color(0xFF1FB76C) : const Color(0xFF1D1B20),
        ),
      ),
      subtitle: Text(
        customerPhone?.trim().isEmpty ?? true
            ? 'Não informado'
            : customerPhone!,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 24 / 14,
          letterSpacing: 0.5,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: icon,
      onTap: onTap,
    );
  }
}
