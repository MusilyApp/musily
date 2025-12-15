import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/presenter/widgets/background_painters/wrapped_style_painter.dart';

class TechPainter implements WrappedStylePainter {
  @override
  void paint(Canvas canvas, Size size, Random rng, double t,
      WrappedPalette palette, int seed) {
    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size.width, size.height),
        [
          const Color(0xFF001030),
          const Color(0xFF000510),
        ],
      );
    canvas.drawRect(Offset.zero & size, bgPaint);

    double gridSize = 30.0;
    int cols = (size.width / gridSize).ceil();
    int rows = (size.height / gridSize).ceil();

    final gridPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.03)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Set<String> occupied = {};

    void mark(int c, int r) => occupied.add('$c,$r');
    bool isOccupied(int c, int r) => occupied.contains('$c,$r');
    bool isValid(int c, int r) => c >= 0 && c < cols && r >= 0 && r < rows;

    final circuitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final nodePaint = Paint()..style = PaintingStyle.fill;

    final circuitRng = Random(seed);

    int attempts = 0;
    int maxAttempts = 100;
    int circuitsCount = 0;
    int targetCircuits = 20;

    final List<Point<int>> dirs = [
      const Point(1, 0),
      const Point(1, 1),
      const Point(0, 1),
      const Point(-1, 1),
      const Point(-1, 0),
      const Point(-1, -1),
      const Point(0, -1),
      const Point(1, -1),
    ];

    while (circuitsCount < targetCircuits && attempts < maxAttempts) {
      attempts++;

      int startC = circuitRng.nextInt(cols);
      int startR = circuitRng.nextInt(rows);

      if (isOccupied(startC, startR)) continue;

      bool isBranching = circuitRng.nextDouble() < 0.4;

      Color circuitColor = Colors.blue;
      if (circuitRng.nextDouble() > 0.6) circuitColor = Colors.cyan;
      if (circuitRng.nextDouble() > 0.9) circuitColor = palette.accent;

      circuitPaint.color = circuitColor.withValues(alpha: 0.15);
      nodePaint.color = circuitColor.withValues(alpha: 0.3);

      List<List<Offset>> branches = [];

      List<Point<int>> currentPathPoints = [Point(startC, startR)];
      mark(startC, startR);

      int currC = startC;
      int currR = startR;

      int dirIdx = circuitRng.nextInt(4) * 2;

      int segments = 3 + circuitRng.nextInt(4);

      for (int s = 0; s < segments; s++) {
        int len = 2 + circuitRng.nextInt(3);
        Point<int> d = dirs[dirIdx];

        for (int l = 0; l < len; l++) {
          int nextC = currC + d.x;
          int nextR = currR + d.y;

          if (!isValid(nextC, nextR) || isOccupied(nextC, nextR)) {
            break;
          }

          mark(nextC, nextR);
          currentPathPoints.add(Point(nextC, nextR));
          currC = nextC;
          currR = nextR;
        }

        if (circuitRng.nextBool()) {
          dirIdx = (dirIdx + 1) % 8;
        } else {
          dirIdx = (dirIdx - 1 + 8) % 8;
        }
      }

      List<Offset> mainBranchOffsets = currentPathPoints
          .map((p) => Offset(p.x * gridSize, p.y * gridSize))
          .toList();
      branches.add(mainBranchOffsets);

      if (isBranching && mainBranchOffsets.length > 2) {
        int baseDir = dirIdx;

        List<int> branchDirs = [
          (baseDir - 1 + 8) % 8,
          baseDir,
          (baseDir + 1) % 8
        ];

        for (int bDir in branchDirs) {
          List<Point<int>> branchPts = [Point(currC, currR)];
          int bC = currC;
          int bR = currR;
          Point<int> d = dirs[bDir];

          int bLen = 3 + circuitRng.nextInt(3);

          for (int l = 0; l < bLen; l++) {
            int nC = bC + d.x;
            int nR = bR + d.y;
            if (!isValid(nC, nR) || isOccupied(nC, nR)) {
              break;
            }
            mark(nC, nR);
            branchPts.add(Point(nC, nR));
            bC = nC;
            bR = nR;
          }

          if (branchPts.length > 1) {
            branches.add(branchPts
                .map((p) => Offset(p.x * gridSize, p.y * gridSize))
                .toList());
          }
        }
      }

      if (branches.isEmpty) continue;
      circuitsCount++;

      for (var branch in branches) {
        if (branch.length < 2) continue;
        Path path = Path()..moveTo(branch.first.dx, branch.first.dy);
        for (int k = 1; k < branch.length; k++) {
          path.lineTo(branch[k].dx, branch[k].dy);
        }
        canvas.drawPath(path, circuitPaint);

        canvas.drawCircle(branch.first, 3.0, nodePaint);
        canvas.drawCircle(branch.last, 3.0, nodePaint);
        canvas.drawCircle(
            branch.first, 1.5, Paint()..color = const Color(0xFF001030));
        canvas.drawCircle(
            branch.last, 1.5, Paint()..color = const Color(0xFF001030));
      }

      double loopDuration = 2.0;

      double localTime = (t * 15.0 + (circuitsCount * 0.5)) % loopDuration;
      double progress = localTime / loopDuration;

      double head = progress * 1.4 - 0.2;
      double tail = head - 0.4;

      head = head.clamp(0.0, 1.0);
      tail = tail.clamp(0.0, 1.0);

      if (head > tail) {
        for (var branch in branches) {
          if (branch.length < 2) continue;
          Path path = Path()..moveTo(branch.first.dx, branch.first.dy);
          for (int k = 1; k < branch.length; k++) {
            path.lineTo(branch[k].dx, branch[k].dy);
          }

          ui.PathMetrics metrics = path.computeMetrics();
          for (var metric in metrics) {
            double start = metric.length * tail;
            double end = metric.length * head;

            if (end > start) {
              Path extract = metric.extractPath(start, end);

              final glowPaint = Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3.0
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round
                ..color = circuitColor.withValues(alpha: 0.8)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
              canvas.drawPath(extract, glowPaint);

              final corePaint = Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.5
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round
                ..color = Colors.white;
              canvas.drawPath(extract, corePaint);
            }
          }
        }
      }
    }
  }
}
