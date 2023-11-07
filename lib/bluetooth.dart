import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();

  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Scanner"),
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.scanResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ScanResult>? scanResults = snapshot.data;
            return ListView.builder(
              itemCount: scanResults!.length,
              itemBuilder: (context, index) {
                ScanResult result = scanResults[index];
                return Card(
                  child: ListTile(
                    title: Text(result.device.name),
                    subtitle: Text(result.device.id.id),
                    trailing: Text(result.rssi.toString()),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return const Center(child: Text( "Scanning..." ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isScanning) {
            FlutterBluePlus.stopScan();
          } else {
            FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
          }
          setState(() {
            isScanning = !isScanning;
          });
        },
        child: const Icon(Icons.bluetooth_searching),
      ),
    );
  }
}
