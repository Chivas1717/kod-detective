import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:flutter/material.dart';

class OrderQuestion extends StatefulWidget {
  final Question question;
  final List<int>? currentOrder;
  final Function(List<int>) onOrderChanged;

  const OrderQuestion({
    super.key,
    required this.question,
    required this.currentOrder,
    required this.onOrderChanged,
  });

  @override
  State<OrderQuestion> createState() => _OrderQuestionState();
}

class _OrderQuestionState extends State<OrderQuestion> {
  late List<Map<String, dynamic>> _items;
  bool _initialOrderSubmitted = false;

  @override
  void initState() {
    super.initState();
    _initializeItems();
    
    // Submit initial order if not already set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.currentOrder == null && !_initialOrderSubmitted) {
        _submitInitialOrder();
      }
    });
  }

  @override
  void didUpdateWidget(OrderQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentOrder != oldWidget.currentOrder) {
      _initializeItems();
    }
  }

  void _initializeItems() {
    final options = List<Map<String, dynamic>>.from(widget.question.metadata['options'] ?? []);
    
    if (widget.currentOrder != null) {
      // Sort options based on current order
      _items = widget.currentOrder!
          .map((id) => options.firstWhere((o) => o['id'] == id, orElse: () => {'id': id, 'text': 'Unknown'}))
          .toList();
    } else {
      // Use default order or shuffle
      _items = List.from(options);
    }
  }
  
  void _submitInitialOrder() {
    if (_items.isNotEmpty) {
      final initialOrder = _items.map((item) => item['id'] as int).toList();
      widget.onOrderChanged(initialOrder);
      _initialOrderSubmitted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.prompt,
          style: const TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Перетягніть елементи у правильному порядку:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 16),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = _items.removeAt(oldIndex);
              _items.insert(newIndex, item);
              
              // Notify parent about the new order
              final newOrder = _items.map((item) => item['id'] as int).toList();
              widget.onOrderChanged(newOrder);
            });
          },
          children: _items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            return Container(
              key: ValueKey(item['id']),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF252538),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ListTile(
                leading: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B61FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  item['text'],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: Icon(
                  Icons.drag_handle,
                  color: Colors.grey.shade400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
} 