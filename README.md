# V510 POS Printer Flutter App

A complete Flutter application for the **Hosoton V510 Android 12 POS printer** with built-in 58mm thermal printing capabilities.

## 📱 Device Details

- **Model**: Hosoton V510
- **OS**: Android 12, MTK Quad-Core 2.0GHz
- **Printer**: Built-in 58mm high-speed thermal printer (80mm/s)
- **Connectivity**: Bluetooth 5.0, Wi-Fi, 4G, USB Type-C
- **Printing**: ESC/POS printing via vendor SDK

## 📦 SDK Integration

### ✅ Step 1: Place the KTPsdk.aar file

**EXACT LOCATION**: Put your `KTPsdk.aar` file in:

```
/Users/shamroz.warraich/Projects/Printing_app/test_app/android/app/libs/KTPsdk.aar
```

### ✅ Step 2: Gradle Configuration (Already Done)

The project is already configured with:

- Gradle dependencies for the .aar file
- Repository configuration for local libs
- Required permissions in AndroidManifest.xml

### ✅ Step 3: AIDL Integration (Already Done)

The following AIDL files are already created:

- `AidlPrinterService.aidl` - Main printer service interface
- `AidlPrinterListener.aidl` - Callback listener interface
- `PrintItemObj.aidl` - Print item data structure

## 🚀 Features

### Printing Functions

- ✅ **Text Printing**: `printText(String text)`
- ✅ **Bitmap Printing**: `printBitmap(Uint8List image)`
- ✅ **Barcode Printing**: `printBarcode(String code)`
- ✅ **Printer Status**: `getPrinterState()`

### UI Features

- 📱 Clean, intuitive interface
- 🟢 Real-time printer status indicator
- 📝 Text input for custom receipts
- 🧾 Pre-built test receipt template
- 📊 Barcode generation and printing
- ⚡ Live permission handling

## 🔧 Platform Channel Integration

### Dart Side (Flutter)

```dart
// Example usage
static const platform = MethodChannel('com.example.test_app/printer');

// Print simple text
final result = await platform.invokeMethod('printText', {
  'text': 'Hello World from V510!'
});

// Print barcode
final result = await platform.invokeMethod('printBarcode', {
  'code': '1234567890'
});

// Check printer status
final int state = await platform.invokeMethod('getPrinterState');
```

### Android Side (Kotlin)

The native Android implementation handles:

- AIDL service binding to `com.kingtopgroup.posprinter`
- Permission management
- Print job queuing and callbacks
- Error handling and status reporting

## 🔐 Permissions (Auto-handled)

The app automatically requests these permissions:

- `BLUETOOTH` & `BLUETOOTH_CONNECT`
- `ACCESS_FINE_LOCATION` & `ACCESS_COARSE_LOCATION`
- `READ_EXTERNAL_STORAGE` & `WRITE_EXTERNAL_STORAGE`

## 🛠️ How to Build and Run

### 1. Prerequisites

- ✅ Android SDK licenses accepted (already done)
- ✅ V510 device connected via USB with Developer Options enabled
- ✅ Flutter dependencies installed

### 2. Place the SDK File

```bash
# Copy your KTPsdk.aar to the correct location
cp /path/to/V510_sdk.rar/libs/KTPsdk.aar android/app/libs/
```

### 3. Build and Deploy

```bash
# Build the APK
flutter build apk --debug

# Or run directly on connected device
flutter run
```

### 4. Test on V510 Device

1. **Connect the V510 device** via USB
2. **Enable Developer Options** and USB Debugging
3. **Run the app**: `flutter run`
4. **Grant permissions** when prompted
5. **Test printing** with the built-in functions

## 📋 Example Dart Code

### Simple Text Printing

```dart
Future<void> printHelloWorld() async {
  try {
    final String result = await platform.invokeMethod('printText', {
      'text': 'Hello World from V510 Printer!\\n\\nThis is a test print.\\n'
    });
    print('Print result: $result');
  } catch (e) {
    print('Print failed: $e');
  }
}
```

### Receipt Printing

```dart
Future<void> printReceipt() async {
  final receipt = '''
================================
        COFFEE SHOP
================================
Date: ${DateTime.now().toString().substring(0, 19)}
Item 1: Espresso       \$3.50
Item 2: Croissant      \$2.25
Item 3: Tip            \$1.00
--------------------------------
Total:                 \$6.75
================================
    Thank you!
================================
''';

  await platform.invokeMethod('printText', {'text': receipt});
}
```

### Barcode Printing

```dart
Future<void> printProductBarcode() async {
  await platform.invokeMethod('printBarcode', {
    'code': '1234567890123'
  });
}
```

## 🔍 Troubleshooting

### Common Issues

1. **"Printer service not bound"**: Ensure the V510 device has the printer service running
2. **Permission denied**: Grant all requested permissions in device settings
3. **Build errors**: Ensure `KTPsdk.aar` is in the correct location

### Debugging

```bash
# Check device connectivity
flutter devices

# View detailed logs
flutter logs

# Check printer status
adb logcat | grep "V510Printer"
```

## 📊 Printer Status Codes

- `0`: Printer Ready ✅
- `1`: Printer Busy 🔄
- `2`: Out of Paper 📄
- `3`: Printer Error ❌
- `-1`: Printer Disconnected ❌

## 🎯 Next Steps

1. **Place the KTPsdk.aar file** in the specified location
2. **Build and test** on your V510 device
3. **Customize the UI** for your specific needs
4. **Add more printing features** as required

## 📞 Support

- Check the V510 device documentation
- Verify AIDL service availability
- Test with different print formats
- Monitor device logs for detailed error information

---

**Ready to print! 🖨️** Your V510 POS printer Flutter app is fully configured and ready for deployment.
