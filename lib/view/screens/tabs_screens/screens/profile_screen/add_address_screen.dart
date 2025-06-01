// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/models/address/user_address_model.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/profile_screen/full_map_screen.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String selectedCategory = 'Home';
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(31.2001, 29.9187);
  LatLng _selectedPosition = const LatLng(31.2001, 29.9187);
  Set<Marker> _markers = {};
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  late CameraPosition _currentCameraPosition;

  final TextEditingController addressController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingNumController = TextEditingController();
  final TextEditingController floorNumController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController additionalDataController =
      TextEditingController();

  // Zone search functionality
  final TextEditingController zoneSearchController = TextEditingController();
  bool _showZoneDropdown = false;
  String? selectedZoneName;

  String? selectedCityId; // Added city selection
  String? selectedZoneId;

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace('AIzaSyB-kzfDQwe8y7wLKX6l5Ld6-ntnJSCd5II');
    _determinePosition();
    _currentCameraPosition = CameraPosition(
      target: _initialPosition,
      zoom: 14,
    );

    // Add listener to hide dropdown when tapping outside
    zoneSearchController.addListener(() {
      if (zoneSearchController.text.isEmpty) {
        setState(() {
          selectedZoneId = null;
          selectedZoneName = null;
        });
      }
    });

    // Fetch addresses to get cities and zones data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresses(context);
    });
  }

  @override
  void dispose() {
    addressController.dispose();
    streetController.dispose();
    buildingNumController.dispose();
    floorNumController.dispose();
    apartmentController.dispose();
    additionalDataController.dispose();
    zoneSearchController.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _selectedPosition = _initialPosition;
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _initialPosition,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_initialPosition),
    );

    await _getAddressFromLatLng(_initialPosition);
  }

  String? mapLink;

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';

      setState(() {
        addressController.text = address;
        mapLink =
            'https://www.google.com/maps?q=${position.latitude},${position.longitude}';
      });
    } catch (e) {
      addressController.text = 'Unable to get address';
      mapLink = null;
    }
  }

  Future<void> _selectPlace(String placeId) async {
    final details = await googlePlace.details.get(placeId);
    if (details != null && details.result != null) {
      final location = details.result!.geometry!.location;
      if (location != null) {
        final lat = location.lat ?? 0.0;
        final lng = location.lng ?? 0.0;
        LatLng selectedLatLng = LatLng(lat, lng);

        _mapController?.animateCamera(CameraUpdate.newLatLng(selectedLatLng));
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('searchLocation'),
              position: selectedLatLng,
              infoWindow: InfoWindow(title: details.result!.name),
            ),
          );
        });

        await _getAddressFromLatLng(selectedLatLng);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context, S.of(context).add_address),
      body: GestureDetector(
        onTap: () {
          // Hide zone dropdown when tapping outside
          setState(() {
            _showZoneDropdown = false;
          });
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              child: Column(children: [
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: GoogleMap(
                                  onMapCreated: (controller) {
                                    _mapController = controller;
                                  },
                                  initialCameraPosition: _currentCameraPosition,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  markers: _markers,
                                  zoomGesturesEnabled: true,
                                  scrollGesturesEnabled: true,
                                  tiltGesturesEnabled: true,
                                  rotateGesturesEnabled: true,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: IconButton(
                                icon: const Icon(Icons.fullscreen),
                                color: Colors.black,
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenMapScreen(
                                        initialPosition: _currentCameraPosition,
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    final selectedLocation =
                                        result['location'] as LatLng;
                                    final selectedAddress =
                                        result['address'] as String;

                                    setState(() {
                                      // Update camera position
                                      _currentCameraPosition = CameraPosition(
                                        target: selectedLocation,
                                        zoom: 14,
                                      );
                                      _markers.clear();
                                      _markers.add(
                                        Marker(
                                          markerId: MarkerId(
                                              S.of(context).selected_address),
                                          position: selectedLocation,
                                          infoWindow: InfoWindow(
                                              title: selectedAddress),
                                        ),
                                      );

                                      addressController.text = selectedAddress;
                                    });

                                    // Animate the map to the new location
                                    _mapController!.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          _currentCameraPosition),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: S.of(context).selected_address,
                            filled: true,
                            fillColor: Colors.grey.shade100, // Background color
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                              borderSide:
                                  BorderSide.none, // Removes the outline border
                            ),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(predictions[index].description ?? ""),
                              onTap: () {
                                _selectPlace(predictions[index].placeId!);
                                setState(() => predictions.clear());
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCategoryButton(context, S.of(context).home),
                            _buildCategoryButton(context, S.of(context).work),
                            _buildCategoryButton(context, S.of(context).other),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // City Dropdown
                        _buildCityDropdownField(context, 'Select City'),
                        const SizedBox(height: 16),
                        // Zone Dropdown (filtered by selected city)
                        _buildZoneDropdownField(
                            context, S.of(context).select_zone),
                        const SizedBox(height: 16),
                        _buildTextField(context, S.of(context).street,
                            controller: streetController, isRequired: true),
                        const SizedBox(height: 16),
                        _buildTextField(context, S.of(context).building_no,
                            controller: buildingNumController,
                            isRequired: true),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                  context, S.of(context).floor_no,
                                  controller: floorNumController,
                                  isRequired: true),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                  context, S.of(context).apartment,
                                  controller: apartmentController,
                                  isRequired: true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(context, S.of(context).additional_data,
                            controller: additionalDataController),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      if (streetController.text.isEmpty ||
                                          buildingNumController.text.isEmpty ||
                                          floorNumController.text.isEmpty ||
                                          apartmentController.text.isEmpty ||
                                          selectedCityId == null ||
                                          selectedZoneId == null) {
                                        showTopSnackBar(
                                          context,
                                          'Please fill all the required fields',
                                          Icons.warning_outlined,
                                          maincolor,
                                          const Duration(seconds: 4),
                                        );
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        return;
                                      }

                                      try {
                                        await Provider.of<AddressProvider>(
                                                context,
                                                listen: false)
                                            .addAddress(
                                          context: context,
                                          cityId: int.parse(selectedCityId!),
                                          mapLink: mapLink ?? '',
                                          zoneId: int.parse(selectedZoneId!),
                                          address: addressController.text,
                                          street: streetController.text,
                                          buildingNum:
                                              buildingNumController.text,
                                          floorNum: floorNumController.text,
                                          apartment: apartmentController.text,
                                          additionalData:
                                              additionalDataController.text,
                                          type: selectedCategory,
                                        );

                                        String googleMapsLink =
                                            "https://www.google.com/maps?q=${_selectedPosition.latitude},${_selectedPosition.longitude}";
                                        debugPrint(
                                            "Google Maps Link: $googleMapsLink");
                                      } finally {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: maincolor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    S.of(context).save_address,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ])),
        ),
      ),
    );
  }

  // Updated City Dropdown Widget
  Widget _buildCityDropdownField(BuildContext context, String label) {
    return Consumer<AddressProvider>(
      builder: (context, provider, child) {
        return DropdownButtonFormField<String>(
          value: selectedCityId,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          items: provider.cities.map((City city) {
            return DropdownMenuItem(
              value: city.id.toString(),
              child: Text(city.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCityId = value;
              // Clear zone selection when city changes
              selectedZoneId = null;
              selectedZoneName = null;
              zoneSearchController.clear();
              _showZoneDropdown = false;
            });
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Please select a city' : null,
        );
      },
    );
  }

  // New Searchable Zone Dropdown Widget
  Widget _buildZoneDropdownField(BuildContext context, String label) {
    return Consumer<AddressProvider>(
      builder: (context, provider, child) {
        List<Zone> allZones = selectedCityId != null
            ? provider.getZonesByCityId(int.parse(selectedCityId!))
            : [];

        // Filter zones based on search query
        List<Zone> filteredZones = allZones;
        if (zoneSearchController.text.isNotEmpty) {
          filteredZones = allZones
              .where((zone) => zone.zone
                  .toLowerCase()
                  .contains(zoneSearchController.text.toLowerCase()))
              .toList();
        }

        return Column(
          children: [
            // Search TextField
            TextFormField(
              controller: zoneSearchController,
              decoration: InputDecoration(
                hintText: selectedZoneName ?? label,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(
                  _showZoneDropdown
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ),
              readOnly: selectedCityId == null,
              onTap: selectedCityId != null
                  ? () {
                      setState(() {
                        _showZoneDropdown = !_showZoneDropdown;
                      });
                    }
                  : null,
              onChanged: selectedCityId != null
                  ? (value) {
                      setState(() {
                        _showZoneDropdown = true;
                      });
                    }
                  : null,
              validator: (value) => selectedZoneId == null
                  ? S.of(context).please_select_zone
                  : null,
            ),

            // Dropdown List
            if (_showZoneDropdown && selectedCityId != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                child: filteredZones.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No zones found',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredZones.length,
                        itemBuilder: (context, index) {
                          final zone = filteredZones[index];
                          // Find the original index in allZones for proper ID mapping
                          final originalIndex = allZones.indexOf(zone);
                          return ListTile(
                            title: Text(
                              zone.zone,
                              style: const TextStyle(fontSize: 14),
                            ),
                            onTap: () {
                              setState(() {
                                selectedZoneId = originalIndex.toString();
                                selectedZoneName = zone.zone;
                                zoneSearchController.text = zone.zone;
                                _showZoneDropdown = false;
                              });
                            },
                            dense: true,
                          );
                        },
                      ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label, {
    TextEditingController? controller,
    bool isRequired = false,
  }) {
    controller ??= TextEditingController();

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: isRequired
          ? (value) =>
              value == null || value.isEmpty ? 'This field is required' : null
          : null,
      onChanged: (value) {
        // Keep the cursor at the end of the text
        controller!.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );
  }

  Widget _buildCategoryButton(BuildContext context, String label) {
    final bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? maincolor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: maincolor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : maincolor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
