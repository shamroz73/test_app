# V510 POS Printer Flutter App

A production-ready Flutter application for **Bluetooth thermal printing** on the **Hosoton V510 Android 12 POS device**.

## 📱 Device Details

- **Model**: Hosoton V510B
- **OS**: Android 12, MTK Quad-Core 2.0GHz  
- **Printer**: Built-in 58mm high-speed thermal printer (80mm/s)
- **Connectivity**: Bluetooth 5.0, Wi-Fi, 4G, USB Type-C
- **Printing**: ✅ **Bluetooth ESC/POS printing** - **CONFIRMED WORKING** with physical paper output

## 🎯 **Bluetooth Printing Solution**

This app uses **direct Bluetooth communication** with ESC/POS commands to print to thermal printers. **No SDK required!**

### ✅ **Key Features**
- **Bluetooth device scanning** with automatic printer detection
- **SPP (Serial Port Profile)** communication 
- **ESC/POS thermal printing commands**
- **Production-ready clean interface**
- **Confirmed working** - prints actual paper on V510 device

## 🚀 **How It Works**

### **Bluetooth Communication Flow**
1. **Device Scanning**: Scans paired Bluetooth devices
2. **Printer Detection**: Identifies printers by name patterns (`printer`, `thermal`, `pos`, `receipt`, `v510`, `hosoton`, etc.)
3. **SPP Connection**: Connects using UUID `00001101-0000-1000-8000-00805F9B34FB`
4. **ESC/POS Commands**: Sends thermal printing commands
5. **Paper Output**: ✅ **Physical printing confirmed working**

### **Supported Printer Names**
The app automatically detects printers with names containing:
- `printer`, `thermal`, `pos`, `receipt`
- `v510`, `hosoton`, `ktp`, `rpp`, `mpt`
- `goojprt`, `zjiang`, `xprinter`

## 📱 **User Interface**

### **Clean Production Interface**
- **Single "PRINT VIA BLUETOOTH" button** 
- **Text input field** for custom content
- **Status display** showing operation results
- **User instructions** for device pairing
- **No debugging clutter** - production ready

## 🔧 **Platform Channel Integration**

### **Dart Side (Flutter)**

```dart
static const platform = MethodChannel('com.example.test_app/printer');

// Bluetooth printing
Future<void> printViaBluetooth(String text) async {
  try {
    final String result = await platform.invokeMethod('bluetoothPrint', {
      'text': text
    });
    print('Print result: $result');
  } catch (e) {
    print('Print failed: $e');
  }
}
```

### **Android Side (Kotlin)**

```kotlin
private fun bluetoothPrint(call: MethodCall, result: MethodChannel.Result) {
    // 1. Get Bluetooth adapter
    val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
    
    // 2. Scan for printer devices
    val printerDevices = pairedDevices.filter { device ->
        device.name?.lowercase()?.contains("printer") == true
    }
    
    // 3. Connect via SPP
    val socket = device.createRfcommSocketToServiceRecord(sppUuid)
    socket.connect()
    
    // 4. Send ESC/POS commands
    outputStream.write(escPosCommands)
    
    // 5. Physical paper output! ✅
}
```

## 🔐 **Required Permissions**

The app automatically requests essential Bluetooth permissions:

- ✅ `BLUETOOTH` & `BLUETOOTH_CONNECT`
- ✅ `ACCESS_FINE_LOCATION` (required for Bluetooth device discovery)

## 🛠️ **Setup Instructions**

### **1. Prerequisites**
- ✅ V510 device with Android 12
- ✅ Flutter development environment
- ✅ Bluetooth thermal printer (paired with device)

### **2. Pair Your Printer**
1. **Enable Bluetooth** on V510 device
2. **Pair thermal printer** in Android Bluetooth settings
3. **Ensure printer name contains** keywords like "printer", "thermal", "pos", etc.

### **3. Build and Deploy**

```bash
# Clone the repository
git clone https://github.com/shamroz73/test_app.git
cd test_app

# Build debug APK
flutter build apk --debug

# Install to connected V510 device
adb install build/app/outputs/flutter-apk/app-debug.apk

# Or run directly
flutter run
```

### **4. Test Bluetooth Printing**
1. **Launch the app** on V510 device
2. **Grant Bluetooth permissions** when prompted
3. **Enter text** in the input field
4. **Tap "PRINT VIA BLUETOOTH"**
5. **Enjoy physical paper output!** 🎉

## 📋 **Code Examples**

### **Basic Bluetooth Printing**

```dart
Future<void> printText(String customText) async {
  try {
    final String result = await platform.invokeMethod('bluetoothPrint', {
      'text': customText.isEmpty ? 
        'Test Print\nBluetooth printing works!\nV510 Thermal Printer\n' : 
        customText
    });
    
    // Success! Physical paper output
    print('✅ Print successful: $result');
    
  } catch (e) {
    // Handle errors
    print('❌ Print failed: $e');
  }
}
```

### **Receipt Printing Example**

```dart
Future<void> printReceipt() async {
  final receipt = '''
================================
        COFFEE SHOP
================================
Date: ${DateTime.now().toString().substring(0, 19)}
Order #: ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}

Espresso              \$3.50
Croissant             \$2.25
--------------------------------
Total:                \$5.75
================================
    Thank you!
    Visit again soon!
================================

''';

  await platform.invokeMethod('bluetoothPrint', {'text': receipt});
}
```

## 🔍 **Troubleshooting**

### **Common Issues & Solutions**

| Issue | Solution |
|-------|----------|
| "No printer devices found" | Pair your thermal printer in Bluetooth settings |
| "Bluetooth is not enabled" | Enable Bluetooth on V510 device |
| "BLUETOOTH_NOT_AVAILABLE" | Check device Bluetooth hardware |
| "Failed to print" | Ensure printer is powered on and has paper |

### **Debugging Commands**

```bash
# Check connected devices
adb devices

# Monitor app logs
adb logcat -s "V510BluetoothPrinter"

# Check Bluetooth status
adb shell dumpsys bluetooth_manager
```

## ⚡ **Technical Details**

### **Bluetooth Implementation**
- **Protocol**: SPP (Serial Port Profile)
- **UUID**: `00001101-0000-1000-8000-00805F9B34FB`
- **Commands**: ESC/POS thermal printing
- **Paper Size**: 58mm thermal paper
- **Print Speed**: 80mm/s

### **ESC/POS Commands Used**
```kotlin
// Initialize printer
0x1B, 0x40  // ESC @

// Set character set  
0x1B, 0x74, 0x00  // ESC t 0

// Set font size
0x1D, 0x21, 0x11  // GS ! (double width/height)

// Cut paper
0x1D, 0x56, 0x41, 0x10  // GS V A (partial cut)
```

## 🎯 **Production Ready**

### ✅ **What's Included**
- Clean production UI (no debugging buttons)
- Robust error handling
- Automatic device detection
- Working Bluetooth printing with paper output
- Example usage code in `lib/example_usage.dart`

### ✅ **Tested & Confirmed**
- **Device**: Hosoton V510B Android 12
- **Printing**: Physical paper output confirmed ✅
- **Connection**: Bluetooth SPP working ✅
- **Commands**: ESC/POS thermal printing ✅

## 📞 **Support & Next Steps**

1. **Ready to use**: App is production-ready for Bluetooth thermal printing
2. **Customize**: Modify UI and printing content as needed
3. **Deploy**: Build and install on your V510 devices
4. **Extend**: Add more ESC/POS features if required

---

**🎉 Bluetooth Printing Success!** 

Your V510 POS printer Flutter app is now fully functional with confirmed physical paper output via Bluetooth communication. No SDK required - just pure Bluetooth + ESC/POS commands!
