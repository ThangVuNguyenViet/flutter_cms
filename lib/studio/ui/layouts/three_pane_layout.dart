import 'package:flutter/material.dart';

/// Three-pane layout with resizable panels
/// Common pattern for studio interfaces: sidebar | main | details
class ThreePaneLayout extends StatefulWidget {
  const ThreePaneLayout({
    super.key,
    required this.leftPanel,
    required this.centerPanel,
    required this.rightPanel,
    this.leftPanelWidth = 250,
    this.rightPanelWidth = 300,
    this.minPanelWidth = 200,
    this.maxPanelWidth = 500,
    this.onLeftPanelToggle,
    this.onRightPanelToggle,
    this.showLeftPanel = true,
    this.showRightPanel = true,
  });

  final Widget leftPanel;
  final Widget centerPanel;
  final Widget rightPanel;
  final double leftPanelWidth;
  final double rightPanelWidth;
  final double minPanelWidth;
  final double maxPanelWidth;
  final VoidCallback? onLeftPanelToggle;
  final VoidCallback? onRightPanelToggle;
  final bool showLeftPanel;
  final bool showRightPanel;

  @override
  State<ThreePaneLayout> createState() => _ThreePaneLayoutState();
}

class _ThreePaneLayoutState extends State<ThreePaneLayout> {
  late double _leftPanelWidth;
  late double _rightPanelWidth;

  @override
  void initState() {
    super.initState();
    _leftPanelWidth = widget.leftPanelWidth;
    _rightPanelWidth = widget.rightPanelWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return Row(
          children: [
            // Left Panel
            if (widget.showLeftPanel) ...[
              SizedBox(
                width: _leftPanelWidth,
                child: widget.leftPanel,
              ),
              _ResizeHandle(
                onDrag: (delta) {
                  setState(() {
                    _leftPanelWidth = (_leftPanelWidth + delta).clamp(
                      widget.minPanelWidth,
                      widget.maxPanelWidth,
                    );
                  });
                },
              ),
            ],

            // Center Panel
            Expanded(
              child: widget.centerPanel,
            ),

            // Right Panel
            if (widget.showRightPanel) ...[
              _ResizeHandle(
                onDrag: (delta) {
                  setState(() {
                    _rightPanelWidth = (_rightPanelWidth - delta).clamp(
                      widget.minPanelWidth,
                      widget.maxPanelWidth,
                    );
                  });
                },
              ),
              SizedBox(
                width: _rightPanelWidth,
                child: widget.rightPanel,
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Resize handle for panels
class _ResizeHandle extends StatelessWidget {
  const _ResizeHandle({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onPanUpdate: (details) => onDrag(details.delta.dx),
        child: Container(
          width: 4,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}