import 'dart:async';
import 'dart:math';
import '../patient_repository.dart';
import '../../models/patient.dart';
import '../../models/visit.dart';

class MockPatientRepository implements PatientRepository {
  final Map<int, Patient> _patients = {};
  final Map<int, List<Visit>> _patientVisits = {};
  int _nextId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockPatientRepository() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    
    // Seeded patients with authentic Liberian names
    final seedPatients = [
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-001',
        firstName: 'Kofi',
        lastName: 'Johnson',
        normalized_name: 'kofi johnson',
        dateOfBirth: DateTime(1985, 3, 15),
        phone: '+231 77 123 4567',
        community: 'Monrovia',
        address: '12 Broad Street, Monrovia',
        emergencyContactName: 'Mariama Johnson',
        emergencyContactPhone: '+231 77 123 4568',
        allergies: 'Penicillin',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-002',
        firstName: 'Fatima',
        lastName: 'Kromah',
        normalized_name: 'fatima kromah',
        dateOfBirth: DateTime(1992, 7, 22),
        phone: '+231 88 234 5678',
        community: 'Buchanan',
        address: '45 Main Road, Buchanan',
        emergencyContactName: 'Mohammed Kromah',
        emergencyContactPhone: '+231 88 234 5679',
        allergies: null,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-003',
        firstName: 'James',
        lastName: 'Weah',
        normalized_name: 'james weah',
        dateOfBirth: DateTime(1978, 11, 8),
        phone: '+231 66 345 6789',
        community: 'Gbarnga',
        address: '78 Market Street, Gbarnga',
        emergencyContactName: 'Sarah Weah',
        emergencyContactPhone: '+231 66 345 6790',
        allergies: 'Aspirin',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-004',
        firstName: 'Aminata',
        lastName: 'Kamara',
        normalized_name: 'aminata kamara',
        dateOfBirth: DateTime(2000, 1, 30),
        phone: '+231 55 456 7890',
        community: 'Kakata',
        address: '23 School Road, Kakata',
        emergencyContactName: 'Ibrahim Kamara',
        emergencyContactPhone: '+231 55 456 7891',
        allergies: null,
        createdAt: now.subtract(const Duration(days: 18)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-005',
        firstName: 'Boakai',
        lastName: 'Sesay',
        normalized_name: 'boakai sesay',
        dateOfBirth: DateTime(1965, 5, 12),
        phone: '+231 77 567 8901',
        community: 'Monrovia',
        address: '56 Tubman Boulevard, Monrovia',
        emergencyContactName: 'Zainab Sesay',
        emergencyContactPhone: '+231 77 567 8902',
        allergies: 'Sulfa drugs',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
      // Deliberately messy record - misspelled name
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-006',
        firstName: 'Mariama', // Will have duplicate with different spelling
        lastName: 'Jonson', // Misspelled Johnson
        normalized_name: 'mariama jonson',
        dateOfBirth: DateTime(1990, 8, 15),
        phone: '+231 88 678 9012',
        community: 'Monrovia',
        address: '12 Broad Street, Monrovia',
        emergencyContactName: 'Kofi Jonson',
        emergencyContactPhone: '+231 88 678 9013',
        allergies: null,
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-007',
        firstName: 'Sarah',
        lastName: 'Tolbert',
        normalized_name: 'sarah tolbert',
        dateOfBirth: DateTime(1988, 4, 3),
        phone: '+231 66 789 0123',
        community: 'Harper',
        address: '34 Coastal Road, Harper',
        emergencyContactName: 'William Tolbert',
        emergencyContactPhone: '+231 66 789 0124',
        allergies: 'Latex',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      ),
      // Missing phone number
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-008',
        firstName: 'Mohammed',
        lastName: 'Bah',
        normalized_name: 'mohammed bah',
        dateOfBirth: DateTime(1975, 9, 20),
        phone: null,
        community: 'Voinjama',
        address: '89 Forest Road, Voinjama',
        emergencyContactName: 'Aisha Bah',
        emergencyContactPhone: '+231 77 890 1234',
        allergies: null,
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-009',
        firstName: 'Elizabeth',
        lastName: 'Doe',
        normalized_name: 'elizabeth doe',
        dateOfBirth: DateTime(1995, 2, 14),
        phone: '+231 55 901 2345',
        community: 'Monrovia',
        address: '91 Capitol Hill, Monrovia',
        emergencyContactName: 'John Doe',
        emergencyContactPhone: '+231 55 901 2346',
        allergies: 'Peanuts',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now,
      ),
      // Very similar name to patient 9
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-010',
        firstName: 'Elisabeth', // Different spelling
        lastName: 'Dough', // Similar to Doe
        normalized_name: 'elisabeth dough',
        dateOfBirth: DateTime(1995, 2, 14),
        phone: '+231 55 901 2347',
        community: 'Monrovia',
        address: '91 Capitol Hill, Monrovia',
        emergencyContactName: 'John Dough',
        emergencyContactPhone: '+231 55 901 2348',
        allergies: null,
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-011',
        firstName: 'Samuel',
        lastName: 'Kollie',
        normalized_name: 'samuel kollie',
        dateOfBirth: DateTime(1982, 6, 25),
        phone: '+231 77 012 3456',
        community: 'Greenville',
        address: '12 Port Road, Greenville',
        emergencyContactName: 'Rebecca Kollie',
        emergencyContactPhone: '+231 77 012 3457',
        allergies: null,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-012',
        firstName: 'Grace',
        lastName: 'Taylor',
        normalized_name: 'grace taylor',
        dateOfBirth: DateTime(1970, 12, 10),
        phone: '+231 88 123 4567',
        community: 'Monrovia',
        address: '45 Sinkor Road, Monrovia',
        emergencyContactName: 'Robert Taylor',
        emergencyContactPhone: '+231 88 123 4568',
        allergies: 'Codeine',
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-013',
        firstName: 'David',
        lastName: 'Morris',
        normalized_name: 'david morris',
        dateOfBirth: DateTime(1989, 3, 5),
        phone: '+231 66 234 5678',
        community: 'Bensonville',
        address: '67 Highway, Bensonville',
        emergencyContactName: 'Linda Morris',
        emergencyContactPhone: '+231 66 234 5679',
        allergies: null,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-014',
        firstName: 'Hawa',
        lastName: 'Konneh',
        normalized_name: 'hawa konneh',
        dateOfBirth: DateTime(1998, 10, 18),
        phone: '+231 55 345 6789',
        community: 'Tubmanburg',
        address: '23 Bomi Road, Tubmanburg',
        emergencyContactName: 'Sekou Konneh',
        emergencyContactPhone: '+231 55 345 6790',
        allergies: 'Dust mites',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-015',
        firstName: 'Emmanuel',
        lastName: 'Dennis',
        normalized_name: 'emmanuel dennis',
        dateOfBirth: DateTime(1972, 7, 30),
        phone: '+231 77 456 7890',
        community: 'Monrovia',
        address: '78 Old Road, Monrovia',
        emergencyContactName: 'Martha Dennis',
        emergencyContactPhone: '+231 77 456 7891',
        allergies: 'Shellfish',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-016',
        firstName: 'Ruth',
        lastName: 'Williams',
        normalized_name: 'ruth williams',
        dateOfBirth: DateTime(1984, 5, 22),
        phone: '+231 88 567 8901',
        community: 'Harper',
        address: '56 Fish Market, Harper',
        emergencyContactName: 'George Williams',
        emergencyContactPhone: '+231 88 567 8902',
        allergies: null,
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-017',
        firstName: 'Joseph',
        lastName: 'Brown',
        normalized_name: 'joseph brown',
        dateOfBirth: DateTime(1968, 9, 14),
        phone: '+231 66 678 9012',
        community: 'Gbarnga',
        address: '34 Education Center, Gbarnga',
        emergencyContactName: 'Mary Brown',
        emergencyContactPhone: '+231 66 678 9013',
        allergies: 'Penicillin, Sulfa',
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-018',
        firstName: 'Beatrice',
        lastName: 'Cole',
        normalized_name: 'beatrice cole',
        dateOfBirth: DateTime(1991, 1, 8),
        phone: '+231 55 789 0123',
        community: 'Kakata',
        address: '12 Mission Road, Kakata',
        emergencyContactName: 'Samuel Cole',
        emergencyContactPhone: '+231 55 789 0124',
        allergies: null,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-019',
        firstName: 'Francis',
        lastName: 'Sawyer',
        normalized_name: 'francis sawyer',
        dateOfBirth: DateTime(1979, 11, 28),
        phone: '+231 77 890 1234',
        community: 'Monrovia',
        address: '90 UN Drive, Monrovia',
        emergencyContactName: 'Evelyn Sawyer',
        emergencyContactPhone: '+231 77 890 1235',
        allergies: 'Iodine',
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now,
      ),
      Patient(
        id: _nextId++,
        hospitalId: 'PT-2024-020',
        firstName: 'Louise',
        lastName: 'Barclay',
        normalized_name: 'louise barclay',
        dateOfBirth: DateTime(1996, 4, 17),
        phone: '+231 88 901 2345',
        community: 'Buchanan',
        address: '45 Palm Street, Buchanan',
        emergencyContactName: 'James Barclay',
        emergencyContactPhone: '+231 88 901 2346',
        allergies: null,
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now,
      ),
    ];

    for (var patient in seedPatients) {
      _patients[patient.id!] = patient;
    }
  }

  Future<void> _simulateDelay() async {
    final delay = 300 + _random.nextInt(500); // 300-800ms
    await Future.delayed(Duration(milliseconds: delay));
  }

  void _maybeThrowError() {
    if (_simulateErrors && _random.nextDouble() < 0.1) {
      throw Exception('Simulated network error');
    }
  }

  void setSimulateErrors(bool simulate) {
    _simulateErrors = simulate;
  }

  @override
  Future<List<Patient>> search(String query) async {
    await _simulateDelay();
    _maybeThrowError();

    final normalizedQuery = query.toLowerCase().trim();
    
    if (normalizedQuery.isEmpty) {
      return [];
    }

    final results = _patients.values.where((patient) {
      // Search by hospital ID
      if (patient.hospitalId.toLowerCase().contains(normalizedQuery)) {
        return true;
      }
      
      // Search by normalized name
      if (patient.normalized_name.contains(normalizedQuery)) {
        return true;
      }
      
      // Search by phone
      if (patient.phone != null && patient.phone!.contains(normalizedQuery)) {
        return true;
      }
      
      // Search by DOB (format: YYYY-MM-DD)
      final dobString = '${patient.dateOfBirth.year}-${patient.dateOfBirth.month.toString().padLeft(2, '0')}-${patient.dateOfBirth.day.toString().padLeft(2, '0')}';
      if (dobString.contains(normalizedQuery)) {
        return true;
      }
      
      // Search by community
      if (patient.community != null && patient.community!.toLowerCase().contains(normalizedQuery)) {
        return true;
      }
      
      // Search by DOB + Community (format: "YYYY-MM-DD community" or "community YYYY-MM-DD")
      final parts = normalizedQuery.split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        bool dobMatch = false;
        bool communityMatch = false;
        
        for (final part in parts) {
          // Check if this part looks like a date (YYYY-MM-DD format)
          if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(part)) {
            if (dobString == part) {
              dobMatch = true;
            }
          } else if (patient.community != null && patient.community!.toLowerCase().contains(part)) {
            communityMatch = true;
          }
        }
        
        if (dobMatch && communityMatch) {
          return true;
        }
      }
      
      return false;
    }).toList();

    return results;
  }

  @override
  Future<Patient> register(Patient patient) async {
    await _simulateDelay();
    _maybeThrowError();

    final newPatient = patient.copyWith(
      id: _nextId++,
      hospitalId: 'PT-2024-${_nextId.toString().padLeft(3, '0')}',
      normalized_name: '${patient.firstName.toLowerCase()} ${patient.lastName.toLowerCase()}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _patients[newPatient.id!] = newPatient;
    return newPatient;
  }

  @override
  Future<Patient?> getByHospitalId(String hospitalId) async {
    await _simulateDelay();
    _maybeThrowError();

    try {
      return _patients.values.firstWhere((p) => p.hospitalId == hospitalId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Patient?> getById(int id) async {
    await _simulateDelay();
    _maybeThrowError();

    return _patients[id];
  }

  @override
  Future<Map<String, dynamic>> getChart(int patientId) async {
    await _simulateDelay();
    _maybeThrowError();

    final patient = _patients[patientId];
    if (patient == null) {
      throw Exception('Patient not found');
    }

    final visits = _patientVisits[patientId] ?? [];

    return {
      'patient': patient.toJson(),
      'visits': visits.map((v) => v.toJson()).toList(),
    };
  }

  @override
  Future<List<Patient>> checkDuplicates(Patient patient) async {
    await _simulateDelay();
    _maybeThrowError();

    final normalized = '${patient.firstName.toLowerCase()} ${patient.lastName.toLowerCase()}';
    
    return _patients.values.where((p) {
      if (p.id == patient.id) return false; // Skip self
      
      // Check for similar normalized names (fuzzy match)
      if (_isSimilarName(p.normalized_name, normalized)) {
        return true;
      }
      
      // Check for same phone
      if (p.phone != null && p.phone == patient.phone) {
        return true;
      }
      
      // Check for same DOB
      if (p.dateOfBirth.year == patient.dateOfBirth.year &&
          p.dateOfBirth.month == patient.dateOfBirth.month &&
          p.dateOfBirth.day == patient.dateOfBirth.day) {
        return true;
      }
      
      return false;
    }).toList();
  }

  bool _isSimilarName(String name1, String name2) {
    // Simple similarity check - contains at least one matching name part
    final parts1 = name1.split(' ');
    final parts2 = name2.split(' ');
    
    for (var part1 in parts1) {
      for (var part2 in parts2) {
        if (part1.isNotEmpty && part2.isNotEmpty && 
            (part1.contains(part2) || part2.contains(part1))) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<Patient> update(Patient patient) async {
    await _simulateDelay();
    _maybeThrowError();

    if (patient.id == null || !_patients.containsKey(patient.id)) {
      throw Exception('Patient not found');
    }

    final updatedPatient = patient.copyWith(
      normalized_name: '${patient.firstName.toLowerCase()} ${patient.lastName.toLowerCase()}',
      updatedAt: DateTime.now(),
    );

    _patients[patient.id!] = updatedPatient;
    return updatedPatient;
  }

  // Helper method for VisitRepository to add visits
  void addVisitToPatient(int patientId, Visit visit) {
    if (!_patientVisits.containsKey(patientId)) {
      _patientVisits[patientId] = [];
    }
    _patientVisits[patientId]!.add(visit);
  }

  // Helper method to get patient visits
  List<Visit> getPatientVisitsSync(int patientId) {
    return _patientVisits[patientId] ?? [];
  }

  // Reset data to initial state
  void resetData() {
    _patients.clear();
    _patientVisits.clear();
    _nextId = 1;
    _seedData();
  }
}
