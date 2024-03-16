import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/visitor_config.dart';

import 'package:push_puzzle/src/stage_state.dart';

import 'resources/test_object.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  TestObject testObj = TestObject();
  Partition partition = testObj.partition;
  VisitorConfig config = testObj.config;


  group('Test stage state of game initialization.', () {

    setUp(() {
    });

    group('Visitor test', () {
      test('PartitionCreatorVisitor test', () {
        expect(1, 1);
      });
      test('RoomCreatorVisitor test', () {
        expect(1, 1);
      });
      test('PartitionArrangerVisitor test', () {
        expect(1, 1);
      });
      test('playerVecPos', () {
        expect(1, 1);
      });
    });
  });
}
