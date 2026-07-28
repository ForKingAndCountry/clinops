import 'package:flutter/material.dart';

// Status Badge Widget
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Empty State Widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// Patient Header Card Widget
class PatientHeaderCard extends StatelessWidget {
  final String hospitalId;
  final String name;
  final String? dateOfBirth;
  final String? gender;
  final String? phone;
  final String? community;
  final VoidCallback? onTap;

  const PatientHeaderCard({
    super.key,
    required this.hospitalId,
    required this.name,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.community,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: $hospitalId',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (dateOfBirth != null || gender != null)
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (dateOfBirth != null)
                      _buildInfoChip(Icons.cake, 'DOB: $dateOfBirth'),
                    if (gender != null)
                      _buildInfoChip(Icons.person, gender!),
                    if (phone != null)
                      _buildInfoChip(Icons.phone, phone!),
                    if (community != null)
                      _buildInfoChip(Icons.location_on, community!),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// Searchable Select Widget
class SearchableSelect<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final String Function(T) displayString;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final bool allowClear;

  const SearchableSelect({
    super.key,
    required this.label,
    required this.items,
    required this.displayString,
    this.value,
    required this.onChanged,
    this.hintText,
    this.allowClear = true,
  });

  @override
  State<SearchableSelect<T>> createState() => _SearchableSelectState<T>();
}

class _SearchableSelectState<T> extends State<SearchableSelect<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final display = widget.displayString(item).toLowerCase();
          return display.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showSearchDialog(context),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Select ${widget.label}',
              suffixIcon: widget.allowClear && widget.value != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => widget.onChanged(null),
                    )
                  : const Icon(Icons.arrow_drop_down),
              border: const OutlineInputBorder(),
            ),
            child: widget.value != null
                ? Text(widget.displayString(widget.value!))
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  void _showSearchDialog(BuildContext context) {
    _searchController.clear();
    _filteredItems = widget.items;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Select ${widget.label}'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setDialogState(() {
                      _filterItems(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: _filteredItems.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off,
                          title: 'No results found',
                        )
                      : ListView.builder(
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return ListTile(
                              title: Text(widget.displayString(item)),
                              onTap: () {
                                widget.onChanged(item);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
