import 'package:flutter/material.dart';
import 'package:sos_connect/pages/support/widget/sos_type_card_widget.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SosTypeSelectorWidget extends StatelessWidget {
  const SosTypeSelectorWidget({super.key, required this.selectedType, required this.onSelect});

  final SosEmergencyType selectedType;
  final ValueChanged<SosEmergencyType> onSelect;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final type in SosEmergencyTypeExtension.selectableTypes) ...[
            if (type != SosEmergencyTypeExtension.selectableTypes.first) SizedBox(width: 8.w),
            Expanded(
              child: SosTypeCardWidget(
                title: type.title,
                iconPath: type.iconPath,
                color: type.style.text,
                background: type.style.background,
                isSelected: selectedType == type,
                onTap: () => onSelect(type),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
