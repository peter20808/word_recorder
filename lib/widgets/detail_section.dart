import 'package:flutter/material.dart';

class DetailSection extends StatelessWidget {
  final String title;

  final String value;

  const DetailSection({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          //--------------------------------------
          // Title
          //--------------------------------------

          Text(
            title,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          //--------------------------------------
          // Value
          //--------------------------------------

          Text(
            value.isEmpty ? "-" : value,

            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          const Divider(),

        ],
      ),
    );
  }
}