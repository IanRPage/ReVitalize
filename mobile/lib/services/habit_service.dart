import 'package:cloud_firestore/cloud_firestore.dart';

class HabitService {
  final FirebaseFirestore _db;

  HabitService({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _habitsRef(String uid) {
    return _db.collection('users').doc(uid).collection('habits');
  }

  String _weekdayName(int weekday) {
    const names = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[(weekday - 1) % 7];
  }

  Future<List<String>> _completedDaysForCurrentWeek(
    DocumentReference<Map<String, dynamic>> habitRef,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final daysSinceSunday = today.weekday % 7;
    final startOfWeek = today.subtract(Duration(days: daysSinceSunday));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final logsSnap = await habitRef.collection('logs').get();

    final completedDays = <String>{};

    for (final logDoc in logsSnap.docs) {
      final data = logDoc.data();

      if (data['completed'] != true) continue;

      final ts = data['date'] as Timestamp?;
      if (ts == null) continue;

      final dt = ts.toDate();

      if (dt.isBefore(startOfWeek) || !dt.isBefore(endOfWeek)) continue;

      final name = _weekdayName(dt.weekday);
      completedDays.add(name);
    }

    return completedDays.toList();
  }

  Future<List<Map<String, dynamic>>> getHabits({required String uid}) async {
    final snapshot = await _habitsRef(
      uid,
    ).orderBy('createdAt', descending: true).get();

    final List<Map<String, dynamic>> habits = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final completedDays = await _completedDaysForCurrentWeek(doc.reference);

      habits.add({
        'id': doc.id,
        'title': data['title'] as String? ?? '',
        'targetValue': data['targetValue'] as int? ?? 0,
        'unit': data['unit'] as String? ?? '',
        'themeColor': data['themeColor'] as String? ?? 'green',
        'todayValue': data['todayValue'] as int? ?? 0,
        'todayProgress': (data['todayProgress'] as num?)?.toDouble() ?? 0.0,
        'completedDays': completedDays,
      });
    }

    return habits;
  }

  Stream<List<Map<String, dynamic>>> watchHabits({required String uid}) {
    return _habitsRef(
      uid,
    ).orderBy('createdAt', descending: true).snapshots().asyncMap((
      snapshot,
    ) async {
      final List<Map<String, dynamic>> habits = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final completedDays = await _completedDaysForCurrentWeek(doc.reference);

        habits.add({
          'id': doc.id,
          'title': data['title'] as String? ?? '',
          'targetValue': data['targetValue'] as int? ?? 0,
          'unit': data['unit'] as String? ?? '',
          'themeColor': data['themeColor'] as String? ?? 'green',
          'todayValue': data['todayValue'] as int? ?? 0,
          'todayProgress': (data['todayProgress'] as num?)?.toDouble() ?? 0.0,
          'completedDays': completedDays,
        });
      }

      return habits;
    });
  }

  Future<void> addHabit({
    required String uid,
    required String title,
    required int targetValue,
    required String unit,
    required String themeColor,
  }) async {
    await _habitsRef(uid).add({
      'title': title,
      'targetValue': targetValue,
      'unit': unit,
      'themeColor': themeColor,
      'isArchived': false,
      'createdAt': FieldValue.serverTimestamp(),
      'todayValue': 0,
      'todayProgress': 0.0,
    });
  }

  Future<void> addToHabitToday({
    required String uid,
    required String habitId,
    required int delta,
  }) async {
    final habitRef = _habitsRef(uid).doc(habitId);
    final todayId = DateTime.now().toIso8601String().substring(
      0,
      10,
    ); // YYYY-MM-DD
    final logRef = habitRef.collection('logs').doc(todayId);

    await _db.runTransaction((txn) async {
      final habitSnap = await txn.get(habitRef);
      final logSnap = await txn.get(logRef);

      final target = (habitSnap.data()?['targetValue'] as int?) ?? 0;
      final prev = (logSnap.data()?['value'] as int?) ?? 0;
      final newValue = prev + delta;

      final completed = target > 0 && newValue >= target;
      final progress = target == 0 ? 0.0 : newValue / target;

      txn.set(logRef, {
        'date': Timestamp.fromDate(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        ),
        'value': newValue,
        'completed': completed,
      });

      txn.update(habitRef, {'todayValue': newValue, 'todayProgress': progress});
    });
  }
}
