import 'package:flutter/material.dart';

/// Asset paths for the official OneView logo artwork (the molten-gradient
/// "DCPL · OneView" lock-up on a transparent background — drops straight onto
/// the dark theme).
class BrandAssets {
  BrandAssets._();

  /// The OneView lock-up. (A dedicated square mark will replace this in compact
  /// spots once available.)
  static const logo = 'packages/dcpl_shared/assets/branding/oneview_logo.png';

  /// The full OneView brand lock-up — used on the login & splash hero.
  static const brand = 'packages/dcpl_shared/assets/branding/oneview_logo.png';
}

/// The OneView brand logo — renders the official gradient artwork (PNG), never
/// text. [tagline] = false → the wordmark ([BrandAssets.logo]); true → the full
/// lock-up with the company name ([BrandAssets.brand]).
///
/// Sized by [height]; width scales to the asset's aspect ratio. Use the lock-up
/// (tagline) on the login & splash hero; the plain wordmark in compact spots
/// such as the nav header.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.height = 40, this.tagline = false});

  final double height;
  final bool tagline;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      tagline ? BrandAssets.brand : BrandAssets.logo,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      semanticLabel: 'OneView',
    );
  }
}

/// A compact brand mark for tight, width-constrained spots (e.g. an app-bar
/// leading): the DCPL wordmark scaled to fit within a [size]-tall box, never
/// overflowing. Prefer [BrandWordmark] where horizontal room allows.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Image.asset(
        BrandAssets.logo,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        semanticLabel: 'OneView',
      ),
    );
  }
}
