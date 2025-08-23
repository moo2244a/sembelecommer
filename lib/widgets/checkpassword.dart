import 'package:flutter/material.dart';

class RowPassword extends StatelessWidget {
  final bool stati;
  final String titel;

  const RowPassword({super.key, required this.stati, required this.titel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            stati ? Icons.check_circle : Icons.cancel,
            color: stati ? Colors.green : Colors.red,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              titel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: stati ? Colors.green[800] : Colors.red[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
