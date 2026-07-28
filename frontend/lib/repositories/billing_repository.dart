import '../models/billing.dart';

abstract class BillingRepository {
  // Add billing item to visit
  Future<BillingItem> addItem(BillingItem item);
  
  // Get billing items for a visit
  Future<List<BillingItem>> getVisitItems(int visitId);
  
  // Calculate total for a visit
  Future<double> calculateTotal(int visitId);
  
  // Get payment summary for a visit
  Future<Map<String, dynamic>> getSummary(int visitId);
  
  // Add payment
  Future<Payment> addPayment(Payment payment);
  
  // Get payments for a visit
  Future<List<Payment>> getVisitPayments(int visitId);
  
  // Get outstanding balance for a visit
  Future<double> getOutstandingBalance(int visitId);
  
  // Check if visit can be discharged (gatekeeper)
  Future<bool> canDischarge(int visitId);
  
  // Get daily revenue summary
  Future<Map<String, dynamic>> getDailySummary(DateTime date);
}
