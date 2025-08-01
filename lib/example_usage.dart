// Example usage of V510 POS Printer Flutter App
// Copy this code to your Flutter project to use the printing functions

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class V510PrinterExample extends StatefulWidget {
  const V510PrinterExample({super.key});

  @override
  State<V510PrinterExample> createState() => _V510PrinterExampleState();
}

class _V510PrinterExampleState extends State<V510PrinterExample> {
  static const platform = MethodChannel('com.example.test_app/printer');

  // ✅ Example 1: Print simple text
  Future<void> printHelloWorld() async {
    try {
      final String result = await platform.invokeMethod('printText', {
        'text': 'Hello World from V510 Printer!\n\nThis is a test print.\n',
      });
      print('Print result: $result');
      _showSnackBar(result);
    } catch (e) {
      print('Print failed: $e');
      _showSnackBar('Print failed: $e');
    }
  }

  // ✅ Example 2: Print a complete receipt
  Future<void> printReceipt() async {
    final receipt =
        '''
================================
        COFFEE SHOP
================================
Date: ${DateTime.now().toString().substring(0, 19)}
Order #: 12345

Item 1: Espresso       \$3.50
Item 2: Croissant      \$2.25
Item 3: Tip            \$1.00
--------------------------------
Subtotal:              \$5.75
Tax (8%):              \$0.46
Total:                 \$6.21
--------------------------------
Payment: Card ****1234
--------------------------------
================================
    Thank you for your visit!
    Please come again!
================================

''';

    try {
      final String result = await platform.invokeMethod('printText', {
        'text': receipt,
      });
      _showSnackBar('Receipt printed successfully');
    } catch (e) {
      _showSnackBar('Receipt print failed: $e');
    }
  }

  // ✅ Example 3: Print barcode
  Future<void> printProductBarcode() async {
    try {
      final String result = await platform.invokeMethod('printBarcode', {
        'code': '1234567890123',
      });
      _showSnackBar('Barcode printed successfully');
    } catch (e) {
      _showSnackBar('Barcode print failed: $e');
    }
  }

  // ✅ Example 4: Check printer status
  Future<void> checkPrinterStatus() async {
    try {
      final int state = await platform.invokeMethod('getPrinterState');
      String statusText;
      switch (state) {
        case 0:
          statusText = 'Printer Ready ✅';
          break;
        case 1:
          statusText = 'Printer Busy 🔄';
          break;
        case 2:
          statusText = 'Out of Paper 📄';
          break;
        case 3:
          statusText = 'Printer Error ❌';
          break;
        default:
          statusText = 'Printer Disconnected ❌';
      }
      _showSnackBar('Status: $statusText');
    } catch (e) {
      _showSnackBar('Failed to get printer status: $e');
    }
  }

  // ✅ Example 5: Print order summary
  Future<void> printOrderSummary(List<OrderItem> items) async {
    double subtotal = items.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    double tax = subtotal * 0.08;
    double total = subtotal + tax;

    String receipt =
        '''
================================
        RESTAURANT
================================
Date: ${DateTime.now().toString().substring(0, 19)}
Order #: ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}

''';

    for (var item in items) {
      receipt +=
          '${item.name.padRight(20)} \$${(item.price * item.quantity).toStringAsFixed(2)}\n';
      if (item.quantity > 1) {
        receipt +=
            '  ${item.quantity} x \$${item.price.toStringAsFixed(2)} each\n';
      }
    }

    receipt +=
        '''
--------------------------------
Subtotal:              \$${subtotal.toStringAsFixed(2)}
Tax (8%):              \$${tax.toStringAsFixed(2)}
Total:                 \$${total.toStringAsFixed(2)}
================================
    Thank you!
================================

''';

    try {
      await platform.invokeMethod('printText', {'text': receipt});
      _showSnackBar('Order summary printed');
    } catch (e) {
      _showSnackBar('Print failed: $e');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('V510 Printer Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: printHelloWorld,
              child: const Text('1. Print Hello World'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: printReceipt,
              child: const Text('2. Print Receipt'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: printProductBarcode,
              child: const Text('3. Print Barcode'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: checkPrinterStatus,
              child: const Text('4. Check Printer Status'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => printOrderSummary([
                OrderItem('Coffee', 3.50, 2),
                OrderItem('Sandwich', 7.25, 1),
                OrderItem('Cookie', 2.00, 3),
              ]),
              child: const Text('5. Print Order Summary'),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model for order items
class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem(this.name, this.price, this.quantity);
}
