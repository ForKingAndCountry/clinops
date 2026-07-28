import 'dart:async';
import 'dart:math';
import '../admission_repository.dart';
import '../../models/admission.dart';
import '../../models/vitals_record.dart';
import '../../models/nursing_note.dart';

class MockAdmissionRepository implements AdmissionRepository {
  final Map<int, Admission> _admissions = {};
  int _nextAdmissionId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockAdmissionRepository() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    
    // Seed some active admissions for demo
    final seedAdmissions = [
      Admission(
        id: _nextAdmissionId++,
        patientId: 7, // Sarah Tolbert
        bedId: 1,
        admissionDate: now.subtract(const Duration(hours: 3)),
        dischargeDate: null,
        dischargeReason: null,
        admittingDoctorId: 1,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
    ];

    for (var admission in seedAdmissions) {
      _admissions[admission.id!] = admission;
    }
  }

  Future<void> _simulateDelay() async {
    final delay = 300 + _random.nextInt(500);
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
  Future<Admission> admit(Admission admission) async {
    await _simulateDelay();
    _maybeThrowError();

    final newAdmission = admission.copyWith(
      id: _nextAdmissionId++,
      admissionDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _admissions[newAdmission.id!] = newAdmission;
    return newAdmission;
  }

  @override
  Future<Admission?> getById(int id) async {
    await _simulateDelay();
    _maybeThrowError();

    return _admissions[id];
  }

  @override
  Future<Admission?> getActiveAdmission(int patientId) async {
    await _simulateDelay();
    _maybeThrowError();

    try {
      return _admissions.values.firstWhere(
        (a) => a.patientId == patientId && a.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Admission> discharge(int admissionId, String reason) async {
    await _simulateDelay();
    _maybeThrowError();

    final admission = _admissions[admissionId];
    if (admission == null) {
      throw Exception('Admission not found');
    }

    final dischargedAdmission = admission.copyWith(
      dischargeDate: DateTime.now(),
      dischargeReason: reason,
      updatedAt: DateTime.now(),
    );

    _admissions[admissionId] = dischargedAdmission;
    return dischargedAdmission;
  }

  @override
  Future<List<Admission>> getActiveAdmissions() async {
    await _simulateDelay();
    _maybeThrowError();

    return _admissions.values.where((a) => a.isActive).toList();
  }

  @override
  Future<Admission> assignBed(int admissionId, int bedId) async {
    await _simulateDelay();
    _maybeThrowError();

    final admission = _admissions[admissionId];
    if (admission == null) {
      throw Exception('Admission not found');
    }

    final updatedAdmission = admission.copyWith(
      bedId: bedId,
      updatedAt: DateTime.now(),
    );

    _admissions[admissionId] = updatedAdmission;
    return updatedAdmission;
  }

  @override
  Future<List<Admission>> getWardAdmissions(int wardId) async {
    await _simulateDelay();
    _maybeThrowError();

    // This would need access to WardRepository to filter by ward
    // For now, return all admissions
    return _admissions.values.toList();
  }

  // Reset data to initial state
  void resetData() {
    _admissions.clear();
    _nextAdmissionId = 1;
    _seedData();
  }

  // Helper to get all admissions
  List<Admission> getAllAdmissions() {
    return _admissions.values.toList();
  }
}

class MockWardRepository implements WardRepository {
  final Map<int, Ward> _wards = {};
  final Map<int, Bed> _beds = {};
  final Map<int, StreamController<List<Bed>>> _bedControllers = {};
  int _nextWardId = 1;
  int _nextBedId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockWardRepository() {
    _seedData();
    _initializeBedStreams();
  }

  void _initializeBedStreams() {
    // Initialize stream controllers for each ward
    for (var ward in _wards.values) {
      _bedControllers[ward.id!] = StreamController<List<Bed>>.broadcast();
    }
  }

  void _seedData() {
    final now = DateTime.now();
    
    // Seed wards
    final seedWards = [
      Ward(
        id: _nextWardId++,
        name: 'General Ward',
        code: 'GW',
        capacity: 20,
        description: 'General medical and surgical patients',
        createdAt: now,
        updatedAt: now,
      ),
      Ward(
        id: _nextWardId++,
        name: 'Maternity Ward',
        code: 'MW',
        capacity: 15,
        description: 'Obstetric and gynecological patients',
        createdAt: now,
        updatedAt: now,
      ),
      Ward(
        id: _nextWardId++,
        name: 'Pediatric Ward',
        code: 'PW',
        capacity: 10,
        description: 'Children under 12 years',
        createdAt: now,
        updatedAt: now,
      ),
      Ward(
        id: _nextWardId++,
        name: 'ICU',
        code: 'ICU',
        capacity: 5,
        description: 'Intensive Care Unit',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (var ward in seedWards) {
      _wards[ward.id!] = ward;
    }

    // Seed beds for each ward
    for (var ward in seedWards) {
      for (int i = 1; i <= ward.capacity; i++) {
        final bedStatus = _determineInitialBedStatus(ward.id ?? 0, i);
        final bed = Bed(
          id: _nextBedId++,
          wardId: ward.id ?? 0,
          bedNumber: '${ward.code}-${i.toString().padLeft(2, '0')}',
          status: bedStatus,
          currentAdmissionId: bedStatus == BedStatus.occupied ? 1 : null, // Mock admission ID
          createdAt: now,
          updatedAt: now,
        );
        _beds[bed.id!] = bed;
      }
    }
  }

  BedStatus _determineInitialBedStatus(int wardId, int bedNumber) {
    // Randomly assign some beds as occupied for demo
    if (_random.nextDouble() < 0.2) {
      return BedStatus.occupied;
    } else if (_random.nextDouble() < 0.05) {
      return BedStatus.maintenance;
    }
    return BedStatus.free;
  }

  Future<void> _simulateDelay() async {
    final delay = 300 + _random.nextInt(500);
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
  Future<List<Ward>> getWards() async {
    await _simulateDelay();
    _maybeThrowError();

    return _wards.values.toList();
  }

  @override
  Future<Ward?> getById(int id) async {
    await _simulateDelay();
    _maybeThrowError();

    return _wards[id];
  }

  @override
  Future<List<Bed>> getWardBeds(int wardId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _beds.values.where((b) => b.wardId == wardId).toList();
  }

  @override
  Future<List<Bed>> getAvailableBeds() async {
    await _simulateDelay();
    _maybeThrowError();

    return _beds.values.where((b) => b.status == BedStatus.free).toList();
  }

  @override
  Future<Bed> updateBedStatus(int bedId, BedStatus status) async {
    await _simulateDelay();
    _maybeThrowError();

    final bed = _beds[bedId];
    if (bed == null) {
      throw Exception('Bed not found');
    }

    final updatedBed = bed.copyWith(
      status: status,
      currentAdmissionId: status == BedStatus.occupied ? 1 : null, // Mock admission ID
      updatedAt: DateTime.now(),
    );

    _beds[bedId] = updatedBed;
    
    // Emit update for the ward
    _emitBedUpdate(bed.wardId);
    
    return updatedBed;
  }

  @override
  Stream<List<Bed>> watchWardBeds(int wardId) {
    // Simulate live updates with periodic changes
    Timer.periodic(const Duration(seconds: 15), (timer) {
      _simulateBedUpdate(wardId);
    });
    
    return _bedControllers[wardId]!.stream;
  }

  void _simulateBedUpdate(int wardId) {
    // Occasionally emit the current bed list to simulate live updates
    if (_random.nextDouble() < 0.2) {
      _emitBedUpdate(wardId);
    }
  }

  void _emitBedUpdate(int wardId) {
    final beds = _beds.values.where((b) => b.wardId == wardId).toList();
    _bedControllers[wardId]?.add(beds);
  }

  // Reset data to initial state
  void resetData() {
    _wards.clear();
    _beds.clear();
    _nextWardId = 1;
    _nextBedId = 1;
    _seedData();
  }

  // Helper to get bed by ID
  Bed? getBedById(int id) {
    return _beds[id];
  }
}

class MockVitalsRepository implements VitalsRepository {
  final Map<int, List<VitalsRecord>> _visitVitals = {};
  final Map<int, List<VitalsRecord>> _admissionVitals = {};
  int _nextVitalsId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockVitalsRepository() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    
    // Seed some vitals records for demo
    final seedVitals = [
      VitalsRecord(
        id: _nextVitalsId++,
        visitId: 2,
        admissionId: null,
        temperature: 37.5,
        systolicBP: 120,
        diastolicBP: 80,
        heartRate: 72,
        respiratoryRate: 16,
        oxygenSaturation: 98.0,
        weight: 65.0,
        height: 170.0,
        notes: null,
        recordedAt: now.subtract(const Duration(minutes: 30)),
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
      VitalsRecord(
        id: _nextVitalsId++,
        visitId: 3,
        admissionId: null,
        temperature: 38.2,
        systolicBP: 130,
        diastolicBP: 85,
        heartRate: 88,
        respiratoryRate: 18,
        oxygenSaturation: 96.0,
        weight: 70.0,
        height: 175.0,
        notes: 'Patient reports fever',
        recordedAt: now.subtract(const Duration(minutes: 45)),
        createdAt: now.subtract(const Duration(minutes: 45)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
      ),
    ];

    for (var vitals in seedVitals) {
      if (vitals.visitId != null) {
        if (!_visitVitals.containsKey(vitals.visitId)) {
          _visitVitals[vitals.visitId!] = [];
        }
        _visitVitals[vitals.visitId!]!.add(vitals);
      }
    }
  }

  Future<void> _simulateDelay() async {
    final delay = 300 + _random.nextInt(500);
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
  Future<VitalsRecord> recordVisitVitals(VitalsRecord vitals) async {
    await _simulateDelay();
    _maybeThrowError();

    final newVitals = VitalsRecord(
      id: _nextVitalsId++,
      visitId: vitals.visitId,
      admissionId: null,
      temperature: vitals.temperature,
      systolicBP: vitals.systolicBP,
      diastolicBP: vitals.diastolicBP,
      heartRate: vitals.heartRate,
      respiratoryRate: vitals.respiratoryRate,
      oxygenSaturation: vitals.oxygenSaturation,
      weight: vitals.weight,
      height: vitals.height,
      notes: vitals.notes,
      recordedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (!_visitVitals.containsKey(newVitals.visitId)) {
      _visitVitals[newVitals.visitId!] = [];
    }
    _visitVitals[newVitals.visitId!]!.add(newVitals);
    
    return newVitals;
  }

  @override
  Future<VitalsRecord> recordAdmissionVitals(VitalsRecord vitals) async {
    await _simulateDelay();
    _maybeThrowError();

    final newVitals = VitalsRecord(
      id: _nextVitalsId++,
      visitId: null,
      admissionId: vitals.admissionId,
      temperature: vitals.temperature,
      systolicBP: vitals.systolicBP,
      diastolicBP: vitals.diastolicBP,
      heartRate: vitals.heartRate,
      respiratoryRate: vitals.respiratoryRate,
      oxygenSaturation: vitals.oxygenSaturation,
      weight: vitals.weight,
      height: vitals.height,
      notes: vitals.notes,
      recordedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (!_admissionVitals.containsKey(newVitals.admissionId)) {
      _admissionVitals[newVitals.admissionId!] = [];
    }
    _admissionVitals[newVitals.admissionId!]!.add(newVitals);
    
    return newVitals;
  }

  @override
  Future<List<VitalsRecord>> getVisitVitals(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _visitVitals[visitId] ?? [];
  }

  @override
  Future<List<VitalsRecord>> getAdmissionVitals(int admissionId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _admissionVitals[admissionId] ?? [];
  }

  @override
  Future<VitalsRecord?> getLatestAdmissionVitals(int admissionId) async {
    await _simulateDelay();
    _maybeThrowError();

    final vitals = _admissionVitals[admissionId];
    if (vitals == null || vitals.isEmpty) {
      return null;
    }
    
    // Return the most recent vitals
    vitals.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return vitals.first;
  }

  // Reset data to initial state
  void resetData() {
    _visitVitals.clear();
    _admissionVitals.clear();
    _nextVitalsId = 1;
    _seedData();
  }
}

class MockNursingRepository implements NursingRepository {
  final Map<int, List<NursingNote>> _admissionNotes = {};
  int _nextNoteId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockNursingRepository() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    
    // Seed some nursing notes for demo
    final seedNotes = [
      NursingNote(
        id: _nextNoteId++,
        admissionId: 1,
        notes: 'Patient admitted with fever. Vital signs stable. IV fluids started.',
        nurseId: 1,
        noteTime: now.subtract(const Duration(hours: 2)),
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      NursingNote(
        id: _nextNoteId++,
        admissionId: 1,
        notes: 'Patient reports feeling better. Temperature reduced to 37.8°C.',
        nurseId: 2,
        noteTime: now.subtract(const Duration(hours: 1)),
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
    ];

    for (var note in seedNotes) {
      if (!_admissionNotes.containsKey(note.admissionId)) {
        _admissionNotes[note.admissionId] = [];
      }
      _admissionNotes[note.admissionId]!.add(note);
    }
  }

  Future<void> _simulateDelay() async {
    final delay = 300 + _random.nextInt(500);
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
  Future<NursingNote> addNote(NursingNote note) async {
    await _simulateDelay();
    _maybeThrowError();

    final newNote = NursingNote(
      id: _nextNoteId++,
      admissionId: note.admissionId,
      notes: note.notes,
      nurseId: note.nurseId,
      noteTime: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (!_admissionNotes.containsKey(newNote.admissionId)) {
      _admissionNotes[newNote.admissionId] = [];
    }
    _admissionNotes[newNote.admissionId]!.add(newNote);
    
    return newNote;
  }

  @override
  Future<List<NursingNote>> getAdmissionNotes(int admissionId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _admissionNotes[admissionId] ?? [];
  }

  @override
  Future<List<NursingNote>> getRecentNotes(int admissionId, int limit) async {
    await _simulateDelay();
    _maybeThrowError();

    final notes = _admissionNotes[admissionId] ?? [];
    notes.sort((a, b) => b.noteTime.compareTo(a.noteTime));
    
    return notes.take(limit).toList();
  }

  // Reset data to initial state
  void resetData() {
    _admissionNotes.clear();
    _nextNoteId = 1;
    _seedData();
  }
}
