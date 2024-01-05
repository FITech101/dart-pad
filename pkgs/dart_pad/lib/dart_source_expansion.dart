const inputHandlerFun = """

Future<String> __readInputWithPrompt() async {
  await __sleep(250);
  var input = context.callMethod('prompt', ['The program asks for an input. Please type it here:']);
  if (input == null) {
    throw Exception("User pressed cancel when asked for input.");
  }
  
  return input;
}

Future __sleep(ms) {
  final duration = Duration(milliseconds: ms);
  return Future.delayed(duration, () => ms);
}""";

// TODO: filter out those that can't possibly match function syntax (check if unnecessary parentheses can be applied)
const keywords = [
  // Cannot have parenthesis after: 'class','false','async','import','static',
  // 'show','as','enum','final','true'

  // Unchecked
  'in',
  'export','sync','extends','is','this','extension','library',
  'throw','break','external','mixin','case','factory','new','try',
  'null','typedef','on','var','const',
  'finally','operator','void','continue','part','covariant',
  'rethrow','with','default','get','return','yield','deferred','hide','set',
  'do','implements','toString',
  // Can have parenthesis after:
  'catch','else','switch','await','super','for','while','if','assert',
];


String _asyncAllFunctions(String dartSource) {

  final asyncedFunctions = [];

  // Make all non-async functions async and add them to foundFunctions
  var source = dartSource.replaceAllMapped(
      RegExp(r'(\b[\w<>]+)?\s*\b((\w+)\s*\(.*\))\s*{', multiLine: true), (match) {
    if (keywords.contains(match.group(3))) {
      return match.group(0)!;
    }
    asyncedFunctions.add(match.group(3));
    final typeDef = match.group(1) != null ?
    'Future<${match.group(1)}> ' : '';
    return '$typeDef${match.group(2)} async {';
  });

  // add await for any asynced functions
  asyncedFunctions.forEach((functionName) {
    source = source.replaceAllMapped(
        RegExp('\\b($functionName\\(.*\\))(?! async {)', multiLine: true), (match) {
      return 'await ${match.group(1)}';
    });
  });

  return source;
}

String modifyDartSourceToHandleStdinReadLineSync(String dartSource) {
  const inputHandlerImports = "import 'dart:js';";
  dartSource = _asyncAllFunctions(dartSource);
  dartSource = dartSource.replaceAll(RegExp(r"stdin\s*\.\s*readLineSync\s*\(\s*\)"), "await __readInputWithPrompt()");

  return inputHandlerImports + dartSource + inputHandlerFun;
}