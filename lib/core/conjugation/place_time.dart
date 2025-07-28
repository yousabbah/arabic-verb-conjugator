import 'package:arabic_verb_final/core/conjugation/pre_post_processing.dart';
import 'package:arabic_verb_final/core/conjugation/pas_part.dart';
class PlaceTime {
  final PrePostProcessing _prePostProcessing = PrePostProcessing();
  final PasPart _pasPart = PasPart();

  String place(String s) {
    if (s.isEmpty) return s;

    // Remove punctuation and morphology marks
    s = _prePostProcessing.removeMarks(s);
    final length = s.length;

    if (length < 2 || length > 6) {
      return 'إدخال خاطئ!: $length';
    }

    if (length == 2) {
      return _handleTwoLetterVerbs(s);
    }

    if (length == 3) {
      return _handleThreeLetterVerbs(s);
    }

    // For verbs longer than 3 letters, use passive participle form
    return _pasPart.passiveParticiple(s);
  }

  String _handleTwoLetterVerbs(String s) {
    if (s.startsWith('آ')) {
      return 'مَ$s'; // آب → مآب
    }
    return 'إدخال خاطئ!: 2';
  }

  String _handleThreeLetterVerbs(String s) {
    var processed = s;

    // Handle special character replacements
    if (processed[1] == 'ئ' || processed[1] == 'ؤ') {
      processed = processed.replaceRange(1, 2, 'أ');
    }

    if (processed.endsWith('ؤ')) {
      processed = processed.replaceRange(2, 3, 'أ');
    }

    if (processed.endsWith('ي') || 
        processed.endsWith('و') || 
        processed.endsWith('ا')) {
      processed = processed.replaceRange(2, 3, 'ى');
    }

    if (processed == 'أرى') {
      return 'مُ${processed.substring(1)}'; // أرى → مرى
    }

    if (processed.startsWith('آ')) {
      if (processed.endsWith('ّ')) {
        return 'مُؤا${processed.substring(1)} / مؤَ${processed.substring(1)}';
      } else {
        return 'مُؤا${processed[1]}َ${processed[2]} / مُؤ${processed[1]}َ${processed[2]}';
      }
    }

    // Default case for 3-letter verbs
    return 'مَ$processed';
  }
}