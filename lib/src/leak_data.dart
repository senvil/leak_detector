// Copyright (c) $today.year, Jiakuo Liu. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

class LeakedInfo {
  List<RetainingNode> retainingPath;
  String gcRootType;
  int timestamp;

  LeakedInfo(this.retainingPath, this.gcRootType, {this.timestamp}) {
    if (timestamp == null) {
      timestamp = DateTime.now().millisecondsSinceEpoch;
    }
  }

  bool get isNotEmpty => retainingPath != null && retainingPath.isNotEmpty;

  ///to json string
  String get retainingPathJson {
    if (isNotEmpty) {
      return jsonEncode(retainingPath.map((path) => path.toJson()).toList());
    }
    return '[]';
  }

  @override
  String toString() {
    return '$gcRootType, retainingPath: $retainingPathJson';
  }
}

///leaked node info
class RetainingNode {
  String clazz;
  String parentField;
  bool important; //进过分析是否为重要的节点
  String libraries;
  String string;
  String parentKey;
  int parentIndex;
  SourceCodeLocation sourceCodeLocation;
  ClosureInfo closureInfo;

  RetainingNode(
    this.clazz, {
    this.parentKey,
    this.parentIndex,
    this.string,
    this.sourceCodeLocation,
    this.parentField,
    this.libraries,
    this.important = false,
    this.closureInfo,
  });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'clazz': clazz,
      'parentKey': parentKey,
      'string': string,
      'parentIndex': parentIndex,
      'sourceCodeLocation': sourceCodeLocation?.toJson(),
      'parentField': parentField,
      'libraries': libraries,
      'important': important,
      'closureInfo': closureInfo?.toJson(),
    };
  }

  RetainingNode.fromJson(Map<String, dynamic> json) {
    clazz = json['clazz'];
    parentKey = json['parentKey'];
    parentIndex = json['parentIndex'];
    string = json['string'];
    if (json['sourceCodeLocation'] is Map) {
      sourceCodeLocation = SourceCodeLocation.fromJson(json['sourceCodeLocation']);
    }
    parentField = json['parentField'];
    libraries = json['libraries'];
    important = json['important'];
    if (json['closureInfo'] is Map) {
      closureInfo = ClosureInfo.fromJson(json['closureInfo']);
    }
  }
}

///leaked field source code location
class SourceCodeLocation {
  String code;
  int lineNum;
  int columnNum;
  String className;
  String uri; //lib uri

  SourceCodeLocation(this.code, this.lineNum, this.columnNum, this.className, this.uri);

  SourceCodeLocation.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    lineNum = json['lineNum'];
    columnNum = json['columnNum'];
    className = json['className'];
    uri = json['uri'];
  }

  @override
  String toString() {
    return '$code($lineNum:$columnNum) $uri#$className';
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'lineNum': lineNum,
      'columnNum': columnNum,
      'className': className,
      'uri': uri,
    };
  }
}

/// if leaked node if Closure
class ClosureInfo {
  String closureFunctionName;
  String closureOwner; //可能是 方法、类、包
  String closureOwnerClass; //如果owner是类=owner，owner是方法所在类
  String libraries;
  int funLine;
  int funColumn;

  ClosureInfo({
    this.closureFunctionName,
    this.closureOwner,
    this.closureOwnerClass,
    this.libraries,
    this.funLine,
    this.funColumn,
  });

  ClosureInfo.fromJson(Map<String, dynamic> json) {
    closureFunctionName = json['closureFunctionName'];
    closureOwner = json['closureOwner'];
    closureOwnerClass = json['closureOwnerClass'];
    libraries = json['libraries'];
    funLine = json['funLine'];
    funColumn = json['funColumn'];
  }

  Map<String, dynamic> toJson() {
    return {
      'closureFunctionName': closureFunctionName,
      'closureOwner': closureOwner,
      'closureOwnerClass': closureOwnerClass,
      'libraries': libraries,
      'funLine': funLine,
      'funColumn': funColumn,
    };
  }

  @override
  String toString() {
    return '$libraries\nclosureFunName:$closureFunctionName($funLine:$funColumn)\nowner:$closureOwner\nownerClass:$closureOwnerClass';
  }
}