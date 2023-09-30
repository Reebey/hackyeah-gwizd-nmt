import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Map App'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                // Handle dashboard navigation
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
              title: Text('Filters'),
              onTap: () {
                // Handle filter navigation
                Navigator.pop(context);
              },
            ),
            // Add filter options here
          ],
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(50.0500, 19.9440), // Initial map position
          zoom: 13.0, // Zoom level
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
                point: LatLng(51.5, -0.09), // Marker position
                builder: (ctx) => Container(
                  child: Icon(
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Handle button action (e.g., report)
      //   },
      //   child: Icon(Icons.add),
      // ),
      bottomNavigationBar: BottomAppBar(
          // Add a bottom app bar with navigation items or additional buttons if needed
          ),
    );
  }
}
