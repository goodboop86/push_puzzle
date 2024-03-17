// Mocks generated by Mockito 5.4.4 from annotations
// in push_puzzle/test/visitor_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:push_puzzle/algorithm/structure/partition.dart' as _i3;
import 'package:push_puzzle/algorithm/visitor/partition_creator_visitor.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [PartitionCreatorAdjustor].
///
/// See the documentation for Mockito's code generation for more information.
class MockPartitionCreatorAdjustor extends _i1.Mock
    implements _i2.PartitionCreatorAdjustor {
  @override
  String adjustSplitAxis(_i3.Partition? p) => (super.noSuchMethod(
        Invocation.method(
          #adjustSplitAxis,
          [p],
        ),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #adjustSplitAxis,
            [p],
          ),
        ),
        returnValueForMissingStub: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #adjustSplitAxis,
            [p],
          ),
        ),
      ) as String);

  @override
  double adjustSplitRatio(_i3.Partition? p) => (super.noSuchMethod(
        Invocation.method(
          #adjustSplitRatio,
          [p],
        ),
        returnValue: 0.0,
        returnValueForMissingStub: 0.0,
      ) as double);
}
