import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/visitor_config.dart';


import 'resources/test_object.dart';
import 'visitor_test.mocks.dart';


// NOTE: Mock化したいクラス<Foo>を指定して下記のアノテーションを追加する
// Mock化したいクラス<Foo>を指定して`dart run build_runner build`
// すると、`visitor_test.mocks.dart`が生成される。
@GenerateNiceMocks([MockSpec<PartitionCreatorAdjustor>()])
void main() {
  final config = VisitorConfig();
  late Partition partition;
  MockPartitionCreatorAdjustor adjustor = MockPartitionCreatorAdjustor();

  // 初期partitionの作成
  var initialRect = List.generate(config.dungeonHeight,
          (i) => List.generate(config.dungeonWidth, (j) => 8));

  // 初期のエリアを作成
  var initialArea = Area(
      from: Point(y: 0, x: 0),
      to: Point(y: config.dungeonHeight - 1, x: config.dungeonWidth - 1));

  // Root Partitionを作成
  partition = Partition(
      depth: 0,
      isRoot: true,
      rect: initialRect,
      absArea: initialArea,
      name: "r",
      config: config);


  group('Test stage state of game initialization.', () {

    setUp(() {

    });

    group('Visitor test', () {
      test('PartitionCreatorVisitor test', () {

        when(adjustor.adjustSplitAxis(any)).thenReturn("vertical");
        when(adjustor.adjustSplitRatio(any)).thenReturn(0.5);

        PartitionCreatorVisitor visitor =
        PartitionCreatorVisitor(config: config, adjustor: adjustor);

        visitor.visit(partition, isDebug: true);

      // for (var p in partition.children) {
      //   for (var e in p.children) {
      //     expect(e.rect.length, 10);
      //     expect(e.rect.first.length, 5);
      //   }
      // }

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

