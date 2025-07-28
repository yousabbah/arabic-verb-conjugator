import 'package:arabic_verb_final/core/conjugation/pre_post_processing.dart';
class PasPart {
  PasPart();
  final PrePostProcessing _prePostProcessing = PrePostProcessing();

  String passiveParticiple(String s) {
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

    if (length == 4) {
      return _handleFourLetterVerbs(s);
    }

    if (length == 5) {
      return _handleFiveLetterVerbs(s);
    }

    if (length == 6) {
      return _handleSixLetterVerbs(s);
    }

    return s;
  }

  String _handleTwoLetterVerbs(String s) {
    if (s.startsWith('آ')) {
      return 'مَؤو${s[1]}'; // آن → مؤون
    }
    return 'إدخال خاطئ!: 2';
  }

  String _handleThreeLetterVerbs(String s) {
    if (s.endsWith('ّ') && !s.startsWith('آ')) {
      return 'مَ${s.substring(0, 2)}و${s[1]}'; // ردّ → مردود
    }

    if (s[1] == 'أ' || s[1] == 'ؤ' || s[1] == 'ئ') {
      var result = 'مَ${s[0]}ئو${s[2]} / مَ${s[0]}ؤو${s[2]}';
      if (result.endsWith('ى')) {
        result = '${result.substring(0, 4)}ِيّ'; // رأى → مرئيّ
      }
      return result;
    }

    if (s.startsWith('آ')) {
      if (s[2] == 'ّ') {
        return 'مُؤا${s.substring(1)} / مؤَ${s.substring(1)}';
      } else {
        return 'مُؤا${s[1]}َ${s[2]} / مُؤ${s[1]}َ${s[2]}';
      }
    }

    if (s.endsWith('ا') || s.endsWith('و')) {
      return 'مَ${s.substring(0, 2)}وّ'; // دنا → مدنوّ
    }

    if (s.startsWith('أ')) {
      if (s.endsWith('ى')) {
        return s[1] == 'ر' 
            ? 'مُ${s.substring(1)}' // أرى → مُرى
            : 'مَ${s.substring(0, 2)}ِيّ'; // أتى → مأتِيّ
      } else if (s[1] == 'آ') {
        return 'مُؤا${s[2]}'; // أآل → مؤال
      } else {
        return 'مَ${s.substring(0, 2)}و${s[2]}'; // أسف → مأسوف
      }
    }

    if ((s[1] == 'ا' || s[1] == 'و') && !s.endsWith('ى')) {
      return 'مَ${s[0]}و${s[2]}'; // زوِر → مزور
    }

    if (s.endsWith('ي') || s.endsWith('ى')) {
      return 'مَ${s.substring(0, 2)}ِيّ'; // رمى → مرميّ
    }

    if (s.endsWith('أ') || s.endsWith('ؤ') || s.endsWith('ئ')) {
      return 'مَ${s.substring(0, 2)}وء'; // بدأ → مبدوء
    }

    // Default case for 3-letter verbs
    return 'مَ${s.substring(0, 2)}و${s[2]}';
  }

  String _handleFourLetterVerbs(String s) {
    if (s.startsWith('أ')) {
      if (s[2] == 'ّ') {
        return 'مُؤَ${s.substring(1, 3)}َ${s[3]}'; // أيّد → مؤيّد
      } else if (s.endsWith('ّ')) {
        return 'مُ${s[1]}َ${s.substring(2)}'; // أصرّ → مصرّ
      } else if (s[2] == 'ا') {
        return 'مُ${s.substring(1)}'; // أقام → مقام
      } else if (s[1] == 'ي') {
        return 'مُو${s[2]}َ${s[3]}'; // أيقن → موقن
      } else {
        return 'مُ${s.substring(1, 3)}َ${s[3]}'; // أجبر → مجبر
      }
    }

    if ((s[1] == 'ا' || s[1] == 'آ') && s.endsWith('ّ')) {
      return 'مُ$s'; // تآنّ → متآنّ
    }

    if (s.startsWith('ا') && s[2] == 'آ') {
      return 'مُ${s.substring(1)}'; // انآن → منآن
    }

    // Default case for 4-letter verbs
    return 'مُ${s.substring(0, 3)}َ${s[3]}';
  }

  String _handleFiveLetterVerbs(String s) {
    if (s.startsWith('ا')) {
      if (s.endsWith('ّ') && s[1] != 'ئ') {
        return 'مُ${s.substring(1, 3)}َ${s.substring(3)}'; // انحلّ → منحلّ
      } else if ((s[3] == 'ا' || s[3] == 'آ') && s[1] != 'ئ') {
        return 'مُ${s.substring(1)}'; // احتال → محتال
      } else if (s[1] == 'ئ') {
        if (s.endsWith('ّ') || s[3] == 'ا') {
          return 'مُؤ${s.substring(2)}'; // ائتال → مؤتال
        } else {
          return 'مُؤ${s.substring(2, 4)}َ${s[4]}'; // ائتمر → مؤتمر
        }
      } else {
        return 'مُ${s.substring(1, 4)}َ${s[4]}'; // انفعل → منفعل
      }
    }

    if (s[2] == 'ا' && s.endsWith('ّ')) {
      return 'مُ$s'; // توادّ → متوادّ
    }

    // Default case for 5-letter verbs
    return 'مُ${s.substring(0, 4)}َ${s[4]}';
  }

  String _handleSixLetterVerbs(String s) {
    if (s[4] == 'ا') {
      return 'مُ${s.substring(1, 5)}${s[5]}'; // استفاد → مستفاد
    } else if (s.endsWith('ّ')) {
      if (s[3] == 'ا') {
        return 'مُ${s.substring(1)}'; // احوالّ → محوالّ
      } else {
        return 'مُ${s.substring(1, 4)}َ${s.substring(4)}'; // استقرّ → مستقرّ
      }
    } else {
      var result = 'مُ${s.substring(1, 5)}َ${s[5]}';
      if (result[2] == 'ئ') {
        result = result.replaceRange(2, 3, 'ؤ'); // ائنَوْنَن → مؤنونن
      }
      return result;
    }
  }
}