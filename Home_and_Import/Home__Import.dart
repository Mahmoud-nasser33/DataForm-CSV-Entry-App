import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';


//  APP COLORS 

class AppColors {
  static const Color primary      = Color(0xFF4F46E5);
  static const Color primaryHover = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFFEEF2FF);

  static const Color background   = Color(0xFFF8FAFC);
  static const Color surface      = Color(0xFFFFFFFF);

  static const Color textPrimary   = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted     = Color(0xFF94A3B8);
  static const Color textInverse   = Color(0xFFFFFFFF);

  static const Color border  = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF10B981);
  static const Color error   = Color(0xFFEF4444);
}


//  ENTRY POINT — remove if you already have main()

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSV App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
    
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}


//  PAGE 1 — HOME

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Headline ──────────────────────────────
                      Text(
                        'Structured data entry, simplified',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Build forms from your CSV structure, collect clean records,\nand export with confidence.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // ── Two option cards ──────────────────────
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 580;

                          final importCard = _OptionCard(
                            icon: Icons.upload_rounded,
                            title: 'Import existing CSV',
                            description:
                                'Load a file you already have and continue editing it',
                            buttonLabel: 'Browse file',
                            buttonFilled: false,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ImportCsvPage()),
                            ),
                          );

                          final createCard = _OptionCard(
                            icon: Icons.grid_view_rounded,
                            title: 'Create new file',
                            description:
                                'Start from scratch and define your own structure',
                            buttonLabel: 'Start building',
                            buttonFilled: true,
                            onPressed: () {
                              // TODO: replace with hemaaaa's page route
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Create new file — coming soon!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );

                          if (isWide) {
                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(child: importCard),
                                  const SizedBox(width: 24),
                                  Expanded(child: createCard),
                                ],
                              ),
                            );
                          }
                          return Column(
                            children: [
                              importCard,
                              const SizedBox(height: 20),
                              createCard,
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 64),

                      // ── Footer note ───────────────────────────
                      Text(
                        'All data stays on your device. No internet required.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Help FAB ──────────────────────
            const Positioned(right: 24, bottom: 24, child: _HelpButton()),
          ],
        ),
      ),
    );
  }
}


//  Reusable option card (Import / Create)

class _OptionCard extends StatefulWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonFilled,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final bool buttonFilled;
  final VoidCallback onPressed;

  @override
  State<_OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<_OptionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.primary.withOpacity(0.4) : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? AppColors.primary.withOpacity(0.10)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _hovered ? 24 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon chip
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 28),
            // Button
            widget.buttonFilled
                ? ElevatedButton(
                    onPressed: widget.onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    child: Text(widget.buttonLabel),
                  )
                : OutlinedButton(
                    onPressed: widget.onPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    child: Text(widget.buttonLabel),
                  ),
          ],
        ),
      ),
    );
  }
}


//  Shared help button

class _HelpButton extends StatelessWidget {
  const _HelpButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Help'),
          content: const Text(
              'Need help?\nContact your team or check the documentation.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.textPrimary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.question_mark_rounded,
            color: Colors.white, size: 18),
      ),
    );
  }
}


//  PAGE 2 — IMPORT CSV

class ImportCsvPage extends StatefulWidget {
  const ImportCsvPage({super.key});

  @override
  State<ImportCsvPage> createState() => _ImportCsvPageState();
}

class _ImportCsvPageState extends State<ImportCsvPage> {
  bool   _isDragging     = false;
  String? _pickedFileName;

  
  Future<void> _browseFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: false, // set true if you need bytes immediately
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        setState(() => _pickedFileName = file.name);
        _showSuccess('File selected: ${file.name}');
      }
      // user cancelled → do nothing
    } catch (e) {
      _showError('Could not open file picker. Please try again.');
    }
  }

  void _useDemoFile() {
    setState(() => _pickedFileName = 'car_data_may.csv');
    _showSuccess('Demo file loaded: car_data_may.csv');
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar ──────────────────────────────
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                        bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20),
                        color: AppColors.textPrimary,
                        onPressed: () => Navigator.pop(context),
                        splashRadius: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Import CSV file',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body ─────────────────────────────────
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 40),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Column(
                          children: [
                            // ── Drop zone ─────────────────
                            GestureDetector(
                              onTap: _browseFile,
                              child: DragTarget<Object>(
                                onWillAcceptWithDetails: (_) {
                                  setState(() => _isDragging = true);
                                  return true;
                                },
                                onLeave: (_) =>
                                    setState(() => _isDragging = false),
                                onAcceptWithDetails: (_) {
                                  setState(() => _isDragging = false);
                                  // TODO: extract PlatformFile from desktop drop event
                                },
                                builder: (context, _, __) {
                                  return AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 160),
                                    width: double.infinity,
                                    constraints: const BoxConstraints(
                                        minHeight: 300),
                                    decoration: BoxDecoration(
                                      color: _isDragging
                                          ? AppColors.primaryLight
                                          : AppColors.surface,
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                    // Real dashed border via CustomPaint
                                    child: CustomPaint(
                                      painter: _DashedBorderPainter(
                                        color: _isDragging
                                            ? AppColors.primary
                                            : AppColors.border,
                                        radius: 16,
                                      ),
                                      child: _DropZoneContent(
                                        fileName: _pickedFileName,
                                        onBrowse: _browseFile,
                                        isDragging: _isDragging,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              "We'll read your column headers and help you map them.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 16),

                            GestureDetector(
                              onTap: _useDemoFile,
                              child: Text(
                                'Use demo file (car_data_may.csv)',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Help FAB ──────────────────────
            const Positioned(right: 24, bottom: 24, child: _HelpButton()),
          ],
        ),
      ),
    );
  }
}


//  Drop zone inner content

class _DropZoneContent extends StatelessWidget {
  const _DropZoneContent({
    required this.onBrowse,
    required this.isDragging,
    this.fileName,
  });

  final VoidCallback onBrowse;
  final bool isDragging;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cloud upload icon (uses Flutter's built-in icon — no CustomPaint needed)
          Icon(
            Icons.cloud_upload_outlined,
            size: 56,
            color: isDragging ? AppColors.primary : AppColors.primary,
          ),
          const SizedBox(height: 20),

          // Show selected file name, or default prompt
          fileName != null
              ? Column(children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 20),
                  const SizedBox(height: 6),
                  Text(
                    fileName!,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onBrowse,
                    child: Text(
                      'Choose a different file',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ])
              : Column(children: [
                  Text(
                    isDragging
                        ? 'Release to upload'
                        : 'Drop your CSV file here',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text('or ',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: onBrowse,
                        child: Text(
                          'Browse files',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                      Text(' · Supports .csv only',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ]),
        ],
      ),
    );
  }
}


// Real dashed border painter

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    this.radius = 12,
    this.dashWidth = 6,
    this.dashSpace = 5,
    this.strokeWidth = 1.5,
  });

  final Color  color;
  final double radius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = _buildRoundedRectPath(size);
    final dashPath = _createDashedPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildRoundedRectPath(Size size) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
            size.width - strokeWidth, size.height - strokeWidth),
        Radius.circular(radius),
      ));
  }

  Path _createDashedPath(Path source) {
    final dest   = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool   draw     = true;
      while (distance < metric.length) {
        final len = draw ? dashWidth : dashSpace;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.dashWidth != dashWidth ||
      old.dashSpace != dashSpace;
}