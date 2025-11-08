import 'package:flutter/foundation.dart';

@immutable
class Group {
  const Group({
    required this.id,
    required this.name,
    required List<String> participants,
    required this.link,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  }) : participants = List.unmodifiable(participants);

  final String id;
  final String name;
  final List<String> participants;
  final String link;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Group copyWith({
    String? id,
    String? name,
    List<String>? participants,
    String? link,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: List.unmodifiable(participants ?? this.participants),
      link: link ?? this.link,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
