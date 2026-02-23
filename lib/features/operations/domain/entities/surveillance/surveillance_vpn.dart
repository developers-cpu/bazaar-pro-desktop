class SurveillanceVpn {
  final bool masterRestriction;
  final bool clientRestriction;

  const SurveillanceVpn({
    required this.masterRestriction,
    required this.clientRestriction,
  });

  SurveillanceVpn copyWith({bool? masterRestriction, bool? clientRestriction}) {
    return SurveillanceVpn(
      masterRestriction: masterRestriction ?? this.masterRestriction,
      clientRestriction: clientRestriction ?? this.clientRestriction,
    );
  }
}
