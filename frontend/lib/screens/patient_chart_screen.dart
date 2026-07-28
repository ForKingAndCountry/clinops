import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/service_locator.dart';
import '../repositories/patient_repository.dart';
import '../models/patient.dart';
import '../models/visit.dart';
import '../widgets/shared_widgets.dart';

class PatientChartScreen extends StatefulWidget {
  const PatientChartScreen({super.key});

  @override
  State<PatientChartScreen> createState() => _PatientChartScreenState();
}

class _PatientChartScreenState extends State<PatientChartScreen> {
  final PatientRepository _patientRepository = getIt<PatientRepository>();
  
  Patient? _patient;
  List<Visit> _visits = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPatientChart();
  }

  Future<void> _loadPatientChart() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final patientId = args?['patientId'] as int?;
    
    if (patientId == null) {
      setState(() {
        _errorMessage = 'Patient ID not provided';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final chart = await _patientRepository.getChart(patientId);
      
      setState(() {
        _patient = Patient.fromJson(chart['patient']);
        _visits = (chart['visits'] as List)
            .map((v) => Visit.fromJson(v as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Chart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPatientChart,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
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
                        onPressed: _loadPatientChart,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildChart(),
    );
  }

  Widget _buildChart() {
    if (_patient == null) {
      return const EmptyState(
        icon: Icons.person_off,
        title: 'Patient Not Found',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Header
          _buildPatientHeader(),
          const SizedBox(height: 24),

          // Patient Details
          _buildPatientDetails(),
          const SizedBox(height: 24),

          // Visit History
          _buildVisitHistory(),
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                _patient!.fullName.isNotEmpty 
                    ? _patient!.fullName[0].toUpperCase() 
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _patient!.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${_patient!.hospitalId}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Print feature coming soon')),
                );
              },
              tooltip: 'Print Patient ID',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetails() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.cake, 'Date of Birth', 
                DateFormat('dd MMM yyyy').format(_patient!.dateOfBirth)),
            if (_patient!.phone != null)
              _buildDetailRow(Icons.phone, 'Phone', _patient!.phone!),
            if (_patient!.community != null)
              _buildDetailRow(Icons.location_on, 'Community', _patient!.community!),
            if (_patient!.address != null)
              _buildDetailRow(Icons.home, 'Address', _patient!.address!),
            if (_patient!.emergencyContactName != null)
              _buildDetailRow(Icons.contact_phone, 'Emergency Contact', 
                  '${_patient!.emergencyContactName}${_patient!.emergencyContactPhone != null ? " (${_patient!.emergencyContactPhone})" : ""}'),
            if (_patient!.allergies != null && _patient!.allergies!.isNotEmpty)
              _buildDetailRow(Icons.warning, 'Allergies', _patient!.allergies!, 
                  isWarning: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: isWarning ? Colors.orange : Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isWarning ? Colors.orange : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Visit History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_visits.isNotEmpty)
              Text('${_visits.length} visit(s)', 
                  style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 16),
        if (_visits.isEmpty)
          EmptyState(
            icon: Icons.history,
            title: 'No Visits Yet',
            subtitle: 'This patient has no recorded visits.',
            action: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New visit feature coming soon')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Start New Visit'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _visits.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final visit = _visits[index];
              return _buildVisitCard(visit);
            },
          ),
      ],
    );
  }

  Widget _buildVisitCard(Visit visit) {
    final statusColor = _getStatusColor(visit.status);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Visit #${visit.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                StatusBadge(
                  label: _getStatusLabel(visit.status),
                  color: statusColor,
                  icon: _getStatusIcon(visit.status),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildVisitDetail(Icons.calendar_today, 
                'Date', DateFormat('dd MMM yyyy, HH:mm').format(visit.createdAt)),
            _buildVisitDetail(Icons.label, 'Type', visit.visitType),
            if (visit.arrivalTime != null)
              _buildVisitDetail(Icons.access_time, 'Arrival', 
                  DateFormat('dd MMM yyyy, HH:mm').format(visit.arrivalTime!)),
            if (visit.status == VisitStatus.discharged && visit.dischargeTime != null)
              _buildVisitDetail(Icons.check_circle, 'Discharged', 
                  DateFormat('dd MMM yyyy, HH:mm').format(visit.dischargeTime!)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Visit details coming soon')),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(VisitStatus status) {
    switch (status) {
      case VisitStatus.reception:
        return 'At Reception';
      case VisitStatus.vitals:
        return 'In Vitals';
      case VisitStatus.doctor:
        return 'With Doctor';
      case VisitStatus.lab:
        return 'In Lab';
      case VisitStatus.pharmacy:
        return 'In Pharmacy';
      case VisitStatus.billing:
        return 'In Billing';
      case VisitStatus.discharged:
        return 'Discharged';
    }
  }

  Color _getStatusColor(VisitStatus status) {
    switch (status) {
      case VisitStatus.reception:
        return Colors.orange;
      case VisitStatus.vitals:
        return Colors.blue;
      case VisitStatus.doctor:
        return Colors.purple;
      case VisitStatus.lab:
        return Colors.red;
      case VisitStatus.pharmacy:
        return Colors.teal;
      case VisitStatus.billing:
        return Colors.amber;
      case VisitStatus.discharged:
        return Colors.green;
    }
  }

  IconData _getStatusIcon(VisitStatus status) {
    switch (status) {
      case VisitStatus.reception:
        return Icons.access_time;
      case VisitStatus.vitals:
        return Icons.favorite;
      case VisitStatus.doctor:
        return Icons.medical_services;
      case VisitStatus.lab:
        return Icons.science;
      case VisitStatus.pharmacy:
        return Icons.medication;
      case VisitStatus.billing:
        return Icons.receipt;
      case VisitStatus.discharged:
        return Icons.check_circle;
    }
  }
}
