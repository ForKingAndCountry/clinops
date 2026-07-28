import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/service_locator.dart';
import '../repositories/patient_repository.dart';
import '../models/patient.dart';
import '../widgets/shared_widgets.dart';

class FindPatientScreen extends StatefulWidget {
  const FindPatientScreen({super.key});

  @override
  State<FindPatientScreen> createState() => _FindPatientScreenState();
}

class _FindPatientScreenState extends State<FindPatientScreen> {
  final PatientRepository _patientRepository = getIt<PatientRepository>();
  final _searchController = TextEditingController();
  
  List<Patient> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchPatients() async {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _searchResults = [];
    });

    try {
      final results = await _patientRepository.search(query);
      
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _viewPatientChart(Patient patient) {
    Navigator.pushNamed(
      context,
      '/patient-chart',
      arguments: {'patientId': patient.id, 'hospitalId': patient.hospitalId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Patient'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.pushNamed(context, '/patient-registration');
            },
            tooltip: 'Register New Patient',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by ID, name, phone, or DOB+community',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchResults = [];
                                  _errorMessage = null;
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => _searchPatients(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isSearching ? null : _searchPatients,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  child: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Search'),
                ),
              ],
            ),
          ),

          // Search Tips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8,
              children: [
                _buildSearchTip('Hospital ID'),
                _buildSearchTip('Name'),
                _buildSearchTip('Phone'),
                _buildSearchTip('DOB + Community'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTip(String tip) {
    return Chip(
      label: Text(tip, style: const TextStyle(fontSize: 12)),
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
    );
  }

  Widget _buildResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: $_errorMessage',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchPatients,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_searchController.text.isEmpty) {
      return EmptyState(
        icon: Icons.search,
        title: 'Search for a Patient',
        subtitle: 'Enter a hospital ID, name, phone number, or date of birth with community to find a patient.',
        action: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/patient-registration');
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Register New Patient'),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return EmptyState(
        icon: Icons.person_search,
        title: 'No Patients Found',
        subtitle: 'No patients match your search. Try different criteria or register a new patient.',
        action: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/patient-registration');
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Register New Patient'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final patient = _searchResults[index];
        return PatientHeaderCard(
          hospitalId: patient.hospitalId,
          name: patient.fullName,
          dateOfBirth: DateFormat('dd MMM yyyy').format(patient.dateOfBirth),
          phone: patient.phone,
          community: patient.community,
          onTap: () => _viewPatientChart(patient),
        );
      },
    );
  }
}
