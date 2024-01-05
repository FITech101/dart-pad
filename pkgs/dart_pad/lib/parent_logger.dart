import 'dart:html' hide Document, Console;

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

  Map _codeChange(editorTab, diffs) {
    return {
      'iFrameId': _iFrameId,
      'type': 'code change',
      'editorTab': editorTab,
      'diffs': diffs,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  void logCodeChange(String editorTab, List<Map> diffs) {
    window.parent?.postMessage(_codeChange(editorTab, diffs), '*');
  }
}