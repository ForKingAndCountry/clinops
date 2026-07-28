import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/service_locator.dart';
import '../repositories/patient_repository.dart';
import '../repositories/visit_repository.dart';
import '../models/visit.dart';
import '../models/patient.dart';
import '../theme/clinops_theme.dart';

class StationQueueScreen extends StatefulWidget {
  final VisitStatus station;
  final String stationName;

  const StationQueueScreen({
    super.key,
    required this.station,
    required this.stationName,
  });

  @override
  State<StationQueueScreen> createState() => _StationQueueScreenState();
}

class _StationQueueScreenState extends State<StationQueueScreen> {
  final VisitRepository _visitRepository = getIt<VisitRepository>();
  final PatientRepository _patientRepository = getIt<PatientRepository>();
  
  List<Visit> _queue = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final queue = await _visitRepository.getQueue(widget.station);
      
      if (!mounted) return;
      
      setState(() {
        _queue = queue;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _advancePatient(Visit visit) async {
    try {
      // Determine next station
      VisitStatus nextStatus;
      switch (visit.status) {
        case VisitStatus.reception:
          nextStatus = VisitStatus.vitals;
          break;
        case VisitStatus.vitals:
          nextStatus = VisitStatus.doctor;
          break;
        case VisitStatus.doctor:
          nextStatus = VisitStatus.lab;
          break;
        case VisitStatus.lab:
          nextStatus = VisitStatus.pharmacy;
          break;
        case VisitStatus.pharmacy:
          nextStatus = VisitStatus.billing;
          break;
        case VisitStatus.billing:
          nextStatus = VisitStatus.discharged;
          break;
        case VisitStatus.discharged:
          return; // Already discharged
      }

      await _visitRepository.transition(visit.id!, nextStatus);
      
      if (!mounted) return;
      
      // Reload queue
      _loadQueue();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient advanced to ${_getStatusLabel(nextStatus)}'),
          backgroundColor: ClinOpsTheme.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to advance patient: ${e.toString()}'),
          backgroundColor: ClinOpsTheme.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinOpsTheme.background,
      appBar: AppBar(
        title: Text(widget.stationName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _loadQueue,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Thread motif showing station progression
          _buildStationProgression(),
          
          // Queue list
          Expanded(
            child: _isLoading
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
                              onPressed: _loadQueue,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _queue.isEmpty
                        ? _buildEmptyState()
                        : _buildQueueList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStationProgression() {
    final stations = [
      VisitStatus.reception,
      VisitStatus.vitals,
      VisitStatus.doctor,
      VisitStatus.lab,
      VisitStatus.pharmacy,
      VisitStatus.billing,
      VisitStatus.discharged,
    ];

    return Container(
      color: ClinOpsTheme.surface,
      padding: const EdgeInsets.symmetric(
        vertical: ClinOpsTheme.space3,
        horizontal: ClinOpsTheme.space4,
      ),
      child: Column(
        children: [
          // Thread motif with station indicators
          SizedBox(
            height: 60,
            child: Stack(
              children: [
                // Thread line
                CustomPaint(
                  size: const Size(double.infinity, 60),
                  painter: _ThreadLinePainter(
                    stations: stations,
                    currentStation: widget.station,
                  ),
                ),
                // Station indicators
                ...List.generate(stations.length, (index) {
                  final station = stations[index];
                  final isCurrent = station == widget.station;
                  final isPast = stations.indexOf(widget.station) > index;
                  
                  return Positioned(
                    left: (index / (stations.length - 1)) * (MediaQuery.of(context).size.width - 64) + 32,
                    top: 20,
                    child: _StationIndicator(
                      station: station,
                      isCurrent: isCurrent,
                      isPast: isPast,
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: ClinOpsTheme.space2),
          // Station labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stations.map((station) {
              final isCurrent = station == widget.station;
              return Expanded(
                child: Text(
                  _getStatusLabel(station),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                color: isCurrent ? ClinOpsTheme.primary : ClinOpsTheme.muted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty_outlined,
            size: 64,
            color: ClinOpsTheme.muted,
          ),
          const SizedBox(height: ClinOpsTheme.space3),
          Text(
            'No patients in queue',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ClinOpsTheme.ink,
            ),
          ),
          const SizedBox(height: ClinOpsTheme.space2),
          Text(
            'The ${widget.stationName} queue is currently empty',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: ClinOpsTheme.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueList() {
    return ListView.builder(
      padding: const EdgeInsets.all(ClinOpsTheme.space3),
      itemCount: _queue.length,
      itemBuilder: (context, index) {
        final visit = _queue[index];
        return _buildQueueItem(visit, index);
      },
    );
  }

  Widget _buildQueueItem(Visit visit, int index) {
    return FutureBuilder<Patient?>(
      future: _patientRepository.getById(visit.patientId),
      builder: (context, snapshot) {
        final patient = snapshot.data;
        
        return Card(
          margin: const EdgeInsets.only(bottom: ClinOpsTheme.space2),
          child: Padding(
            padding: const EdgeInsets.all(ClinOpsTheme.space3),
            child: Row(
              children: [
                // Queue number
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ClinOpsTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ClinOpsTheme.radius),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ClinOpsTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: ClinOpsTheme.space3),
                
                // Patient info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (patient != null)
                        Text(
                          patient.fullName,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ClinOpsTheme.ink,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Visit #${visit.id}',
                        style: context.monoSmallStyle,
                      ),
                      if (visit.arrivalTime != null)
                        Text(
                          'Arrived: ${_formatTime(visit.arrivalTime!)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: ClinOpsTheme.muted,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Advance button
                ElevatedButton.icon(
                  onPressed: () => _advancePatient(visit),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Advance'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ClinOpsTheme.space2,
                      vertical: ClinOpsTheme.space2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getStatusLabel(VisitStatus status) {
    switch (status) {
      case VisitStatus.reception:
        return 'Reception';
      case VisitStatus.vitals:
        return 'Vitals';
      case VisitStatus.doctor:
        return 'Doctor';
      case VisitStatus.lab:
        return 'Lab';
      case VisitStatus.pharmacy:
        return 'Pharmacy';
      case VisitStatus.billing:
        return 'Billing';
      case VisitStatus.discharged:
        return 'Discharged';
    }
  }
}

class _StationIndicator extends StatelessWidget {
  final VisitStatus station;
  final bool isCurrent;
  final bool isPast;

  const _StationIndicator({
    required this.station,
    required this.isCurrent,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    double size;
    
    if (isCurrent) {
      color = ClinOpsTheme.accent;
      size = 24;
    } else if (isPast) {
      color = ClinOpsTheme.success;
      size = 20;
    } else {
      color = ClinOpsTheme.border;
      size = 16;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: ClinOpsTheme.surface,
          width: 3,
        ),
      ),
    );
  }
}

class _ThreadLinePainter extends CustomPainter {
  final List<VisitStatus> stations;
  final VisitStatus currentStation;

  _ThreadLinePainter({
    required this.stations,
    required this.currentStation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ClinOpsTheme.accent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final currentIndex = stations.indexOf(currentStation);
    final width = size.width - 64; // Account for padding
    final startX = 32;
    
    // Draw thread line up to current station
    if (currentIndex > 0) {
      final endX = startX + (currentIndex / (stations.length - 1)) * width;
      
      final path = Path();
      path.moveTo(startX, 30);
      
      // Create flowing curve
      for (int i = 1; i <= currentIndex; i++) {
        final x = startX + (i / (stations.length - 1)) * width;
        final curve = i % 2 == 0 ? 5.0 : -5.0;
        path.quadraticBezierTo(
          startX + ((i - 0.5) / (stations.length - 1)) * width,
          30 + curve,
          x,
          30,
        );
      }
      
      canvas.drawPath(path, paint);
    }

    // Draw muted line for future stations
    if (currentIndex < stations.length - 1) {
      final mutedPaint = Paint()
        ..color = ClinOpsTheme.border
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final startXFuture = startX + (currentIndex / (stations.length - 1)) * width;
      final endX = size.width - 32;
      
      final path = Path();
      path.moveTo(startXFuture, 30);
      
      for (int i = currentIndex + 1; i < stations.length; i++) {
        final x = startX + (i / (stations.length - 1)) * width;
        final curve = i % 2 == 0 ? 5.0 : -5.0;
        path.quadraticBezierTo(
          startX + ((i - 0.5) / (stations.length - 1)) * width,
          30 + curve,
          x,
          30,
        );
      }
      
      canvas.drawPath(path, mutedPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
