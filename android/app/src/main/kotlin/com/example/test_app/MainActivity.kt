package com.example.test_app

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import java.util.UUID

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.test_app/printer"
    private val TAG = "V510BluetoothPrinter"
    
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "bluetoothPrint" -> {
                    bluetoothPrint(call, result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun bluetoothPrint(call: MethodCall, result: MethodChannel.Result) {
        try {
            val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if (bluetoothAdapter == null) {
                result.error("BLUETOOTH_NOT_AVAILABLE", "Bluetooth is not available on this device", null)
                return
            }
            
            if (!bluetoothAdapter.isEnabled) {
                result.error("BLUETOOTH_NOT_ENABLED", "Bluetooth is not enabled", null)
                return
            }
            
            Log.d(TAG, "Scanning for printer devices...")
            
            // Get paired devices first
            val pairedDevices = bluetoothAdapter.bondedDevices
            val printerDevices = mutableListOf<BluetoothDevice>()
            
            // Filter for printer devices
            for (device in pairedDevices) {
                val deviceName = device.name?.lowercase() ?: ""
                val printerKeywords = listOf("printer", "thermal", "pos", "receipt", "v510", "hosoton", "ktp", "rpp", "mpt", "goojprt", "zjiang", "xprinter")
                
                if (printerKeywords.any { deviceName.contains(it) }) {
                    printerDevices.add(device)
                    Log.d(TAG, "Found printer device: ${device.name} (${device.address})")
                }
            }
            
            if (printerDevices.isEmpty()) {
                result.error("NO_PRINTER_FOUND", "No printer devices found. Please pair your printer first.", null)
                return
            }
            
            // Use the first printer found
            val printerDevice = printerDevices[0]
            Log.d(TAG, "Connecting to printer: ${printerDevice.name}")
            
            // Connect using SPP UUID
            val sppUuid = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
            val socket: BluetoothSocket = printerDevice.createRfcommSocketToServiceRecord(sppUuid)
            
            try {
                socket.connect()
                Log.d(TAG, "Connected to printer successfully")
                
                val outputStream = socket.outputStream
                
                // Get text from call arguments
                val textToPrint = call.argument<String>("text") ?: "Test Print\nBluetooth printing is working!\nV510 Thermal Printer\n"
                
                // ESC/POS commands for thermal printing
                val commands = mutableListOf<Byte>()
                
                // Initialize printer
                commands.addAll(byteArrayOf(0x1B, 0x40).toList()) // ESC @
                
                // Set character set
                commands.addAll(byteArrayOf(0x1B, 0x74, 0x00).toList()) // ESC t 0
                
                // Set font size
                commands.addAll(byteArrayOf(0x1D, 0x21, 0x11).toList()) // GS ! (double width and height)
                
                // Print text
                commands.addAll(textToPrint.toByteArray(Charsets.UTF_8).toList())
                
                // Add some line feeds
                commands.addAll("\n\n\n".toByteArray().toList())
                
                // Cut paper (if supported)
                commands.addAll(byteArrayOf(0x1D, 0x56, 0x41, 0x10).toList()) // GS V A (partial cut)
                
                // Send commands to printer
                outputStream.write(commands.toByteArray())
                outputStream.flush()
                
                Log.d(TAG, "Print commands sent successfully")
                
                // Close connection
                outputStream.close()
                socket.close()
                
                result.success("Print successful via Bluetooth")
                
            } catch (e: Exception) {
                Log.e(TAG, "Error during printing: ${e.message}")
                socket.close()
                result.error("PRINT_ERROR", "Failed to print: ${e.message}", null)
            }
            
        } catch (e: Exception) {
            Log.e(TAG, "Bluetooth print error: ${e.message}")
            result.error("BLUETOOTH_ERROR", "Bluetooth error: ${e.message}", null)
        }
    }
}
