import 'dart:async';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:flutter_application_1/ui/pages/imgtobytes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  final initialCameraPosition = const CameraPosition(
    target: LatLng(-0.2053476, -78.4894387),
    zoom: 15,
  );

  final _locIcon = Completer<BitmapDescriptor>();

  HomeController() {
    imageToBytes(
      'assets/loc_taxi.png',
      width: 130,
      fromNetwork: true,
    ).then(
      (value) {
        final bitmap = BitmapDescriptor.fromBytes(value);
        _locIcon.complete(bitmap);
      },
    );
  }

  void onMapCreated(GoogleMapController controller) {}

  void onTap(LatLng position) async {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);

    final icon = await _locIcon.future;

    final marker = Marker(
      markerId: markerId,
      position: position,
      draggable: true,
      icon: icon,
      // anchor: const Offset(0.5, 1),
      onTap: () {
        _markersController.sink.add(id);
      },
      onDragEnd: (newPosition) {
        print("new position $newPosition");
      },
    );
    _markers[markerId] = marker;
    notifyListeners();
  }

  @override
  void dispose() {
    _markersController.close();
    super.dispose();
  }
}
