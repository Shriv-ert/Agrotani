// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Agrotani Design System — Color Palette
/// Based on: Primary green (nature/growth), Amber accent (harvest/warmth)
class AppColors {
  AppColors._();

  // ── PRIMARY (Green — Nature & Growth) ─────────────────────────────
  static const Color primary = Color(0xFF1B5E20);       // Deep forest green
  static const Color primaryLight = Color(0xFF2E7D32);  // Main green
  static const Color primaryMid = Color(0xFF388E3C);    // Medium green
  static const Color primarySoft = Color(0xFFE8F5E9);   // Very light green (surface)

  // ── ACCENT (Amber — Harvest & Warmth) ─────────────────────────────
  static const Color accent = Color(0xFFFF8F00);        // Amber
  static const Color accentLight = Color(0xFFFFB300);   // Light amber
  static const Color accentSoft = Color(0xFFFFF3E0);    // Very light amber (surface)

  // ── SEMANTIC COLORS ───────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFF8F00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1565C0);

  // ── SEVERITY COLORS ───────────────────────────────────────────────
  static const Color severityLow = Color(0xFF2E7D32);    // Ringan = green
  static const Color severityMedium = Color(0xFFFF8F00); // Sedang = amber
  static const Color severityHigh = Color(0xFFD32F2F);   // Parah = red

  // ── NEUTRAL / BACKGROUND ──────────────────────────────────────────
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color divider = Color(0xFFE0E0E0);

  // ── TEXT ──────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ── CHAT BUBBLES ──────────────────────────────────────────────────
  static const Color chatUserBubble = Color(0xFF2E7D32);
  static const Color chatBotBubble = Color(0xFFF1F8E9);
  static const Color chatUserText = Color(0xFFFFFFFF);
  static const Color chatBotText = Color(0xFF1A1A1A);

  // ── GRADIENT PAIRS ────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF8F00), Color(0xFFFFB300)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F8E9)],
  );
}
