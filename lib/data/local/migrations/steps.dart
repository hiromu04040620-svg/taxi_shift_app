// import 'package:drift/drift.dart';
// import 'schema_v1.dart' as v1;

/// Step-by-step migrations from v1 onwards will be defined here.
/// See Drift documentation for MigrationStrategy.stepByStep details.
///
/// 注意: テーブル定義変更時（カラムの増減など）は、
/// 必ず AppDatabase.onCreate の updatedAt トリガーも
/// 合わせて再生成・再定義すること。
class MigrationSteps {
  // Example for future:
  // static final stepByStep = stepByStepHelper(
  //   from1To2: (m, schema) async {
  //     await m.addColumn(schema.someTable, schema.someTable.newColumn);
  //   },
  // );
}
