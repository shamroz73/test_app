import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const V510PrinterApp());
}

class V510PrinterApp extends StatelessWidget {
  const V510PrinterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V510 POS Printer',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PrinterHomePage(),
    );
  }
}

class PrinterHomePage extends StatefulWidget {
  const PrinterHomePage({super.key});

  @override
  State<PrinterHomePage> createState() => _PrinterHomePageState();
}

class _PrinterHomePageState extends State<PrinterHomePage> {
  static const platform = MethodChannel('com.example.test_app/printer');

  final TextEditingController _textController = TextEditingController();

  String _statusMessage = 'Ready to Print';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.location,
    ];

    Map<Permission, PermissionStatus> statuses = await permissions.request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      setState(() {
        _statusMessage = 'Bluetooth permissions required for printing';
      });
    } else {
      setState(() {
        _statusMessage = 'Ready to Print via Bluetooth';
      });
    }
  }

  Future<void> _bluetoothPrint() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final printText = _textController.text.isEmpty
          ? '🔵 BLUETOOTH PRINT TEST 🔵\nV510 Bluetooth Thermal Printer\nESC/POS Commands via Bluetooth\n\n📱 BLUETOOTH PRINTING! 📱'
          : _textController.text;

      final result = await platform.invokeMethod('bluetoothPrint', {
        'text': printText,
      });

      if (result is Map) {
        String message = 'Bluetooth Print Results:\n\n';

        final printSuccess = result['printSuccess'] ?? false;
        final results = result['results'] as List<dynamic>? ?? [];
        final attemptsCount = result['attemptsCount'] ?? 0;
        final summary = result['summary'] ?? 'No summary';

        message += '$summary\n\n';
        message += '🔧 Attempts: $attemptsCount\n\n';

        if (printSuccess) {
          message += '🔵 BLUETOOTH PRINT WORKED!\n\n';
        }

        message += 'Detailed Results:\n';
        for (var resultLine in results.take(10)) {
          message += '• $resultLine\n';
        }
        if (results.length > 10) {
          message += '... and ${results.length - 10} more results\n';
        }

        _showSnackBar(message);
      } else {
        _showSnackBar('Bluetooth Print Result: $result');
      }
    } catch (e) {
      _showSnackBar('Bluetooth print failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('V510 Bluetooth Printer'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bluetooth, color: Colors.blue, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bluetooth Printer Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(_statusMessage),
                            ],
                          ),
                        ),
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Text Printing Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Print Your Text',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText:
                            'Enter text to print...\n\nLeave empty for a test receipt',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _bluetoothPrint,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.bluetooth, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'PRINT VIA BLUETOOTH',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Instructions Card
            Card(
              elevation: 2,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'How to Use',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Make sure your V510 device Bluetooth is enabled\n'
                      '2. Enter your text in the field above (or leave empty for test)\n'
                      '3. Tap "PRINT VIA BLUETOOTH" button\n'
                      '4. The app will find and connect to your thermal printer\n'
                      '5. Your receipt will print automatically!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
