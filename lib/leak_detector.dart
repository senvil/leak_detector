// Copyright (c) $today.year, Jiakuo Liu. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library leak_detector;

import 'package:leak_detector/src/leak_data_base_helper.dart';
import 'src/leak_data.dart';

export 'src/leak_detector.dart';
export 'src/leak_state_mixin.dart';
export 'src/view/leak_preview_page.dart';
export 'src/leak_data.dart';

Future<List<LeakedInfo>> getLeakedRecording() => LeakedRecordDatabaseHelper().queryAll();