import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/group.dart';

class GroupController extends ChangeNotifier {
  final _uuid = const Uuid();
  final List<Group> _groups = [];

  UnmodifiableListView<Group> get groups => UnmodifiableListView(_groups);

  void bootstrap() {
    if (_groups.isNotEmpty) {
      return;
    }

    final now = DateTime.now();
    _groups.addAll([
      Group(
        id: _uuid.v4(),
        name: 'Design Sprint',
        participants: const ['Alex', 'Priya', 'Mason'],
        link: _buildLink(),
        isActive: false,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
      Group(
        id: _uuid.v4(),
        name: 'QA Sync',
        participants: const ['Lee', 'Sam'],
        link: _buildLink(),
        isActive: true,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(minutes: 42)),
      ),
    ]);
  }

  Group createGroup({
    required String name,
    List<String> participants = const [],
  }) {
    final now = DateTime.now();
    final group = Group(
      id: _uuid.v4(),
      name: name,
      participants: participants,
      link: _buildLink(),
      isActive: false,
      createdAt: now,
      updatedAt: now,
    );
    _groups.insert(0, group);
    notifyListeners();
    return group;
  }

  Group? joinByLink(String link, {String? participant}) {
    final index = _groups.indexWhere((group) => group.link == link);
    if (index == -1) {
      return null;
    }

    final existing = _groups[index];

    Group updated;

    if (participant != null && participant.isNotEmpty) {
      final updatedParticipants = List<String>.from(existing.participants);
      if (!updatedParticipants.contains(participant)) {
        updatedParticipants.add(participant);
      }
      updated = existing.copyWith(
        participants: updatedParticipants,
        updatedAt: DateTime.now(),
        isActive: true,
      );
    } else {
      updated = existing.copyWith(
        updatedAt: DateTime.now(),
        isActive: true,
      );
    }

    _replace(updated, notify: false);
    _moveToTop(updated.id, notify: false);
    notifyListeners();

    return _groups.firstWhere((group) => group.id == updated.id);
  }

  void toggleActive(String id, bool value) {
    final idx = _groups.indexWhere((element) => element.id == id);
    if (idx == -1) return;
    final group = _groups[idx];
    _groups[idx] = group.copyWith(
      isActive: value,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  String _buildLink() {
    final roomId = _uuid.v4().split('-').first;
    return 'https://p2p.call/room/$roomId';
  }

  void _replace(Group group, {bool notify = true}) {
    final idx = _groups.indexWhere((element) => element.id == group.id);
    if (idx == -1) return;
    _groups[idx] = group;
    if (notify) {
      notifyListeners();
    }
  }

  void _moveToTop(String id, {bool notify = true}) {
    final idx = _groups.indexWhere((element) => element.id == id);
    if (idx <= 0) return;
    final group = _groups.removeAt(idx);
    _groups.insert(0, group);
    if (notify) {
      notifyListeners();
    }
  }
}
