import 'dart:typed_data';

import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/theater.dart';
import 'package:flutix/services/theater_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

class MapScreen extends StatefulWidget {
  final LocationData currentLocation;

  MapScreen({this.currentLocation});
  
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  Map<String, Marker> _markers = {};
  BitmapDescriptor theaterIcon;
  LocationData currentLocation;
  Location location;
  
  @override
  void initState() {
    super.initState();

    location = new Location();
    currentLocation = widget.currentLocation ?? LocationData.fromMap({"latitude": 0, "longitude": 0});

    setInitialLocation();
    setIcons();
   
    /*
    location.onLocationChanged.listen((LocationData currentLocation) {
      print('current');
      print(currentLocation);
      if (isMounted) {
        setState(() {
          currentLocation = currentLocation;
        });
      } else {
        currentLocation = currentLocation;
      }
    });
    */
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    
    final List<Theater> theaters = await TheaterService.getTheaters();
    setState(() {
      _markers.clear();
      for (final theater in theaters) {
        final marker = Marker(
          markerId: MarkerId(theater.name),
          position: LatLng(theater.lat, theater.lng),
          infoWindow: InfoWindow(
            title: theater.name,
            snippet: theater.location,
          ),
          icon: theaterIcon
        );
        _markers[theater.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalization.of(context).theater),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    setState(() {});
  }

  void setIcons() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/logo.png', 100);
    theaterIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }
}