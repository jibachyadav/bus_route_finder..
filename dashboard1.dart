import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth
import 'login_page.dart';  // Import your LoginPage here

class Dashboard1 extends StatefulWidget {
  const Dashboard1({super.key});

  @override
  State<Dashboard1> createState() => _Dashboard1State();
}

class _Dashboard1State extends State<Dashboard1> {
  String? startingPoint;
  String? destination;
  bool isLoading = false;

  final List<String> startingLocations = [
    'Maitidevi',
    'Baneshwor',
    'Tinkune',
    'New Road',
    'Putlisadak',
  ];

  final List<String> destinationLocations = [
    'Goshalla',
    'Koteshwor',
    'Sinamangal',
    'Lagampat',
    'Turpurshwor',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100, // Increased AppBar height
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/bus.png',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Kathmandu Bus\nRoute Finder',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  height: 1.2,
                ),
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.teal, size: 30),
                  tooltip: "Logout",
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
                const Text(
                  'logout',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50), // <-- Increased top padding here
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.search, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Find Your Route',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Starting Point
                  _buildSearchableField(
                    'Starting Point',
                    'Select Starting location',
                    startingPoint,
                    (value) {
                      setState(() {
                        startingPoint = value;
                      });
                    },
                    startingLocations,
                  ),
                  const SizedBox(height: 20),
                  // Swap Icon
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          final temp = startingPoint;
                          startingPoint = destination;
                          destination = temp;
                        });
                      },
                      icon: const Icon(Icons.swap_vert, color: Colors.teal, size: 30),
                      tooltip: 'Swap Starting and Destination',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Destination
                  _buildSearchableField(
                    'Destination',
                    'Select Destination',
                    destination,
                    (value) {
                      setState(() {
                        destination = value;
                      });
                    },
                    destinationLocations,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (startingPoint != null && destination != null) {
                          if (startingPoint == destination) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Starting point and destination cannot be the same.'),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          await Future.delayed(const Duration(seconds: 2));

                          setState(() {
                            isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Finding route from $startingPoint to $destination'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select both starting and destination points'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      icon: Image.asset('assets/bus.png', height: 30, width: 30),
                      label: Text(
                        isLoading ? 'Finding...' : 'Search',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchableField(String label, String hint, String? selectedValue, ValueChanged<String?> onChanged, List<String> locations) {
    return DropdownSearch<String>(
      selectedItem: selectedValue,
      items: locations,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(item),
          );
        },
      ),
      filterFn: (item, filter) => item.toLowerCase().contains(filter.toLowerCase()),
      onChanged: onChanged,
    );
  }
}
