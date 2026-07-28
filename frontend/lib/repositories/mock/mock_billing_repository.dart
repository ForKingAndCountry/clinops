import 'dart:async';
import 'dart:math';
import '../billing_repository.dart';
import '../../models/billing.dart';

class MockBillingRepository implements BillingRepository {
  final Map<int, BillingItem> _billingItems = {};
  final Map<int, Payment> _payments = {};
  int _nextBillingItemId = 1;
  int _nextPaymentId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockBillingRepository() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    
    // Seed some billing items for demo visits
    final seedItems = [
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 1,
        itemType: 'consultation',
        itemId: null,
        description: 'OPD Consultation Fee',
        amount: 500.0,
        createdAt: now.subtract(const Duration(minutes: 15)),
        updatedAt: now.subtract(const Duration(minutes: 15)),
      ),
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 2,
        itemType: 'consultation',
        itemId: null,
        description: 'OPD Consultation Fee',
        amount: 500.0,
        createdAt: now.subtract(const Duration(minutes: 45)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
      ),
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 3,
        itemType: 'consultation',
        itemId: null,
        description: 'OPD Consultation Fee',
        amount: 500.0,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 3,
        itemType: 'lab',
        itemId: null,
        description: 'Malaria Test',
        amount: 300.0,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 4,
        itemType: 'consultation',
        itemId: null,
        description: 'OPD Consultation Fee',
        amount: 500.0,
        createdAt: now.subtract(const Duration(hours: 1, minutes: 30)),
        updatedAt: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 5,
        itemType: 'consultation',
        itemId: null,
        description: 'OPD Consultation Fee',
        amount: 500.0,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 5,
        itemType: 'drug',
        itemId: null,
        description: 'Amoxicillin 250mg - 20 capsules',
        amount: 400.0,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 6,
        itemType: 'consultation',
        itemId: null,
        description: 'OPD Consultation Fee',
        amount: 500.0,
        createdAt: now.subtract(const Duration(hours: 2, minutes: 30)),
        updatedAt: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 6,
        itemType: 'lab',
        itemId: null,
        description: 'Complete Blood Count',
        amount: 800.0,
        createdAt: now.subtract(const Duration(hours: 2, minutes: 30)),
        updatedAt: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
      // Historical visit with payment
      BillingItem(
        id: _nextBillingItemId++,
        visitId: 10,
        itemType: 'consultation',
        itemId: null,
        description: 'OPD Consultation Fee',
        amount: 500.0,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    for (var item in seedItems) {
      _billingItems[item.id!] = item;
    }

    // Seed some payments
    final seedPayments = [
      Payment(
        id: _nextPaymentId++,
        visitId: 10,
        amount: 500.0,
        paymentMethod: 'cash',
        referenceNumber: 'PAY-001',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    for (var payment in seedPayments) {
      _payments[payment.id!] = payment;
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
  Future<BillingItem> addItem(BillingItem item) async {
    await _simulateDelay();
    _maybeThrowError();

    final newItem = BillingItem(
      id: _nextBillingItemId++,
      visitId: item.visitId,
      itemType: item.itemType,
      itemId: item.itemId,
      description: item.description,
      amount: item.amount,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _billingItems[newItem.id!] = newItem;
    return newItem;
  }

  @override
  Future<List<BillingItem>> getVisitItems(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _billingItems.values.where((b) => b.visitId == visitId).toList();
  }

  @override
  Future<double> calculateTotal(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    final items = await getVisitItems(visitId);
    return items.fold<double>(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Future<Map<String, dynamic>> getSummary(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    final items = await getVisitItems(visitId);
    final payments = await getVisitPayments(visitId);
    final total = items.fold<double>(0.0, (sum, item) => sum + item.amount);
    final paid = payments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
    final balance = total - paid;

    return {
      'total': total,
      'paid': paid,
      'balance': balance,
      'items': items,
      'payments': payments,
    };
  }

  @override
  Future<Payment> addPayment(Payment payment) async {
    await _simulateDelay();
    _maybeThrowError();

    final newPayment = Payment(
      id: _nextPaymentId++,
      visitId: payment.visitId,
      amount: payment.amount,
      paymentMethod: payment.paymentMethod,
      referenceNumber: payment.referenceNumber ?? 'PAY-${_nextPaymentId}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _payments[newPayment.id!] = newPayment;
    return newPayment;
  }

  @override
  Future<List<Payment>> getVisitPayments(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _payments.values.where((p) => p.visitId == visitId).toList();
  }

  @override
  Future<double> getOutstandingBalance(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    final summary = await getSummary(visitId);
    return summary['balance'] as double;
  }

  @override
  Future<bool> canDischarge(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    final balance = await getOutstandingBalance(visitId);
    return balance <= 0.0;
  }

  @override
  Future<Map<String, dynamic>> getDailySummary(DateTime date) async {
    await _simulateDelay();
    _maybeThrowError();

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final dayItems = _billingItems.values.where((b) {
      return b.createdAt.isAfter(startOfDay) && b.createdAt.isBefore(endOfDay);
    }).toList();

    final dayPayments = _payments.values.where((p) {
      return p.createdAt.isAfter(startOfDay) && p.createdAt.isBefore(endOfDay);
    }).toList();

    final totalRevenue = dayPayments.fold(0.0, (sum, payment) => sum + payment.amount);
    final totalBilled = dayItems.fold(0.0, (sum, item) => sum + item.amount);
    final pendingRevenue = totalBilled - totalRevenue;

    return {
      'date': date,
      'total_billed': totalBilled,
      'total_collected': totalRevenue,
      'pending_revenue': pendingRevenue,
      'transaction_count': dayPayments.length,
      'items': dayItems,
      'payments': dayPayments,
    };
  }

  // Reset data to initial state
  void resetData() {
    _billingItems.clear();
    _payments.clear();
    _nextBillingItemId = 1;
    _nextPaymentId = 1;
    _seedData();
  }

  // Helper to get all billing items
  List<BillingItem> getAllItems() {
    return _billingItems.values.toList();
  }

  // Helper to get all payments
  List<Payment> getAllPayments() {
    return _payments.values.toList();
  }
}
