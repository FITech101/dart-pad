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

  void logCodeChange(String editorTab, Object? changeDiff) {
    final message = {
      'iFrameId': _iFrameId,
      'type': 'code change',
      'editorTab': editorTab,
      'changeDiff': changeDiff,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    window.parent?.postMessage(message, '*');
  }
}