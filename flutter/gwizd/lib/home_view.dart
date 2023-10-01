import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gwizd/models/animal_model.dart';
import 'package:gwizd/utility/http_client.dart';
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

  final apiClient = ApiClient();
  // Track whether the report dialog is open or not
  bool isReportDialogOpen = false;
  bool isReportButtonEnabled = true;

  late List<AnimalModel> animals = List.empty();
  List<String> apoints = ['Point A', 'Point B', 'Point C', 'Point D'];
  String? selectedAnimal;

  @override
  void initState() {
    super.initState();

    fetchAnimals();
  }

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
            ListTile(
              title: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Filter by animal', // Add your label here
                  border:
                      OutlineInputBorder(), // You can customize the border as needed
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 16), // Adjust padding
                ),
                value: selectedAnimal,
                items: animals.map((animal) {
                  return DropdownMenuItem<String>(
                    value: animal.id.toString(),
                    child: Text(animal.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnimal = value!;
                  });
                },
              ),
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

  Future<void> submitReport(
    BuildContext context,
    Map<String, dynamic> formData,
    XFile? image,
  ) async {
    try {
      final animal = formData['Animal'];
      final location = formData['Location'];
      final annotation = formData['Annotation'];

      print(animal);
      print(location);
      print(annotation);

      // Close the report dialog
      Navigator.pop(context);
    } catch (error) {
      // Handle errors, e.g., display an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    }
  }

  Future<void> fetchAnimals() async {
    final animalsResponse = await apiClient.getAnimals();
    final data = json.decode(animalsResponse.body);
    setState(() {
      animals =
          data.map<AnimalModel>((json) => AnimalModel.fromJson(json)).toList();
    });
  }

  Future showReportDialogInternal(
      BuildContext context, Position userLocation, XFile? image) async {
    // ignore: use_build_context_synchronously
    showBarModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Report a Wild Animal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // FormBuilderTextField(
                //   name: 'animalName',
                //   decoration: const InputDecoration(labelText: 'Animal Name'),
                //   // validator: FormBuilderValidators.required(context),
                // ),
                FormBuilderDropdown(
                  name: 'Animal',
                  decoration: const InputDecoration(labelText: 'Animal Type'),
                  // hint: const Text('Select Animal Type'),
                  items: animals
                      .map((animal) => DropdownMenuItem<String>(
                            value: animal.id.toString(),
                            child: Text(animal.name),
                          ))
                      .toList(),
                  // The validator can be added as per your requirements.
                  // validator: FormBuilderValidators.required(context),
                ),
                FormBuilderTextField(
                  name: 'Annotation',
                  decoration: const InputDecoration(
                      labelText: 'Additional Info (Optional)'),
                  // No validator is required for an optional field.
                  // For validation, you can add it if needed.
                ),
                const SizedBox(height: 10),
                if (image != null)
                  Image.file(
                    File(image.path),
                    height: 380,
                    width: 260,
                  ),
                FormBuilderTextField(
                  name: 'Location',
                  readOnly: true,
                  initialValue:
                      'Lat: ${userLocation.latitude}, Long: ${userLocation.longitude}',
                  decoration: const InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(fontSize: 8)),
                  style: const TextStyle(fontSize: 8),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formData = _formKey.currentState!.value;
                      print(formData);

                      if (image != null) {
                        final imagePath = image.path;
                        print('Image Path: $imagePath');
                      }

                      if (_formKey.currentState!.saveAndValidate()) {
                        final formData = _formKey.currentState!.value;
                        submitReport(context, formData, image);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Text('Submit Report'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
