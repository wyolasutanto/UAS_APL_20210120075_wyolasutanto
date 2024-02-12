// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'technician.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> cleaningServices = [
    {'name': 'Basic Cleaning', 'price': 100000},
    {'name': 'Deep Cleaning', 'price': 150000},
    {'name': 'Peripheral Cleaning', 'price': 50000},
    {'name': 'Rakit PC', 'price': 150000},
  ];

  List<Map<String, dynamic>> originalOrder = [];

  bool ascendingOrder = true;
  String selectedDevice = 'PC';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    originalOrder.addAll(cleaningServices);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));

    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.lightBlueAccent,
        hintColor: Colors.lightBlueAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Techno Indie'),
        ),
        body: Column(
          children: [
            _buildPromoSlider(),
            _buildFilterButton(),
            Expanded(
              child: ListView.builder(
                itemCount: cleaningServices.length,
                itemBuilder: (context, index) {
                  final service = cleaningServices[index];
                  return _buildServiceCard(context, service, index);
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TechnicianScreen()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPromoSlider() {
  return SizedBox(
    height: 200,
    child: PageView.builder(
      itemCount: cleaningServices.length,
      itemBuilder: (context, index) {
        final promoImagePath = 'assets/promo_photo/promo${index + 1}.jpg';

        return Card(
          elevation: 3,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Menyesuaikan nilai ini untuk mengatur tajam atau tidaknya ujung
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              promoImagePath,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    ),
  );
}


  Widget _buildFilterButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            _showFilterOptions(context);
          },
          icon: const Icon(Icons.filter_list),
          label: const Text('Filter By'),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service, int index) {
  Color buttonColor =Colors.lightBlue.shade50;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () => _showConfirmationDialog(context, service),
      borderRadius: BorderRadius.circular(15.0), // Menyesuaikan nilai ini untuk mengatur tajam atau tidaknya ujung
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: buttonColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${NumberFormat('#,###').format(service['price'])}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}


  Future<void> _showConfirmationDialog(
    BuildContext context,
    Map<String, dynamic> service,
  ) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController brandController = TextEditingController();
    TextEditingController colorController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController methodController = TextEditingController();
    TextEditingController noteController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildTextField('Nama', nameController),
                _buildTextField('Alamat', addressController),
                _buildTextField('Telepon', phoneController),
                _buildTextField('Email', emailController),
                _buildDropdownField(
                  'Perangkat',
                  selectedDevice,
                  ['PC', 'Laptop'],
                  (String value) {
                    setState(() {
                      selectedDevice = value;
                    });
                  },
                ),
                _buildTextField('Merek Perangkat', brandController),
                _buildTextField('Warna Perangkat', colorController),
                _buildTextField('Quantity', quantityController),
                _buildTextField('Metode', methodController),
                _buildTextField('Catatan', noteController),
                _buildDateTimeField(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Order via WhatsApp'),
              onPressed: () {
                _launchWhatsApp(
                  context,
                  service,
                  nameController.text,
                  addressController.text,
                  phoneController.text,
                  emailController.text,
                  selectedDevice,
                  brandController.text,
                  colorController.text,
                  quantityController.text,
                  methodController.text,
                  noteController.text,
                  selectedDate,
                  selectedTime,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        controller: controller,
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: value,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateTimeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tanggal'),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8.0),
                  Text(
                    DateFormat('dd/MM/yyyy').format(selectedDate),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text('Waktu'),
          InkWell(
            onTap: () => _selectTime(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8.0),
                  Text(
                    selectedTime.format(context),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _launchWhatsApp(
    BuildContext context,
    Map<String, dynamic> service,
    String name,
    String address,
    String phone,
    String email,
    String device,
    String brand,
    String color,
    String quantity,
    String method,
    String note,
    DateTime selectedDate,
    TimeOfDay selectedTime,
  ) async {
    const phoneNumber = '+6287711456375';
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final formattedTime = selectedTime.format(context);
    final formattedPrice = NumberFormat('#,###').format(service['price']);
    final message =
        'Saya ingin memesan layanan ${service['name']} seharga Rp $formattedPrice pada $formattedDate pukul $formattedTime\n\n'
        'Informasi Pengguna:\n'
        'Nama: $name\n'
        'Alamat: $address\n'
        'Telepon: $phone\n'
        'Email: $email\n'
        'Perangkat: $device\n'
        'Merek Perangkat: $brand\n'
        'Warna Perangkat: $color\n'
        'Quantity: $quantity\n'
        'Metode: $method\n'
        'Catatan: $note';

    final whatsappUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

    if (await canLaunch(whatsappUrl)) {
  await launch(whatsappUrl);
} else {
  // Jika tidak dapat membuka WhatsApp, buka melalui browser
  final browserUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

  if (await canLaunch(browserUrl)) {
    await launch(browserUrl);
  } else {
    // Handle the case where both WhatsApp and browser cannot be launched.
    // ignore: avoid_print
    print('Could not launch $whatsappUrl or $browserUrl');
  }
}

  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Sort A to Z'),
              onTap: () {
                _sortByName(true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort Z to A'),
              onTap: () {
                _sortByName(false);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Price (Low to High)'),
              onTap: () {
                _sortByPrice(true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Price (High to Low)'),
              onTap: () {
                _sortByPrice(false);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _sortByName(bool ascending) {
    setState(() {
      cleaningServices.sort((a, b) =>
          ascending ? a['name'].compareTo(b['name']) : originalOrder.indexOf(b).compareTo(originalOrder.indexOf(a)));
      ascendingOrder = ascending;
    });
  }

  void _sortByPrice(bool ascending) {
    setState(() {
      cleaningServices.sort((a, b) =>
          ascending ? a['price'].compareTo(b['price']) : b['price'].compareTo(a['price']));
      ascendingOrder = ascending;
    });
  }
}
