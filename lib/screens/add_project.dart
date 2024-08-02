import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../services/firestore_service.dart';

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _deadlineController = TextEditingController();
  List<TextEditingController> _phaseControllers = [];
  final TextEditingController _fullPaymentController = TextEditingController();
  final TextEditingController _completedPaymentController = TextEditingController();
  String? _selectedFreelancerId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService(); // Initialize your service

  Future<List<Map<String, dynamic>>> _fetchFreelancers() async {
    final snapshot = await _firestore.collection('freelancers').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  void _addProject() async {
    final name = _nameController.text;
    final startDate = _startDate;
    final endDate = _endDate;
    final deadline = int.tryParse(_deadlineController.text) ?? 0;
    final phases = _phaseControllers.map((c) => c.text).toList();
    final fullPayment = double.tryParse(_fullPaymentController.text) ?? 0.0;
    final completedPayment = double.tryParse(_completedPaymentController.text) ?? 0.0;
    final remainingPayment = fullPayment - completedPayment;
    final freelancerId = _selectedFreelancerId;

    if (name.isNotEmpty && startDate != null && endDate != null) {
      // Add project to Firestore
      final projectRef = await _firestore.collection('projects').add({
        'name': name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'deadline': deadline,
        'phases': phases,
        'fullPayment': fullPayment,
        'completedPayment': completedPayment,
        'remainingPayment': remainingPayment,
        'assignedTo': freelancerId,
        'status': 'Not Started',
      });

      // If assigned to a freelancer, update freelancer's assignedProjects
      if (freelancerId != null) {
        await _firestore.collection('freelancers').doc(freelancerId).update({
          'assignedProjects': FieldValue.arrayUnion([projectRef.id]),
        });
      }

      Get.snackbar('Success', 'Project added successfully');
      _clearFields();
    } else {
      Get.snackbar('Error', 'Please fill all required fields');
    }
  }

  void _clearFields() {
    _nameController.clear();
    _startDate = null;
    _endDate = null;
    _deadlineController.clear();
    _phaseControllers.clear();
    _fullPaymentController.clear();
    _completedPaymentController.clear();
    _selectedFreelancerId = null;
    setState(() {});
  }

  void _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Widget _buildPhaseField(int index) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _phaseControllers[index],
            decoration: InputDecoration(labelText: 'Phase ${index + 1}'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove_circle),
          onPressed: () {
            setState(() {
              _phaseControllers.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _phaseControllers.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Project Name'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _startDate == null
                        ? 'Select Start Date'
                        : 'Start Date: ${_startDate!.toLocal()}'.split(' ')[0],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectStartDate(context),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _endDate == null
                        ? 'Select End Date'
                        : 'End Date: ${_endDate!.toLocal()}'.split(' ')[0],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectEndDate(context),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _deadlineController,
              decoration: InputDecoration(labelText: 'Deadline (in days)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ...List.generate(_phaseControllers.length, _buildPhaseField),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Phase'),
                onPressed: () {
                  setState(() {
                    _phaseControllers.add(TextEditingController());
                  });
                },
              ),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchFreelancers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No freelancers available.'));
                }

                final freelancers = snapshot.data!;
                return DropdownButtonFormField<String>(
                  value: _selectedFreelancerId,
                  hint: Text('Select Freelancer'),
                  items: freelancers.map((freelancer) {
                    final id = freelancer['id'] as String? ?? '';
                    final email = freelancer['email'] as String? ?? 'Unknown';
                    return DropdownMenuItem<String>(
                      value: id,
                      child: Text(email),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFreelancerId = value;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _fullPaymentController,
              decoration: InputDecoration(labelText: 'Full Payment Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _completedPaymentController,
              decoration: InputDecoration(labelText: 'Completed Payment Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addProject,
              child: Text('Add Project'),
            ),
          ],
        ),
      ),
    );
  }
}
