import 'package:diff_match_patch/diff_match_patch.dart';

final DiffMatchPatch dmp = DiffMatchPatch();

List<Map> getDiffs(String str1, String str2) {
  List<Patch> patches = dmp.patch(str1, str2);
  List<Map> result = [];

  for (Patch p in patches) {
    int s = p.start1;
    String diffText = '';
    String action = 'insert';

    for (Diff diff in p.diffs) {
      if (diff.operation == DIFF_EQUAL) {
        s += diff.text.length;
        continue;
      }

      diffText = diff.text;
      action = diff.operation == DIFF_DELETE ? 'remove': 'insert';
      break;
    }

    result.add({
      's': s,
      't': diffText,
      'a': action
    });
  }

  return result;
}