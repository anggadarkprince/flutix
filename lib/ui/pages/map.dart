import 'dart:async';
import 'dart:typed_data';

import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/models/theater.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/provider_user.dart';
import 'package:flutix/services/theater_service.dart';
import 'package:flutix/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Theater> theaters;
  GoogleMapController mapController;
  Map<String, Marker> markers = {};
  BitmapDescriptor theaterIcon;
  LocationData currentLocation;
  Location location = new Location();
  StreamSubscription<LocationData> locationSubscription;
  bool isInitializing = true;
  bool isCenteringCamera = false;
  String mapStyle;
  User user;

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/static/map_style.txt').then((string) {
      mapStyle = string;
    });

    TheaterService.getTheaters().then((value) {
      if (mounted) {
        setState(() {
          theaters = value;
          if (currentLocation != null) {
            isInitializing = false;
          }
        });
      }
    });

    setIcons();
   
    locationSubscription = location.onLocationChanged.listen((LocationData loc) {
      if (mounted) {
        setState(() {
          currentLocation = loc;
          if (theaters != null) {
            isInitializing = false;
          }
        });
      }
      if (mapController != null && !isCenteringCamera) {
        isCenteringCamera = true;
        /*
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 12,
            ),
          ),
        );
        mapController.moveCamera(
          CameraUpdate.newLatLng(
            LatLng(currentLocation.latitude, currentLocation.longitude)
          )
        );
        */  
      }  
    });
    
  }

  @override
  void dispose() {
    super.dispose();
    locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      user = Provider.of<ProviderUser>(context).user;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalization.of(context).theater),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: isInitializing 
        ? SpinKitFadingCircle(
            size: 50,
            color: mainColor,
          )
        : GoogleMap(
            padding: EdgeInsets.all(10),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.setMapStyle(mapStyle);
              markers.clear();
              markers['_current_loc'] = Marker(
                markerId: MarkerId('_current_loc'),
                position: LatLng(currentLocation.latitude, currentLocation.longitude),
                infoWindow: InfoWindow(
                  title: user != null ? user.name : 'You',
                  snippet: 'Your current location',
                ),
              );
              for (final theater in theaters) {
                final marker = Marker(
                  markerId: MarkerId(theater.name),
                  position: LatLng(theater.lat, theater.lng),
                  infoWindow: InfoWindow(
                    title: theater.name,
                    snippet: theater.location,
                  ),
                  icon: theaterIcon,
                  onTap: () {
                    if (polylines.isNotEmpty) polylines.clear();
                    if (polylineCoordinates.isNotEmpty) polylineCoordinates.clear();
                    createPolylines(currentLocation, LocationData.fromMap({"latitude": theater.lat, "longitude": theater.lng}));
                  }
                );
                markers[theater.name] = marker;
              }
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 11.0,
            ),
            markers: markers.values.toSet(),
          ),
    );
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  void setIcons() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/logo.png', 75);
    theaterIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void createPolylines(LocationData start, LocationData destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDsw3vzwWoRGIWHwHKOkTAiygmq2lfMf3A',
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }
}