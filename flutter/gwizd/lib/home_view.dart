import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gwizd/models/animal_model.dart';
import 'package:gwizd/models/point_model.dart';
import 'package:gwizd/utility/http_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

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
  bool isReportSubmitEnabled = true;

  late List<AnimalModel> animals = List.empty();
  late List<Point> dashboardPoints = List.empty();
  late List<Point> points = List.empty();

  late MapController mapController;
  String? selectedAnimal;
  Point? selectedPoint;

  @override
  void initState() {
    super.initState();

    mapController = MapController();
    fetchAnimals();
    fetchDashboardPoints();
    fetchPoints();
  }

  void centerMap(LatLng targetPoint) {
    mapController.move(targetPoint, 13.0); // 13.0 is the zoom level
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
                items: [
                  ...animals.map((animal) {
                    return DropdownMenuItem<String>(
                      value: animal.id.toString(),
                      child: Text(animal.name),
                    );
                  }).toList(),
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('None'),
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    selectedAnimal = value;
                  });
                },
              ),
            ),
            ...dashboardPoints
                .where((element) => selectedAnimal == null
                    ? true
                    : element.animal.id.toString() == selectedAnimal)
                .map<ListTile>((item) => ListTile(
                      title: Text(item.animal.name),
                      subtitle: Text(
                        DateFormat("HH:mm:ss yyyy-MM-dd")
                            .format(DateTime.parse(item.added)),
                      ),
                      onTap: () {
                        setState() {
                          selectedPoint = item;
                        }

                        centerMap(LatLng(item.latitude, item.longitude));

                        // Add your item click action here
                        Navigator.pop(context); // Close the drawer
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    )),
            // Add more dashboard items here
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('Localization'),
              subtitle: Text(
                  'Lat: ${selectedPoint?.latitude}, Long: ${selectedPoint?.longitude}'),
            ),
            ListTile(
              title: Text('Animal'),
              subtitle: Text(
                  'Name: ${selectedPoint?.animal.name}, Threat Level: ${selectedPoint?.animal.threatLevel}'),
            ),
            ListTile(
              title: Text('Images'),
              subtitle:
                  Text('Number of Images: ${selectedPoint?.images.length}'),
            ),
          ],
        ),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(50.0500, 19.9440),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          ...points.map<MarkerLayerOptions>((e) => MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 30.0,
                    height: 30.0,
                    point: LatLng(e.latitude, e.longitude),
                    builder: (ctx) => Container(
                      child: Icon(
                        Icons.location_on,
                        size: 50,
                        color: (e.animal.threatLevel == 1)
                            ? Colors.yellowAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              )),
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

  Future submitReport(
    BuildContext context,
    Map<String, dynamic> formData,
    XFile? image,
  ) async {
    final animal = formData['Animal'];
    final latMatch =
        RegExp(r'Lat: ([-+]?\d*\.\d+|\d+),').firstMatch(formData['Location']);
    final longMatch =
        RegExp(r'Long: ([-+]?\d*\.\d+|\d+)').firstMatch(formData['Location']);

    late double latitude;
    late double longitude;
    if (latMatch != null && longMatch != null) {
      latitude = double.parse(latMatch.group(1)!);
      longitude = double.parse(longMatch.group(1)!);
      print('Latitude: $latitude');
      print('Longitude: $longitude');
    } else {
      print('Invalid input string');
    }
    final annotation = formData['Annotation'];

    print(animal);
    print(annotation);

    final point = PointFVO(
        animalId: int.parse(animal),
        latitude: latitude,
        longitude: longitude,
        annotation: annotation);
    final response = await apiClient.postPoint(point);
    selectedPoint = Point.fromJson(json.decode(response.body));

    final imgIdResponse =
        await apiClient.postPointImage(selectedPoint!.id, image!);

    centerMap(LatLng(point.latitude, point.longitude));

    // Close the report dialog
    Navigator.pop(context);
  }

  Future<void> fetchAnimals() async {
    final response = await apiClient.getAnimals();
    final data = json.decode(response.body);
    setState(() {
      animals =
          data.map<AnimalModel>((json) => AnimalModel.fromJson(json)).toList();
    });
  }

  Future<void> fetchPoints() async {
    final response = await apiClient.getDashboardPoints();
    final data = json.decode(response.body);
    setState(() {
      points = data.map<Point>((json) => Point.fromJson(json)).toList();
    });
  }

  Future<void> fetchDashboardPoints() async {
    final response = await apiClient.getDashboardPoints();
    final data = json.decode(response.body);
    setState(() {
      dashboardPoints =
          data.map<Point>((json) => Point.fromJson(json)).toList();
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
                  onPressed: isReportButtonEnabled
                      ? () async {
                          print('dsaads');

                          if (_formKey.currentState!.saveAndValidate()) {
                            isReportSubmitEnabled = false;
                            final formData = _formKey.currentState!.value;
                            print('aa');
                            print(formData);

                            if (image != null) {
                              final imagePath = image.path;
                              print('Image Path: $imagePath');
                            }
                            print('bb');

                            await submitReport(context, formData, image);
                            print('dsds');
                            isReportSubmitEnabled = true;
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                  ),
                  child: !isReportButtonEnabled
                      ? const CircularProgressIndicator() // Show a loading indicator
                      : const Text('Submit Report'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
