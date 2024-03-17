import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/partition_leaf_accesor_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/room_creator_visitor.dart';


import 'resources/test_object.dart';
import 'resources/test_visitor_config.dart';
import 'visitor_test.mocks.dart';


// NOTE: Mock化したいクラス<Foo>を指定して下記のアノテーションを追加する
// Mock化したいクラス<Foo>を指定して`dart run build_runner build`
// すると、`visitor_test.mocks.dart`が生成される。
@GenerateNiceMocks([MockSpec<PartitionCreatorAdjustor>()])
void main() {
  final config = TestVisitorConfig();
  late Partition partition;
  late Area testArea;
  late List<List<int>> testRect;

  late PartitionCreatorVisitor partitionCreator;
  late PartitionLeafAccessorVisitor leafAccessor;
  late RoomCreatorVisitor roomCreator;
  late PartitionArrangerVisitor partitionArranger;
  final MockPartitionCreatorAdjustor adjustor = MockPartitionCreatorAdjustor();




  group('Test stage state of game initialization.', () {

    setUp(() {
      // 初期partitionの作成
      testRect = List.generate(config.dungeonHeight,
              (i) => List.generate(config.dungeonWidth, (j) => 8));

      // 初期のエリアを作成
      testArea = Area(
          from: Point(y: 0, x: 0),
          to: Point(y: config.dungeonHeight - 1, x: config.dungeonWidth - 1));

      // Root Partitionを作成
      partition = Partition(
          depth: 0,
          isRoot: true,
          rect: testRect,
          absArea: testArea,
          name: "r",
          config: config);

      leafAccessor =
          PartitionLeafAccessorVisitor(config: config);

      partitionCreator =
          PartitionCreatorVisitor(config: config, adjustor: adjustor);

      partitionCreator =
          PartitionCreatorVisitor(config: config, adjustor: adjustor);

    });

    group('Visitor test', () {

      test('PartitionLeafAccessorVisitor', () {
        /* partitionの子供の要素をリストで取得できているかどうか*/
        Partition child = Partition(
            depth: 1,
            isRoot: false,
            rect: List.generate(5,
                    (i) => List.generate(4, (j) => 8)),
            absArea: testArea, // don't care.
            name: "dummy",
            config: config);

        partition.children.addAll([child,child]);

        List<Partition> target = leafAccessor.visit(partition, isDebug: true);
        for(Partition leaf in target){
          expect(leaf.rect.length, 5);
          expect(leaf.rect.first.length, 4);
        }
      });

      test('PartitionCreatorVisitor test', () {

        // testでは比率と方向を固定する
        when(adjustor.adjustSplitAxis(any)).thenReturn("vertical");
        when(adjustor.adjustSplitRatio(any)).thenReturn(0.5);

        partitionCreator.visit(partition, isDebug: true);
        List<Partition> vTarget = leafAccessor.visit(partition);

        /* 適切な幅で分割できているか */
        for (var leaf in vTarget) {
          expect(leaf.rect.length, config.dungeonHeight.toInt());
          expect(leaf.rect.first.length, config.dungeonWidth~/4);
        }

        /* その他の設定値が正しいか (split: vertical) */
        vTarget.asMap().forEach((int i, var leafChild) {
          Area expectedArea = Area(
              from: Point(
                  y: 0,
                  x: (i * config.dungeonWidth)~/pow(2, config.dungeonDepth)),
              to: Point(
                  y: config.dungeonHeight - 1,
                  x: ((i + 1) * config.dungeonWidth)~/pow(2, config.dungeonDepth) - 1
              )
          );

          expect(leafChild.absArea.toString(), expectedArea.toString());
          expect(leafChild.depth, config.dungeonDepth);
          expect(leafChild.isRoot, false);
          expect(leafChild.children.isEmpty, true);
        });

        // split: horizontalの場合
        when(adjustor.adjustSplitAxis(any)).thenReturn("horizontal");
        partitionCreator.visit(partition, isDebug: true);
        List<Partition> hTarget = leafAccessor.visit(partition);

        for (var leaf in hTarget) {
          expect(leaf.rect.length, config.dungeonHeight~/4);
          expect(leaf.rect.first.length, config.dungeonWidth);
        }

        /* その他の設定値が正しいか (split: horizontal) */
        hTarget.asMap().forEach((int i, var leafChild) {
          Area expectedArea = Area(
              from: Point(
                  y: (i * config.dungeonHeight)~/pow(2, config.dungeonDepth),
                  x: 0),
              to: Point(
                  y: ((i + 1) * config.dungeonHeight)~/pow(2, config.dungeonDepth) - 1,
                  x: config.dungeonWidth -1
              )
          );
          expect(leafChild.absArea.toString(), expectedArea.toString());
          expect(leafChild.depth, config.dungeonDepth);
          expect(leafChild.isRoot, false);
          expect(leafChild.children.isEmpty, true);
        }
        );

        // TODO: absAreaのテスト

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

