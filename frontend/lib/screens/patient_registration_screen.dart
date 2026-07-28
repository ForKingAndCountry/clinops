import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/service_locator.dart';
import '../repositories/patient_repository.dart';
import '../models/patient.dart';
import '../widgets/shared_widgets.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final PatientRepository _patientRepository = getIt<PatientRepository>();
  
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _communityController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _allergiesController = TextEditingController();
  
  DateTime? _dateOfBirth;
  String? _selectedGender;
  List<Patient> _potentialDuplicates = [];
  bool _isCheckingDuplicates = false;
  bool _isRegistering = false;
  Patient? _registeredPatient;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _communityController.dispose();
    _addressController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _checkDuplicates() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCheckingDuplicates = true;
      _potentialDuplicates = [];
    });

    try {
      final patient = _buildPatient();
      final duplicates = await _patientRepository.checkDuplicates(patient);
      
      setState(() {
        _potentialDuplicates = duplicates;
        _isCheckingDuplicates = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingDuplicates = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking duplicates: $e')),
        );
      }
    }
  }

  Future<void> _registerPatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date of birth')),
      );
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      final patient = _buildPatient();
      final registered = await _patientRepository.register(patient);
      
      setState(() {
        _registeredPatient = registered;
        _isRegistering = false;
      });

      if (mounted) {
        _showRegistrationSuccessDialog();
      }
    } catch (e) {
      setState(() {
        _isRegistering = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error registering patient: $e')),
        );
      }
    }
  }

  Patient _buildPatient() {
    final now = DateTime.now();
    return Patient(
      hospitalId: '', // Will be auto-generated
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      normalized_name: '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.toLowerCase(),
      dateOfBirth: _dateOfBirth!,
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      community: _communityController.text.trim().isEmpty ? null : _communityController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      emergencyContactName: _emergencyContactNameController.text.trim().isEmpty ? null : _emergencyContactNameController.text.trim(),
      emergencyContactPhone: _emergencyContactPhoneController.text.trim().isEmpty ? null : _emergencyContactPhoneController.text.trim(),
      allergies: _allergiesController.text.trim().isEmpty ? null : _allergiesController.text.trim(),
      createdAt: now,
      updatedAt: now,
    );
  }

  void _showRegistrationSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Patient Registered'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hospital ID: ${_registeredPatient!.hospitalId}'),
            const SizedBox(height: 8),
            Text('Name: ${_registeredPatient!.fullName}'),
            const SizedBox(height: 16),
            const Text('Patient ID Slip:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Icon(Icons.local_hospital, size: 48, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    'CLINIC MANAGEMENT SYSTEM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Patient ID',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _registeredPatient!.hospitalId,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _registeredPatient!.fullName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                    Text(
                    DateFormat('dd MMM yyyy').format(_registeredPatient!.dateOfBirth),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('Register Another'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    _communityController.clear();
    _addressController.clear();
    _emergencyContactNameController.clear();
    _emergencyContactPhoneController.clear();
    _allergiesController.clear();
    setState(() {
      _dateOfBirth = null;
      _selectedGender = null;
      _potentialDuplicates = [];
      _registeredPatient = null;
    });
  }

  Future<void> _selectDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 120)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Registration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name *',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name *',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDateOfBirth,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth *',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dateOfBirth != null
                        ? DateFormat('dd MMM yyyy').format(_dateOfBirth!)
                        : 'Select date of birth',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender *',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedGender,
                items: _genders.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),

              // Contact Information Section
              const SizedBox(height: 24),
              _buildSectionHeader('Contact Information'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _communityController,
                decoration: const InputDecoration(
                  labelText: 'Community',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              // Emergency Contact Section
              const SizedBox(height: 24),
              _buildSectionHeader('Emergency Contact'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emergencyContactNameController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact Name',
                  prefixIcon: Icon(Icons.contact_phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emergencyContactPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact Phone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),

              // Medical Information Section
              const SizedBox(height: 24),
              _buildSectionHeader('Medical Information'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(
                  labelText: 'Allergies',
                  prefixIcon: Icon(Icons.warning),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              // Duplicate Check Section
              const SizedBox(height: 24),
              if (_potentialDuplicates.isNotEmpty) ...[
                _buildSectionHeader('Potential Duplicates Found'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Found ${_potentialDuplicates.length} potential duplicate(s)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._potentialDuplicates.map((duplicate) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: PatientHeaderCard(
                            hospitalId: duplicate.hospitalId,
                            name: duplicate.fullName,
                            dateOfBirth: DateFormat('dd MMM yyyy').format(duplicate.dateOfBirth),
                            phone: duplicate.phone,
                            community: duplicate.community,
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _potentialDuplicates = [];
                                });
                              },
                              child: const Text('Ignore & Continue'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('Cancel Registration'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                OutlinedButton.icon(
                  onPressed: _isCheckingDuplicates ? null : _checkDuplicates,
                  icon: _isCheckingDuplicates
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(_isCheckingDuplicates ? 'Checking...' : 'Check for Duplicates'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],

              // Register Button
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isRegistering ? null : _registerPatient,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: _isRegistering
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text('Registering...'),
                        ],
                      )
                    : const Text('Register Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
