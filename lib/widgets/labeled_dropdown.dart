import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

///======================================================
/// 標題 + Dropdown
///======================================================
class LabeledDropdown extends StatelessWidget {

  final String title;

  final String value;

  final List<String> items;

  final ValueChanged<String?> onChanged;

  const LabeledDropdown({

    super.key,

    required this.title,

    required this.value,

    required this.items,

    required this.onChanged,

  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: AppSpacing.card,

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(

              fontSize: 16,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(

            value: value,

            decoration: const InputDecoration(

              border: OutlineInputBorder(),

            ),

            items: items.map(

              (item){

                return DropdownMenuItem(

                  value: item,

                  child: Text(item),

                );

              },

            ).toList(),

            onChanged: onChanged,

          ),

        ],

      ),

    );

  }

}