import 'package:flutter/material.dart';

import '../theme/platinum_colors.dart';

class PokedexToolsSheet extends StatefulWidget {
  const PokedexToolsSheet({
    super.key,
    required this.searchQuery,
    required this.selectedType,
    required this.types,
    required this.onSearchChanged,
    required this.onTypeChanged,
  });

  final String searchQuery;
  final String? selectedType;
  final List<String> types;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onTypeChanged;

  @override
  State<PokedexToolsSheet> createState() => _PokedexToolsSheetState();
}

class _PokedexToolsSheetState extends State<PokedexToolsSheet> {
  late final TextEditingController _searchController = TextEditingController(
    text: widget.searchQuery,
  );
  late String? _selectedType = widget.selectedType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: PlatinumColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'POKÉDEX SEARCH',
              style: TextStyle(
                color: PlatinumColors.platinum,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Name or nickname',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
              onChanged: (value) {
                widget.onSearchChanged(value);
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey(_selectedType),
              initialValue: _selectedType ?? '',
              decoration: const InputDecoration(
                labelText: 'Filter by type',
                prefixIcon: Icon(Icons.tune),
              ),
              items: [
                const DropdownMenuItem(value: '', child: Text('All types')),
                for (final type in widget.types)
                  DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  ),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value?.isEmpty == true ? null : value);
                widget.onTypeChanged(_selectedType);
              },
            ),
            if (_searchController.text.isNotEmpty || _selectedType != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _selectedType = null);
                    widget.onSearchChanged('');
                    widget.onTypeChanged(null);
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Clear filters'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
