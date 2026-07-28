import 'dart:async';
import 'dart:math';
import '../patient_repository.dart';
import '../../models/visit.dart';
import 'mock_patient_repository.dart';

class MockVisitRepository implements VisitRepository {
  final Map<int, Visit> _visits = {};
  final Map<int, List<VisitTransition>> _transitions = {};
  final Map<VisitStatus, StreamController<List<Visit>>> _queueControllers = {};
  int _nextId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;
  late MockPatientRepository _patientRepository;

  MockVisitRepository(this._patientRepository) {
    _seedData();
    _initializeQueueStreams();
  }

  void _initializeQueueStreams() {
    for (var status in VisitStatus.values) {
      _queueControllers[status] = StreamController<List<Visit>>.broadcast();
    }
  }

  void _seedData() {
    final now = DateTime.now();
    
    // Create some visits at different stages for demo purposes
    final seedVisits = [
      Visit(
        id: _nextId++,
        patientId: 1, // Kofi Johnson
        status: VisitStatus.reception,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(minutes: 15)),
        createdAt: now.subtract(const Duration(minutes: 15)),
        updatedAt: now,
      ),
      Visit(
        id: _nextId++,
        patientId: 2, // Fatima Kromah
        status: VisitStatus.vitals,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(minutes: 45)),
        createdAt: now.subtract(const Duration(minutes: 45)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
      Visit(
        id: _nextId++,
        patientId: 3, // James Weah
        status: VisitStatus.doctor,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(hours: 1)),
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
      ),
      Visit(
        id: _nextId++,
        patientId: 4, // Aminata Kamara
        status: VisitStatus.lab,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(hours: 1, minutes: 30)),
        createdAt: now.subtract(const Duration(hours: 1, minutes: 30)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      Visit(
        id: _nextId++,
        patientId: 5, // Boakai Sesay
        status: VisitStatus.pharmacy,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(hours: 2)),
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      Visit(
        id: _nextId++,
        patientId: 6, // Mariama Jonson (messy record)
        status: VisitStatus.billing,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(hours: 2, minutes: 30)),
        createdAt: now.subtract(const Duration(hours: 2, minutes: 30)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      // IPD admission
      Visit(
        id: _nextId++,
        patientId: 7, // Sarah Tolbert
        status: VisitStatus.doctor,
        visitType: 'IPD',
        arrivalTime: now.subtract(const Duration(hours: 3)),
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
      // Another patient at reception
      Visit(
        id: _nextId++,
        patientId: 8, // Mohammed Bah
        status: VisitStatus.reception,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(minutes: 5)),
        createdAt: now.subtract(const Duration(minutes: 5)),
        updatedAt: now.subtract(const Duration(minutes: 5)),
      ),
      // Patient at vitals
      Visit(
        id: _nextId++,
        patientId: 9, // Elizabeth Doe
        status: VisitStatus.vitals,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(minutes: 30)),
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now.subtract(const Duration(minutes: 20)),
      ),
      // Historical completed visit
      Visit(
        id: _nextId++,
        patientId: 10, // Elisabeth Dough
        status: VisitStatus.discharged,
        visitType: 'OPD',
        arrivalTime: now.subtract(const Duration(days: 1)),
        dischargeTime: now.subtract(const Duration(days: 1)).add(const Duration(hours: 3)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)).add(const Duration(hours: 3)),
      ),
    ];

    for (var visit in seedVisits) {
      _visits[visit.id!] = visit;
      _patientRepository.addVisitToPatient(visit.patientId, visit);
      
      // Add initial transition for non-reception visits
      if (visit.status != VisitStatus.reception) {
        _addTransition(visit.id!, VisitStatus.reception, visit.status, visit.arrivalTime!);
      }
    }
  }

  void _addTransition(int visitId, VisitStatus from, VisitStatus to, DateTime time) {
    final transition = VisitTransition(
      id: _transitions.length + 1,
      visitId: visitId,
      fromStatus: from,
      toStatus: to,
      transitionedAt: time,
      actorUserId: 1, // Mock user ID
      createdAt: time,
    );
    
    if (!_transitions.containsKey(visitId)) {
      _transitions[visitId] = [];
    }
    _transitions[visitId]!.add(transition);
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
  Future<List<Visit>> getPatientVisits(int patientId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _visits.values.where((v) => v.patientId == patientId).toList();
  }

  @override
  Future<Visit> createVisit(Visit visit) async {
    await _simulateDelay();
    _maybeThrowError();

    final newVisit = visit.copyWith(
      id: _nextId++,
      arrivalTime: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _visits[newVisit.id!] = newVisit;
    _patientRepository.addVisitToPatient(newVisit.patientId, newVisit);
    
    // Add initial transition
    _addTransition(newVisit.id!, VisitStatus.reception, newVisit.status, newVisit.arrivalTime!);
    
    _emitQueueUpdate(newVisit.status);
    
    return newVisit;
  }

  @override
  Future<Visit> transition(int visitId, VisitStatus toState) async {
    await _simulateDelay();
    _maybeThrowError();

    final visit = _visits[visitId];
    if (visit == null) {
      throw Exception('Visit not found');
    }

    final fromState = visit.status;
    final updatedVisit = visit.copyWith(
      status: toState,
      updatedAt: DateTime.now(),
    );

    _visits[visitId] = updatedVisit;
    
    // Add transition record
    _addTransition(visitId, fromState, toState, DateTime.now());
    
    // Emit queue updates for both old and new stations
    _emitQueueUpdate(fromState);
    _emitQueueUpdate(toState);
    
    // If discharging, set discharge time
    if (toState == VisitStatus.discharged) {
      _visits[visitId] = updatedVisit.copyWith(
        dischargeTime: DateTime.now(),
      );
    }

    return _visits[visitId]!;
  }

  @override
  Future<Visit?> getActiveVisit(int patientId) async {
    await _simulateDelay();
    _maybeThrowError();

    try {
      return _visits.values.firstWhere(
        (v) => v.patientId == patientId && v.status != VisitStatus.discharged,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Visit>> getQueue(VisitStatus station) async {
    await _simulateDelay();
    _maybeThrowError();

    return _visits.values
        .where((v) => v.status == station)
        .toList()
      ..sort((a, b) => a.arrivalTime!.compareTo(b.arrivalTime!));
  }

  @override
  Stream<List<Visit>> watchQueue(VisitStatus station) {
    // Simulate live updates with periodic changes
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _simulateQueueUpdate(station);
    });
    
    return _queueControllers[station]!.stream;
  }

  void _simulateQueueUpdate(VisitStatus station) {
    // Occasionally emit the current queue to simulate live updates
    if (_random.nextDouble() < 0.3) {
      _emitQueueUpdate(station);
    }
  }

  void _emitQueueUpdate(VisitStatus station) {
    final queue = _visits.values
        .where((v) => v.status == station)
        .toList()
      ..sort((a, b) => a.arrivalTime!.compareTo(b.arrivalTime!));
    
    _queueControllers[station]?.add(queue);
  }

  @override
  Future<Visit?> getById(int id) async {
    await _simulateDelay();
    _maybeThrowError();

    return _visits[id];
  }

  @override
  Future<List<VisitTransition>> getTransitions(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _transitions[visitId] ?? [];
  }

  // Reset data to initial state
  void resetData() {
    _visits.clear();
    _transitions.clear();
    _nextId = 1;
    _seedData();
  }

  // Helper to get visit by ID synchronously (for other mock repos)
  Visit? getVisitSync(int id) {
    return _visits[id];
  }

  // Helper to get all visits
  List<Visit> getAllVisits() {
    return _visits.values.toList();
  }
}
