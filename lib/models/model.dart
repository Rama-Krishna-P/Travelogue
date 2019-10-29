import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const tableTrip = SqfEntityTable(
    tableName: 'trip',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    fields: [
      SqfEntityField('name', DbType.text),
      SqfEntityField('fromDate', DbType.text),
      SqfEntityField('toDate', DbType.text),
    ]
);

const tablePlace = SqfEntityTable(
    tableName: 'place',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    fields: [
      SqfEntityField('name', DbType.text),
      SqfEntityField('type', DbType.text),
      SqfEntityField('startDate', DbType.text),
      SqfEntityField('stopDate', DbType.text),
      SqfEntityField('dateCreated', DbType.text),
      SqfEntityField('latitude', DbType.real),
      SqfEntityField('longitude', DbType.real),
      SqfEntityFieldRelationship(
        parentTable: tableTrip,
        deleteRule: DeleteRule.CASCADE,
      )
    ],
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
    modelName: 'MyDbModel', // optional
    databaseName: 'sampleORM.db',
    databaseTables: [tableTrip, tablePlace],
    bundledDatabasePath: null
);