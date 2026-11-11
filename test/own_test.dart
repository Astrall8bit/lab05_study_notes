import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab05_study_notes/data/notes_repository.dart';

void main() {
  setUpAll(FakeFirebaseFirestore.new);

  group('Own Custom Tests - NotesRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late NotesRepository repository;
    const testUid = 'user123';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = NotesRepository(fakeFirestore);
    });

    test('addNote trims whitespace from title and body before storing', () async {
      await repository.addNote(testUid, '  Clean Title  ', '  Clean Body  ');

      final snapshot = await fakeFirestore
          .collection('users')
          .doc(testUid)
          .collection('notes')
          .get();

      expect(snapshot.docs.length, equals(1));
      expect(snapshot.docs.first.data()['title'], equals('Clean Title'));
      expect(snapshot.docs.first.data()['body'], equals('Clean Body'));
    });

    test('addNote throws ArgumentError when trimmed title exceeds 100 chars', () {
      final longTitle = 'a' * 101;
      expect(
        () => repository.addNote(testUid, longTitle, 'Valid body'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}