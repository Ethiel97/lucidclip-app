class ProPlan {
  const ProPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.ctaLabel,
    required this.productId,
    this.badge,
  });

  final String id; // "monthly", "yearly"
  final String title;
  final String subtitle;
  final String priceLabel;
  final String ctaLabel;
  final String productId;

  final String? badge; // "Best value"
}
