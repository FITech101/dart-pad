import 'dart:html' hide Document, Console;
import 'package:diff_match_patch/diff_match_patch.dart';

final DiffMatchPatch diffMatchPatch = DiffMatchPatch();

class ParentLogger {
  final _iFrameId;

  ParentLogger(this._iFrameId);

  Map _logMessage(type, action, {code}) {
    return {
      'iFrameId': _iFrameId,
      'type': type,
      'action': action,
      'code': code,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    };
  }

  void logCodeExecution(code) {
    window.parent
        ?.postMessage(_logMessage('button click', 'execute', code: code), '*');
  }

  void logCodeReset(code) {
    window.parent?.postMessage(
        _logMessage('button click', 'reset code', code: code), '*');
  }

  void logCodeFormat(code) {
    window.parent?.postMessage(_logMessage('button click', 'format', code: code), '*');
  }

  List<List> diffsAsListMap(List<Diff> diffs) {
    List<List> result = [];

    for (Diff diff in diffs) {
      result.add([diff.operation, diff.text]);
    }

    return result;
  }

  List<Map> patchesAsListMap(List<Patch> patches) {
    List<Map> result = [];

    for (Patch patch in patches) {
      result.add({
        'start1': patch.start1,
        'start2': patch.start2,
        'length1': patch.length1,
        'length2': patch.length2,
        'diffs': diffsAsListMap(patch.diffs)
      });
    }

    return result;
  }

  Map _codeChange(String editorTab, List<Patch> patches) {
    return {
      'iFrameId': _iFrameId,
      'type': 'code change',
      'editorTab': editorTab,
      'patches': patchesAsListMap(patches),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  void logCodeChange(String editorTab, String from, String to) {
    List<Patch> patches = diffMatchPatch.patch(from, to);
    Map change = _codeChange(editorTab, patches);
    window.parent?.postMessage(change, '*');
  }
}