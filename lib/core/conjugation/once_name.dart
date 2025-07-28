import 'package:arabic_verb_final/core/conjugation/pre_post_processing.dart';
class OnceName {
  final PrePostProcessing _prePostProcessing = PrePostProcessing();

  String once(String s) {
    if (s.isEmpty) return s;

    // Remove punctuation and morphology marks
    s = _prePostProcessing.removeMarks(s);
    var length = s.length;

    if (length == 2) {
      return _handleTwoLetterVerbs(s);
    }

    if (length == 3) {
      return _handleThreeLetterVerbs(s);
    }

    // For verbs longer than 3 letters
    return "بلا";
  }

  String _handleTwoLetterVerbs(String s) {
    if (s.startsWith("آ")) {
      return "أو${s[1]}ة"; // آب → أوبة
    }
    return "إدخال خاطئ!: 2";
  }

  String _handleThreeLetterVerbs(String s) {
    // Apply pre-processing
    var processed = _prePostProcessing.preOnce(s);
    
    // Add pattern and suffix
    return "${processed[0]}َ${processed.substring(1)}ة";
  }
}