import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
// COLORS  (from AppColors palette)
// ─────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const Color primary      = Color(0xFF4F46E5);
  static const Color primaryHover = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFFEEF2FF);

  static const Color background   = Color(0xFFF8FAFC);
  static const Color surface      = Color(0xFFFFFFFF);

  static const Color textPrimary   = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted     = Color(0xFF94A3B8);
  static const Color textInverse   = Color(0xFFFFFFFF);

  static const Color border       = Color(0xFFE2E8F0);

  static const Color success      = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);

  static const Color error        = Color(0xFFEF4444);
  static const Color errorLight   = Color(0xFFFFE4E6);

  static const Color warning      = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  // "Used — Good" badge uses a calm blue to distinguish from primary
  static const Color infoBadge      = Color(0xFF3B82F6);
  static const Color infoBadgeLight = Color(0xFFEFF6FF);
}

// ─────────────────────────────────────────────
// TEXT STYLES (Google Fonts Inter)
// ─────────────────────────────────────────────
class AppTextStyles {
  static TextStyle tableHeader = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6,
  );
  static TextStyle tableCell = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary,
  );
  static TextStyle tableCellMuted = GoogleFonts.inter(
    fontSize: 14, color: AppColors.textSecondary,
  );
  static TextStyle body = GoogleFonts.inter(
    fontSize: 13, color: AppColors.textSecondary,
  );
  static TextStyle label = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
  );
}

// ─────────────────────────────────────────────
// THEME HELPER
// ─────────────────────────────────────────────
ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.surface,
        error:   AppColors.error,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.surface;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textInverse),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.border, width: 1.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

// ─────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────
enum CarCondition { newCar, usedGood, usedFair }

extension CarConditionLabel on CarCondition {
  String get label {
    switch (this) {
      case CarCondition.newCar:    return 'New';
      case CarCondition.usedGood:  return 'Good';
      case CarCondition.usedFair:  return 'Fair';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case CarCondition.newCar:   return AppColors.successLight;
      case CarCondition.usedGood: return AppColors.infoBadgeLight;
      case CarCondition.usedFair: return AppColors.warningLight;
    }
  }

  Color get textColor {
    switch (this) {
      case CarCondition.newCar:   return AppColors.success;
      case CarCondition.usedGood: return AppColors.infoBadge;
      case CarCondition.usedFair: return AppColors.warning;
    }
  }
}

class CarRecord {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String governorate;
  final String mileage;      // e.g. "87,000 km"
  final CarCondition condition;
  final String? notes;
  bool isSelected;

  CarRecord({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.governorate,
    required this.mileage,
    required this.condition,
    this.notes,
    this.isSelected = false,
  });

  CarRecord copyWith({bool? isSelected}) => CarRecord(
        id:          id,
        brand:       brand,
        model:       model,
        year:        year,
        governorate: governorate,
        mileage:     mileage,
        condition:   condition,
        notes:       notes,
        isSelected:  isSelected ?? this.isSelected,
      );

  Map<String, String> toMap() => {
        'brand':       brand,
        'model':       model,
        'year':        year.toString(),
        'governorate': governorate,
        'mileage':     mileage,
        'condition':   condition.label,
        'notes':       notes ?? '',
      };

  static CarRecord fromMap(Map<String, String> data, {String? id, CarCondition? condition}) => CarRecord(
        id:          id ?? data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        brand:       data['brand'] ?? '',
        model:       data['model'] ?? '',
        year:        int.tryParse(data['year'] ?? '') ?? 0,
        governorate: data['governorate'] ?? '',
        mileage:     data['mileage'] ?? '',
        condition:   condition ?? CarCondition.values.firstWhere((c) => c.label == data['condition'], orElse: () => CarCondition.usedGood),
        notes:       (data['notes'] ?? '').isEmpty ? null : data['notes'],
      );
}

// ─────────────────────────────────────────────
// FIELD DEFINITION (schema-driven)
// ─────────────────────────────────────────────
enum FieldType { text, number, dropdown }

class FieldDef {
  final String key;
  final String label;
  final FieldType type;
  final List<String>? options;
  final bool filterable;
  final bool required;
  final int flex;

  const FieldDef({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.filterable = false,
    this.required = true,
    this.flex = 1,
  });
}

List<FieldDef> defaultSchema() => [
      FieldDef(key: 'brand',       label: 'Car Brand',       type: FieldType.text,     filterable: true,  flex: 2),
      FieldDef(key: 'model',       label: 'Car Model',       type: FieldType.text,                       flex: 2),
      FieldDef(key: 'year',        label: 'Year',            type: FieldType.number,                     flex: 1),
      FieldDef(key: 'governorate', label: 'Governorate',     type: FieldType.text,     filterable: true,  flex: 2),
      FieldDef(key: 'mileage',     label: 'Mileage',         type: FieldType.text,                       flex: 2),
      FieldDef(key: 'condition',   label: 'Condition',       type: FieldType.dropdown, options: const ['New', 'Good', 'Fair'], flex: 2),
      FieldDef(key: 'notes',       label: 'Notes',           type: FieldType.text,     required: false,   flex: 2),
    ];

// ─────────────────────────────────────────────
// SAMPLE DATA  (replace / remove when backend is wired)
// ─────────────────────────────────────────────
List<CarRecord> sampleRecords() => [
      CarRecord(
        id: '1', brand: 'Toyota',        model: 'Corolla',
        year: 2019, governorate: 'Cairo',
        mileage: '87,000 km', condition: CarCondition.usedGood,
        notes: 'Engine serviced',
      ),
      CarRecord(
        id: '2', brand: 'Hyundai',        model: 'Elantra',
        year: 2021, governorate: 'Giza',
        mileage: '34,200 km', condition: CarCondition.usedGood,
      ),
      CarRecord(
        id: '3', brand: 'Kia',            model: 'Sportage',
        year: 2020, governorate: 'Alexandria',
        mileage: '61,500 km', condition: CarCondition.usedFair,
        notes: 'Minor scratch',
      ),
      CarRecord(
        id: '4', brand: 'BMW',            model: '320i',
        year: 2022, governorate: 'Dakahlia',
        mileage: '18,000 km', condition: CarCondition.newCar,
      ),
      CarRecord(
        id: '5', brand: 'Toyota',         model: 'Camry',
        year: 2018, governorate: 'Sharqia',
        mileage: '112,000 km', condition: CarCondition.usedFair,
        notes: 'Needs tire change',
      ),
      CarRecord(
        id: '6', brand: 'Nissan',         model: 'Sentra',
        year: 2017, governorate: 'Qalyubia',
        mileage: '143,000 km', condition: CarCondition.usedFair,
      ),
      CarRecord(
        id: '7', brand: 'Mercedes-Benz',  model: 'C200',
        year: 2023, governorate: 'Cairo',
        mileage: '5,400 km', condition: CarCondition.newCar,
      ),
      CarRecord(
        id: '8', brand: 'Peugeot',        model: '208',
        year: 2020, governorate: 'Giza',
        mileage: '49,000 km', condition: CarCondition.usedGood,
      ),
    ];

// ─────────────────────────────────────────────
// REPOSITORY LAYER  (swap LocalCarRepository for ApiCarRepository later)
// ─────────────────────────────────────────────
abstract class CarRepository {
  Future<List<CarRecord>> fetchAll();
  Future<void> create(CarRecord record);
  Future<void> update(CarRecord record);
  Future<void> delete(String id);
  Future<void> deleteMany(Set<String> ids);
}

class LocalCarRepository implements CarRepository {
  final List<CarRecord> _records = sampleRecords();

  @override
  Future<List<CarRecord>> fetchAll() async =>
      _records.map((r) => r.copyWith()).toList();

  @override
  Future<void> create(CarRecord record) async => _records.add(record);

  @override
  Future<void> update(CarRecord record) async {
    final i = _records.indexWhere((r) => r.id == record.id);
    if (i != -1) _records[i] = record;
  }

  @override
  Future<void> delete(String id) async =>
      _records.removeWhere((r) => r.id == id);

  @override
  Future<void> deleteMany(Set<String> ids) async =>
      _records.removeWhere((r) => ids.contains(r.id));
}

// ─────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────
class CarSalesController extends ChangeNotifier {
  final CarRepository _repo;
  final List<FieldDef> _schema;

  List<CarRecord> _all = [];
  List<CarRecord> _filtered = [];
  String _searchQuery = '';
  final Map<String, String?> _filters = {};
  bool _loading = false;
  String? _error;

  CarSalesController({required CarRepository repository, List<FieldDef>? schema})
      : _repo = repository,
        _schema = schema ?? defaultSchema();

  // ── Getters ──
  List<FieldDef> get schema => _schema;
  List<CarRecord> get allRecords => List.unmodifiable(_all);
  List<CarRecord> get filteredRecords => List.unmodifiable(_filtered);
  List<CarRecord> get selectedRecords =>
      _filtered.where((r) => r.isSelected).toList();
  int get selectedCount => selectedRecords.length;
  bool get hasSelection => selectedCount > 0;
  bool get allFilteredSelected =>
      _filtered.isNotEmpty && _filtered.every((r) => r.isSelected);
  String? get errorMessage => _error;
  bool get isLoading => _loading;
  String get searchQuery => _searchQuery;

  String? filterValue(String key) => _filters[key];

  List<String> filterOptions(String key) =>
      _all.map((r) => r.toMap()[key] ?? '').toSet().toList()..sort();

  // ── Lifecycle ──
  Future<void> refresh() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _all = await _repo.fetchAll();
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load data: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Filtering ──
  void _applyFilters() {
    final q = _searchQuery.toLowerCase();
    final filterableKeys = _schema.where((f) => f.filterable).map((f) => f.key).toList();
    _filtered = _all.where((r) {
      final data = r.toMap();
      final matchSearch = q.isEmpty || data.values.any((v) => v.toLowerCase().contains(q));
      final matchFilters = filterableKeys.every((k) {
        final filterVal = _filters[k];
        return filterVal == null || data[k] == filterVal;
      });
      return matchSearch && matchFilters;
    }).toList();
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    _applyFilters();
  }

  void setFilter(String key, String? value) {
    _filters[key] = value;
    _applyFilters();
  }

  // ── Selection ──
  void toggleSelectAll(bool? value) {
    for (final r in _filtered) {
      r.isSelected = value ?? false;
    }
    notifyListeners();
  }

  void toggleRecord(CarRecord record, bool? value) {
    record.isSelected = value ?? false;
    notifyListeners();
  }

  void cancelSelection() {
    for (final r in _all) {
      r.isSelected = false;
    }
    notifyListeners();
  }

  // ── CRUD ──
  Future<void> addRecord(CarRecord record) async {
    await _run(() async {
      await _repo.create(record);
      _all = await _repo.fetchAll();
    });
  }

  Future<void> editRecord(CarRecord record) async {
    await _run(() async {
      await _repo.update(record);
      final i = _all.indexWhere((r) => r.id == record.id);
      if (i != -1) _all[i] = record;
    });
  }

  Future<void> deleteRecord(String id) async {
    await _run(() async {
      await _repo.delete(id);
      _all.removeWhere((r) => r.id == id);
    });
  }

  Future<void> deleteSelected() async {
    await _run(() async {
      final ids = selectedRecords.map((r) => r.id).toSet();
      await _repo.deleteMany(ids);
      _all.removeWhere((r) => ids.contains(r.id));
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

// ─────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────
void main() => runApp(const CarSalesApp());

class CarSalesApp extends StatelessWidget {
  const CarSalesApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Car Sales',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: CarSalesScreen(
          controller: CarSalesController(repository: LocalCarRepository()),
        ),
      );
}

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────
class CarSalesScreen extends StatefulWidget {
  final CarSalesController controller;
  final String fileName;
  final VoidCallback? onBack;

  const CarSalesScreen({
    super.key,
    required this.controller,
    this.fileName = '',
    this.onBack,
  });

  List<FieldDef> get schema => controller.schema;

  @override
  State<CarSalesScreen> createState() => _CarSalesScreenState();
}

class _CarSalesScreenState extends State<CarSalesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String? _lastError;

  CarSalesController get _ctrl => widget.controller;

  // ── Lifecycle ──
  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _ctrl.refresh());
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onChanged);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {});
    final err = _ctrl.errorMessage;
    if (err != null && err != _lastError) {
      _lastError = err;
      _showSnackBar(err, isError: true);
    }
    if (err == null) _lastError = null;
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(msg, style: GoogleFonts.inter(fontSize: 13))),
      ]),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      margin: const EdgeInsets.all(16),
      duration: Duration(seconds: isError ? 5 : 3),
      action: isError
          ? SnackBarAction(label: 'Dismiss', textColor: Colors.white, onPressed: () {})
          : null,
    ));
  }

  void _handleKey(KeyEvent e) {
    if (e is KeyDownEvent) {
      final isCtrlF = e.logicalKey == LogicalKeyboardKey.keyF &&
          (HardwareKeyboard.instance.isControlPressed ||
              HardwareKeyboard.instance.isMetaPressed);
      if (isCtrlF || e.logicalKey == LogicalKeyboardKey.slash) {
        _searchFocus.requestFocus();
      }
    }
  }

  // ── CRUD ──
  Future<void> _onAddRecord() async {
    final result = await showDialog<CarRecord>(
      context: context,
      builder: (_) => AddCarDialog(schema: widget.schema),
    );
    if (result != null) {
      await _ctrl.addRecord(result);
      if (mounted) _showSnackBar('Record added');
    }
  }

  Future<void> _onEditRecord(CarRecord record) async {
    final result = await showDialog<CarRecord>(
      context: context,
      builder: (_) => AddCarDialog(schema: widget.schema, existingRecord: record),
    );
    if (result != null) {
      await _ctrl.editRecord(result);
      if (mounted) _showSnackBar('Record updated');
    }
  }

  Future<void> _onDeleteSingle(CarRecord record) async {
    final confirmed = await _showDeleteConfirmation(1);
    if (!confirmed) return;
    await _ctrl.deleteRecord(record.id);
    if (mounted) _showSnackBar('Record deleted');
  }

  Future<void> _onDeleteSelected() async {
    final count = _ctrl.selectedCount;
    final confirmed = await _showDeleteConfirmation(count);
    if (!confirmed) return;
    await _ctrl.deleteSelected();
    if (mounted) _showSnackBar('$count record${count == 1 ? '' : 's'} deleted');
  }

  Future<void> _onExport() async {
    final csv = _buildCsv();
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Export CSV',
      fileName: 'car_sales_export.csv',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (path != null && mounted) {
      try {
        await File(path).writeAsString(csv);
        _showSnackBar('Exported successfully');
      } catch (e) {
        _showSnackBar('Export failed: $e', isError: true);
      }
    }
  }

  String _buildCsv() {
    final flds = widget.schema;
    final buf = StringBuffer('${flds.map((f) => f.label).join(',')}\n');
    for (final r in _ctrl.filteredRecords) {
      final data = r.toMap();
      buf.writeln(flds.map((f) => data[f.key] ?? '').join(','));
    }
    return buf.toString();
  }

  Future<bool> _showDeleteConfirmation(int count) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Delete $count record${count > 1 ? 's' : ''}?',
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            content: Text(
              'This action cannot be undone.',
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel',
                    style: GoogleFonts.inter(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.textInverse,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Delete',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ── Build ──
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKey,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              if (_ctrl.hasSelection) _buildSelectionBar(),
              Expanded(child: _buildTableArea()),
              _buildFooter(),
              if (_ctrl.isLoading)
                const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top Bar ──
  Widget _buildTopBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: LayoutBuilder(builder: (ctx, constraints) {
        final compact = constraints.maxWidth < 860;
        if (compact) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (widget.onBack != null) ...[
                _IconBtn(
                  icon: Icons.arrow_back_rounded,
                  tooltip: 'Back',
                  onTap: widget.onBack!,
                ),
                const SizedBox(width: 8),
              ],
              Text('Car Sales June 2024',
                  style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3)),
              if (widget.fileName.isNotEmpty) ...[
                const SizedBox(width: 8),
                _FileNameBadge(fileName: widget.fileName),
              ],
              const SizedBox(width: 10),
              _RecordCountBadge(count: _ctrl.allRecords.length),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              SizedBox(
                width: 180,
                child: TextField(
                  controller: _searchCtrl,
                  focusNode: _searchFocus,
                  onChanged: _ctrl.setSearch,
                  decoration: InputDecoration(
                    hintText: 'Search…  (Ctrl+F)',
                    hintStyle: GoogleFonts.inter(
                        color: AppColors.textMuted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.textMuted, size: 16),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                  ),
                ),
              ),
              ..._buildFilterDropdowns(),
              _OutlineBtn(
                label: 'Add record',
                icon: Icons.add_rounded,
                onTap: _onAddRecord,
              ),
              _PrimaryBtn(
                label: 'Export',
                icon: Icons.download_rounded,
                onTap: _onExport,
              ),
            ]),
          ]);
        }

        return Row(children: [
          if (widget.onBack != null) ...[
            _IconBtn(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Back',
              onTap: widget.onBack!,
            ),
            const SizedBox(width: 8),
          ],
          Text('Car Sales June 2024',
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3)),
          if (widget.fileName.isNotEmpty) ...[
            const SizedBox(width: 8),
            _FileNameBadge(fileName: widget.fileName),
          ],
          const SizedBox(width: 10),
          _RecordCountBadge(count: _ctrl.allRecords.length),
          const SizedBox(width: 20),

          SizedBox(
            width: 200,
            child: TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              onChanged: _ctrl.setSearch,
              decoration: InputDecoration(
                hintText: 'Search…  (Ctrl+F)',
                hintStyle: GoogleFonts.inter(
                    color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textMuted, size: 16),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 10),

          ..._buildFilterDropdowns(),
          const Spacer(),

          _OutlineBtn(
            label: 'Add record',
            icon: Icons.add_rounded,
            onTap: _onAddRecord,
          ),
          const SizedBox(width: 10),

          _PrimaryBtn(
            label: 'Export',
            icon: Icons.download_rounded,
            onTap: _onExport,
          ),
        ]);
      }),
    );
  }

  List<Widget> _buildFilterDropdowns() {
    final filterable = widget.schema.where((f) => f.filterable).toList();
    final widgets = <Widget>[];
    for (var i = 0; i < filterable.length; i++) {
      final f = filterable[i];
      widgets.add(_DropdownFilter<String?>(
        value: _ctrl.filterValue(f.key),
        hint: 'All ${f.key}s',
        items: _ctrl.filterOptions(f.key),
        onChanged: (v) => _ctrl.setFilter(f.key, v),
      ));
      if (i < filterable.length - 1) {
        widgets.add(const SizedBox(width: 8));
      }
    }
    return widgets;
  }

  // ── Selection Bar ──
  Widget _buildSelectionBar() {
    return Container(
      color: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Text(
            '${_ctrl.selectedCount} record${_ctrl.selectedCount > 1 ? 's' : ''} selected',
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _ctrl.cancelSelection,
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
            child: Text('Cancel', style: GoogleFonts.inter(fontSize: 13)),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: _onDeleteSelected,
            icon: const Icon(Icons.delete_outline_rounded, size: 14),
            label: Text('Delete selected',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textInverse,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // ── Table Area ──
  Widget _buildTableArea() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 920,
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildTableHeader(),
              const Divider(height: 1, color: AppColors.border),
              Expanded(
                child: _ctrl.filteredRecords.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        itemCount: _ctrl.filteredRecords.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, color: AppColors.border),
                        itemBuilder: (_, i) {
                          final rec = _ctrl.filteredRecords[i];
                          return _CarTableRow(
                            record: rec,
                            schema: widget.schema,
                            onToggle: (v) => _ctrl.toggleRecord(rec, v),
                            onEdit: () => _onEditRecord(rec),
                            onDelete: () => _onDeleteSingle(rec),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: _ctrl.allFilteredSelected,
              tristate: true,
              onChanged: _ctrl.toggleSelectAll,
            ),
          ),
          ...widget.schema.map(
            (f) => Expanded(
              flex: f.flex,
              child: Text(
                f.label.toUpperCase(),
                style: AppTextStyles.tableHeader,
              ),
            ),
          ),
          SizedBox(width: 60, child: Text('ACTIONS', style: AppTextStyles.tableHeader)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.directions_car_outlined,
                  size: 28, color: AppColors.primary),
            ),
            const SizedBox(height: 14),
            Text('No records match your filters.',
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Add a new record to get started.',
                style: AppTextStyles.body),
          ],
        ),
      );

  // ── Footer ──
  Widget _buildFooter() {
    final count = _ctrl.filteredRecords.length;
    final total = _ctrl.allRecords.length;
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Text(
            'Showing 1–$count of $total records',
            style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
          ),
          const Spacer(),
          // Pagination placeholder — wire to backend offset/cursor
          _PageNavBtn(
            icon: Icons.chevron_left_rounded,
            onPressed: null,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('1',
                style: GoogleFonts.inter(
                    color: AppColors.textInverse,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
          _PageNavBtn(
            icon: Icons.chevron_right_rounded,
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TABLE ROW (with hover animation)
// ─────────────────────────────────────────────
class _CarTableRow extends StatefulWidget {
  final CarRecord record;
  final List<FieldDef> schema;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CarTableRow({
    required this.record,
    required this.schema,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_CarTableRow> createState() => _CarTableRowState();
}

class _CarTableRowState extends State<_CarTableRow> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final sel = widget.record.isSelected;
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: InkWell(
        onTap: () => widget.onToggle(!widget.record.isSelected),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          color: sel
              ? AppColors.primaryLight
              : _hov
                  ? AppColors.primaryLight.withAlpha(50)
                  : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Checkbox(
                  value: sel,
                  onChanged: widget.onToggle,
                ),
              ),
              ...widget.schema.map((f) {
                return Expanded(
                  flex: f.flex,
                  child: _buildCell(widget.record, f),
                );
              }),
              SizedBox(
                width: 60,
                child: _buildActions(widget.onEdit, widget.onDelete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// COLUMN HELPERS
// ─────────────────────────────────────────────
Widget _buildCell(CarRecord record, FieldDef f) {
  final val = record.toMap()[f.key] ?? '';
  if (val.isEmpty && f.key == 'notes') {
    return Text('—',
        style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textMuted,
            fontStyle: FontStyle.italic));
  }
  if (f.key == 'condition') {
    return _ConditionBadge(label: val);
  }
  return Text(val,
      style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary));
}

Widget _buildActions(VoidCallback onEdit, VoidCallback onDelete) {
  return Row(
    children: [
      _IconBtn(
        icon: Icons.edit_outlined,
        tooltip: 'Edit',
        color: AppColors.textSecondary,
        onTap: onEdit,
      ),
      const SizedBox(width: 4),
      _IconBtn(
        icon: Icons.delete_outline_rounded,
        tooltip: 'Delete',
        color: AppColors.error,
        onTap: onDelete,
      ),
    ],
  );
}

// ─────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────
class _ConditionBadge extends StatelessWidget {
  const _ConditionBadge({required this.label});
  final String label;

  Color _bg() {
    switch (label) {
      case 'New':  return AppColors.successLight;
      case 'Good': return AppColors.infoBadgeLight;
      case 'Fair': return AppColors.warningLight;
      default:     return AppColors.border;
    }
  }

  Color _fg() {
    switch (label) {
      case 'New':  return AppColors.success;
      case 'Good': return AppColors.infoBadge;
      case 'Fair': return AppColors.warning;
      default:     return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _bg(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _fg(),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FileNameBadge extends StatelessWidget {
  const _FileNameBadge({required this.fileName});
  final String fileName;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.description_outlined,
              size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(fileName,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
        ]),
      );
}

class _RecordCountBadge extends StatelessWidget {
  const _RecordCountBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$count records',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class _DropdownFilter<T> extends StatelessWidget {
  const _DropdownFilter({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final String hint;
  final List<String> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value as String?,
          hint: Text(hint,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 14)),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary, size: 18),
          onChanged: (v) => onChanged(v as T?),
          items: [
            DropdownMenuItem(value: null, child: Text(hint)),
            ...items.map(
              (s) => DropdownMenuItem(value: s, child: Text(s)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ANIMATED BUTTON WIDGETS
// ─────────────────────────────────────────────

class _PrimaryBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryBtn({required this.label, required this.icon, required this.onTap});

  @override
  State<_PrimaryBtn> createState() => _PrimaryBtnState();
}

class _PrimaryBtnState extends State<_PrimaryBtn> {
  bool _hov = false;
  bool _press = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _press = true),
        onTapUp: (_) => setState(() => _press = false),
        onTapCancel: () => setState(() => _press = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          transform: _press ? Matrix4.diagonal3Values(0.96, 0.96, 1.0) : Matrix4.identity(),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hov
                  ? [AppColors.primaryHover, AppColors.primary]
                  : [AppColors.primary, AppColors.primary.withValues(alpha: 0.9)],
              begin: Alignment.centerLeft, end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _hov ? 0.35 : 0),
                blurRadius: _hov ? 10 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(widget.icon, size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(widget.label,
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlineBtn({required this.label, required this.icon, required this.onTap});

  @override
  State<_OutlineBtn> createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<_OutlineBtn> {
  bool _hov = false;
  bool _press = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _press = true),
        onTapUp: (_) => setState(() => _press = false),
        onTapCancel: () => setState(() => _press = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          transform: _press ? Matrix4.diagonal3Values(0.96, 0.96, 1.0) : Matrix4.identity(),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hov ? AppColors.primaryLight.withValues(alpha: 0.4) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _hov ? AppColors.primary : AppColors.border, width: 1.5),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(widget.icon, size: 14,
                      color: _hov ? AppColors.primary : AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(widget.label,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _hov ? AppColors.primary : AppColors.textPrimary,
                      )),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({
    required this.icon,
    required this.tooltip,
    this.color = AppColors.textSecondary,
    required this.onTap,
  });

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hov = false;
  bool _press = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hov = true),
        onExit: (_) => setState(() => _hov = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _press = true),
          onTapUp: (_) => setState(() => _press = false),
          onTapCancel: () => setState(() => _press = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            transform: _press ? Matrix4.diagonal3Values(0.88, 0.88, 1.0) : Matrix4.identity(),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hov ? widget.color.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(widget.icon, size: 16,
                    color: _hov ? widget.color : widget.color.withValues(alpha: 0.7)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageNavBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const _PageNavBtn({required this.icon, required this.onPressed});

  @override
  State<_PageNavBtn> createState() => _PageNavBtnState();
}

class _PageNavBtnState extends State<_PageNavBtn> {
  bool _hov = false;
  bool _press = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _press = true) : null,
        onTapUp: enabled ? (_) => setState(() => _press = false) : null,
        onTapCancel: () => setState(() => _press = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          transform: _press ? Matrix4.diagonal3Values(0.9, 0.9, 1.0) : Matrix4.identity(),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hov && enabled ? AppColors.primaryLight : Colors.transparent,
            border: Border.all(
                color: !enabled
                    ? AppColors.border.withValues(alpha: 0.5)
                    : _hov
                        ? AppColors.primary
                        : AppColors.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(widget.icon,
              size: 18,
              color: !enabled
                  ? AppColors.textMuted
                  : _hov
                      ? AppColors.primary
                      : AppColors.textSecondary),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ADD / EDIT DIALOG
// ─────────────────────────────────────────────
class AddCarDialog extends StatefulWidget {
  final List<FieldDef> schema;
  final CarRecord? existingRecord;

  const AddCarDialog({super.key, required this.schema, this.existingRecord});

  @override
  State<AddCarDialog> createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _ctrls = {};
  late final Map<String, String> _dropdownValues = {};
  bool _submitting = false;

  bool get _isEditing => widget.existingRecord != null;

  @override
  void initState() {
    super.initState();
    final data = widget.existingRecord?.toMap() ?? {};
    for (final f in widget.schema) {
      if (f.type == FieldType.dropdown) {
        _dropdownValues[f.key] = data[f.key] ?? f.options?.first ?? '';
      } else {
        _ctrls[f.key] = TextEditingController(text: data[f.key] ?? '');
      }
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final data = <String, String>{};
      for (final f in widget.schema) {
        if (f.type == FieldType.dropdown) {
          data[f.key] = _dropdownValues[f.key] ?? '';
        } else {
          data[f.key] = (_ctrls[f.key]?.text ?? '').trim();
        }
      }
      final record = CarRecord.fromMap(
        data,
        id: widget.existingRecord?.id,
      );
      Navigator.pop(context, record);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.schema;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 520,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Edit Record' : 'Add Record',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 420),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _buildFormFields(fields)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _submitting ? null : () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textInverse,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text(_isEditing ? 'Save changes' : 'Add record'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(List<FieldDef> fields) {
    final widgets = <Widget>[];
    for (var i = 0; i < fields.length; i += 2) {
      final a = fields[i];
      final b = i + 1 < fields.length ? fields[i + 1] : null;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(child: _buildField(a)),
              if (b != null) ...[
                const SizedBox(width: 12),
                Expanded(child: _buildField(b)),
              ] else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildField(FieldDef f) {
    if (f.type == FieldType.dropdown) {
      return DropdownButtonFormField<String>(
        initialValue: _dropdownValues[f.key] ?? f.options?.first ?? '',
        decoration: InputDecoration(labelText: f.label),
        items: (f.options ?? []).map((opt) {
          return DropdownMenuItem(value: opt, child: Text(opt));
        }).toList(),
        onChanged: (v) => setState(() => _dropdownValues[f.key] = v ?? ''),
        validator: f.required
            ? (v) => (v == null || v.isEmpty) ? 'Required' : null
            : null,
      );
    }

    final ctrl = _ctrls[f.key]!;
    return TextFormField(
      controller: ctrl,
      keyboardType: f.type == FieldType.number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: f.label),
      validator: f.required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
          : null,
    );
  }
}