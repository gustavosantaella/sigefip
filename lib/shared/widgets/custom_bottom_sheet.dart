import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(child: SingleChildScrollView(child: child)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
