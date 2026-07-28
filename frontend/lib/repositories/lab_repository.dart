import '../models/lab.dart';

abstract class LabRepository {
  // Order lab test
  Future<LabOrder> orderTest(LabOrder order);
  
  // Get lab orders for a visit
  Future<List<LabOrder>> getVisitOrders(int visitId);
  
  // Get pending orders
  Future<List<LabOrder>> getPendingOrders();
  
  // Get order by ID
  Future<LabOrder?> getById(int id);
  
  // Submit lab result
  Future<LabResult> submitResult(LabResult result);
  
  // Get result for order
  Future<LabResult?> getOrderResult(int labOrderId);
  
  // Get patient lab history
  Future<List<Map<String, dynamic>>> getPatientHistory(int patientId);
  
  // Get lab test catalog
  Future<List<LabTestCatalog>> getCatalog();
  
  // Search lab test catalog
  Future<List<LabTestCatalog>> searchTests(String query);
}
