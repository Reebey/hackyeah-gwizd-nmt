import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Track whether the report dialog is open or not
  bool isReportDialogOpen = false;
  bool isReportButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Map App'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Add more dashboard items here
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Filters'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Add filter options here
          ],
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(50.0500, 19.9440),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(51.5, -0.09),
                builder: (ctx) => Container(
                  child: const Icon(
                    Icons.location_on,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Center(
          child: ElevatedButton(
            onPressed: isReportButtonEnabled
                ? () async {
                    setState(() {
                      isReportButtonEnabled = false;
                    });
                    // Show the report dialog
                    await showReportDialog(context);
                    setState(() {
                      isReportButtonEnabled = true;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
            child: !isReportButtonEnabled
                ? const CircularProgressIndicator() // Show a loading indicator
                : const Text('Report a wild animal'),
          ),
        ),
      ),
    );
  }

  Future showReportDialog(BuildContext context) async {
    // Request location permission
    var status = await Permission.location.request();

    if (status.isGranted) {
      final Position userLocation = await Geolocator.getCurrentPosition();
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      // Pass the context as a parameter to the async function
      showReportDialogInternal(context, userLocation, image);
    } else {
      // Handle the case where location permission is denied
      // You can show a dialog or message to inform the user
      print('Location permission denied');
    }
  }

  void showReportDialogInternal(
      BuildContext context, Position userLocation, XFile? image) {
    showBarModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Report a Wild Animal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FormBuilderTextField(
                  name: 'animalName',
                  decoration: const InputDecoration(labelText: 'Animal Name'),
                  // validator: FormBuilderValidators.required(context),
                ),
                FormBuilderTextField(
                  name: 'location',
                  readOnly: true,
                  initialValue:
                      'Lat: ${userLocation.latitude}, Long: ${userLocation.longitude}',
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 20),
                if (image != null)
                  Image.file(
                    File(image.path),
                    height: 400,
                    width: 300,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formData = _formKey.currentState!.value;
                      print(formData);

                      if (image != null) {
                        final imagePath = image.path;
                        print('Image Path: $imagePath');
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit Report'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
