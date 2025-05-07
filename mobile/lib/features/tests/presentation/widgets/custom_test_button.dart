import 'package:flutter/material.dart';

class CustomTestButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isPrimary;
  final IconData? icon;

  const CustomTestButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isPrimary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = isPrimary 
        ? const Color(0xFF7B61FF) 
        : const Color(0xFF2A2A3C);
    
    final defaultTextColor = isPrimary 
        ? Colors.white 
        : const Color(0xFFADB5BD);
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? defaultBackgroundColor,
        foregroundColor: textColor ?? defaultTextColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isPrimary ? 4 : 2,
        shadowColor: isPrimary 
            ? const Color(0xFF7B61FF).withOpacity(0.4) 
            : Colors.black.withOpacity(0.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
} 