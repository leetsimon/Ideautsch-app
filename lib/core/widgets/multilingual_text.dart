import 'package:flutter/material.dart';

/// Detects whether text contains Arabic/Hebrew script and renders
/// with the correct text direction (RTL for Arabic/Darija, LTR otherwise).
///
/// Use this for any user-facing text that may contain Darija or Arabic.
/// German, English, and French remain LTR.
class MultilingualText extends StatelessWidget {
  const MultilingualText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final isRtl = _containsArabicScript(text);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Text(
        text,
        style: style,
        textAlign: textAlign ?? (isRtl ? TextAlign.right : TextAlign.start),
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  /// Returns true if the text contains Arabic/Hebrew Unicode characters.
  /// Covers: Arabic (U+0600–U+06FF), Arabic Supplement, Arabic Extended.
  static bool _containsArabicScript(String text) {
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(text);
  }
}

/// A helper function to check if text needs RTL rendering.
/// Can be used outside the widget for conditional layout decisions.
bool isArabicText(String text) {
  return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
      .hasMatch(text);
}
