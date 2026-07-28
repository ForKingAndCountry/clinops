import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/service_locator.dart';
import '../repositories/patient_repository.dart';
import '../models/patient.dart';
import '../models/visit.dart';
import '../widgets/shared_widgets.dart';
import '../theme/clinops_theme.dart';

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
  int? _patientId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get navigation arguments safely in didChangeDependencies
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final patientId = args?['patientId'] as int?;
    
    if (patientId != null && _patientId == null) {
      _patientId = patientId;
      _loadPatientChart();
    }
  }

  Future<void> _loadPatientChart() async {
    if (_patientId == null) {
      setState(() {
        _errorMessage = 'Patient ID not provided. Please navigate from the Find Patient screen.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final chart = await _patientRepository.getChart(_patientId!).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out after 10 seconds');
        },
      );
      
      if (!mounted) return;
      
      setState(() {
        _patient = Patient.fromJson(chart['patient']);
        _visits = (chart['visits'] as List)
            .map((v) => Visit.fromJson(v as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinOpsTheme.background,
      appBar: AppBar(
        title: const Text('Patient Chart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
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
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: ClinOpsTheme.danger,
                      ),
                      const SizedBox(height: ClinOpsTheme.space3),
                      Text(
                        'Error: $_errorMessage',
                        style: GoogleFonts.inter(
                          color: ClinOpsTheme.danger,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: ClinOpsTheme.space3),
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
      padding: const EdgeInsets.all(ClinOpsTheme.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Header
          _buildPatientHeader(),
          const SizedBox(height: ClinOpsTheme.space4),

          // Patient Details
          _buildPatientDetails(),
          const SizedBox(height: ClinOpsTheme.space4),

          // Visit History
          _buildVisitHistory(),
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ClinOpsTheme.space3),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: ClinOpsTheme.primary,
              child: Text(
                _patient!.fullName.isNotEmpty 
                    ? _patient!.fullName[0].toUpperCase() 
                    : '?',
                style: GoogleFonts.spaceGrotesk(
                  color: ClinOpsTheme.surface,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: ClinOpsTheme.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _patient!.fullName,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ClinOpsTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${_patient!.hospitalId}',
                    style: context.monoSmallStyle,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.print_outlined),
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
      child: Padding(
        padding: const EdgeInsets.all(ClinOpsTheme.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ClinOpsTheme.ink,
              ),
            ),
            const SizedBox(height: ClinOpsTheme.space3),
            _buildDetailRow(Icons.cake_outlined, 'Date of Birth', 
                DateFormat('dd MMM yyyy').format(_patient!.dateOfBirth)),
            if (_patient!.phone != null)
              _buildDetailRow(Icons.phone_outlined, 'Phone', _patient!.phone!),
            if (_patient!.community != null)
              _buildDetailRow(Icons.location_on_outlined, 'Community', _patient!.community!),
            if (_patient!.address != null)
              _buildDetailRow(Icons.home_outlined, 'Address', _patient!.address!),
            if (_patient!.emergencyContactName != null)
              _buildDetailRow(Icons.contact_phone_outlined, 'Emergency Contact', 
                  '${_patient!.emergencyContactName}${_patient!.emergencyContactPhone != null ? " (${_patient!.emergencyContactPhone})" : ""}'),
            if (_patient!.allergies != null && _patient!.allergies!.isNotEmpty)
              _buildDetailRow(Icons.warning_amber_outlined, 'Allergies', _patient!.allergies!, 
                  isWarning: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ClinOpsTheme.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isWarning ? ClinOpsTheme.warning : ClinOpsTheme.muted,
          ),
          const SizedBox(width: ClinOpsTheme.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ClinOpsTheme.muted,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isWarning ? ClinOpsTheme.warning : ClinOpsTheme.ink,
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
            Text(
              'Visit History',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ClinOpsTheme.ink,
              ),
            ),
            if (_visits.isNotEmpty)
              Text(
                '${_visits.length} visit(s)', 
                style: GoogleFonts.inter(
                  color: ClinOpsTheme.muted,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: ClinOpsTheme.space3),
        if (_visits.isEmpty)
          EmptyState(
            icon: Icons.history_outlined,
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
            separatorBuilder: (context, index) => const SizedBox(height: ClinOpsTheme.space2),
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
      child: Padding(
        padding: const EdgeInsets.all(ClinOpsTheme.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Visit #${visit.id}',
                  style: context.monoStyle,
                ),
                StatusBadge(
                  label: _getStatusLabel(visit.status),
                  color: statusColor,
                  icon: _getStatusIcon(visit.status),
                ),
              ],
            ),
            const SizedBox(height: ClinOpsTheme.space2),
            _buildVisitDetail(Icons.calendar_today_outlined, 
                'Date', DateFormat('dd MMM yyyy, HH:mm').format(visit.createdAt)),
            _buildVisitDetail(Icons.label_outlined, 'Type', visit.visitType),
            if (visit.arrivalTime != null)
              _buildVisitDetail(Icons.access_time_outlined, 'Arrival', 
                  DateFormat('dd MMM yyyy, HH:mm').format(visit.arrivalTime!)),
            if (visit.status == VisitStatus.discharged && visit.dischargeTime != null)
              _buildVisitDetail(Icons.check_circle_outlined, 'Discharged', 
                  DateFormat('dd MMM yyyy, HH:mm').format(visit.dischargeTime!)),
            const SizedBox(height: ClinOpsTheme.space2),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Visit details coming soon')),
                      );
                    },
                    icon: const Icon(Icons.visibility_outlined),
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
      padding: const EdgeInsets.only(bottom: ClinOpsTheme.space1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: ClinOpsTheme.muted),
          const SizedBox(width: ClinOpsTheme.space1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: ClinOpsTheme.muted,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(fontSize: 13),
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
