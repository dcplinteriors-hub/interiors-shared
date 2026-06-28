/// A vendor / supplier the admin assigns to material requests. A managed directory entry with no
/// login (mirrors the backend `vendors` collection). `phone`/`email` are supported but the current
/// admin form only collects the name.
class Vendor {
  const Vendor({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.isActive = true,
    this.createdAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    isActive: json['isActive'] as bool? ?? true,
    createdAt: json['createdAt'] as String?,
  );

  final String id;
  final String name;
  final String? phone;
  final String? email;

  /// Deactivated vendors stay for history but drop out of the assign-vendor picker.
  final bool isActive;
  final String? createdAt;
}
