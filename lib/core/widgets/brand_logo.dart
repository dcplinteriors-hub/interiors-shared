import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/brand_gradient.dart';

/// The DCPL wordmark, painted with the Molten gradient via a [ShaderMask].
///
/// Reproduces the logo in code (no image asset to manage / rescale). Use large
/// on the login & splash hero; smaller inline where the brand should sign a
/// surface. Set [showTagline] for the "Diverse Creation Private Limited" line.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.fontSize = 44, this.showTagline = false});

  final double fontSize;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final wordmark = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => BrandGradient.horizontal.createShader(bounds),
      child: Text(
        'DCPL',
        style: GoogleFonts.sora(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -fontSize * 0.04,
          height: 1,
          color: Colors.white, // masked by the gradient shader
        ),
      ),
    );

    if (!showTagline) return wordmark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        wordmark,
        SizedBox(height: fontSize * 0.16),
        Text(
          'DIVERSE CREATION PRIVATE LIMITED',
          style: GoogleFonts.inter(
            fontSize: fontSize * 0.16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.4,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// A compact square brand mark — gradient tile with the logo's "D".
///
/// For app-bar leadings and tight spots where the full wordmark won't fit.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: BrandGradient.diagonal,
        borderRadius: BorderRadius.circular(size * 0.26),
      ),
      alignment: Alignment.center,
      child: Text(
        'D',
        style: GoogleFonts.sora(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.56,
          height: 1,
        ),
      ),
    );
  }
}
