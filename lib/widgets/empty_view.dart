import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  /// 主要訊息
  final String message;

  /// 次要說明
  final String? description;

  /// 顯示的 Icon
  final IconData icon;

  const EmptyView({
    super.key,
    required this.message,
    this.description,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(
              icon,
              size: 72,
              color: Colors.grey,
            ),

            const SizedBox(height: 20),

            Text(
              message,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            if (description != null) ...[

              const SizedBox(height: 10),

              Text(
                description!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

            ],
          ],
        ),
      ),
    );
  }
}