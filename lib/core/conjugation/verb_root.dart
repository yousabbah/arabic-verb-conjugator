import 'package:arabic_verb_final/core/conjugation/pre_post_processing.dart';
class VerbRoot {
  String getRoot(String s) {
    String s1 = "";
    final pr = PrePostProcessing();
    
    if (s.isNotEmpty) {
      s = pr.removeMarks(s); // Remove punctuation and morphology marks
    }
    
    final n = s.length;

    if (n < 2 || n > 6) {
      s1 = " إدخال خاطئ!: $n"; // Invalid input: length
    } else if (n == 2) {
      s1 = s.startsWith("آ") ? s : " إدخال خاطئ!: $n";
    } else if (n == 3) {
      s1 = s.startsWith("آ") ? s.replaceFirst("آ", "أ") : s;
    } else if (n == 4) {
      if (s.startsWith("أ")) {
        s1 = s[2] == 'ّ' ? s.substring(0, 2) + s.substring(3) : s.substring(1);
      } else if (s[1] == 'ا') {
        s1 = s.substring(0, 1) + s.substring(2);
      } else if (s[1] == 'آ') {
        s1 = "أ" + s.substring(2);
      } else if (s[2] == 'ّ') {
        s1 = s.substring(0, 2) + s.substring(3);
      } else {
        s1 = s;
      }
    } else if (n == 5) {
      if (s.startsWith("ت")) {
        if (s[3] == 'ّ') {
          s1 = s.substring(1, 3) + s.substring(4);
        } else if (s[2] == 'ا') {
          s1 = s.substring(1, 2) + s.substring(3, 5);
        } else {
          s1 = s.substring(1);
        }
      } else if (s.startsWith("ا")) {
        if (s[2] == 'ّ') {
          if (s[1] == 'د' && s[3] == 'ك') {
            s = s.replaceFirst('د', 'ذ');
          }
          s1 = s.substring(1, 2) + s.substring(3);
        } else if (s[2] == 'ت' && s[1] == 'ن') {
          s1 = '${s.substring(1, 2)}${s.substring(3)}/ ${s.substring(2)}';
        } else if (s[2] == 'ت') {
          s1 = s.substring(1, 2) + s.substring(3);
        } else if (s[2] == 'د' && s[1] != 'ن') {
          s1 = s.substring(1, 2) + s.substring(3);
        } else if (s[2] == 'ط' && s[1] != 'ن') {
          s1 = s.substring(1, 2) + s.substring(3);
        } else if (s[1] == 'ن') {
          s1 = s.substring(2, 5);
        } else if (s.endsWith('ّ')) {
          s1 = s.substring(1, 4);
        }
      }
    } else if (n == 6) {
      if (s.startsWith("ا")) {
        if (s.startsWith("ست", 1)) {
          s1 = s.substring(3, 6);
        } else if (s[2] == 'ّ' && s[4] == 'ّ') {
          s1 = '${s.substring(1, 2)}${s.substring(3, 4)}${s.substring(5)}';
        } else if (s[2] == 'ّ' && s[3] == 'ا') {
          s1 = s.substring(1, 2) + s.substring(4);
        } else if (s[2] == s[4] && s[3] == 'و') {
          s1 = s.substring(1, 2) + s.substring(4);
        } else if (s[n-3] == 'ا' && s.endsWith('ّ')) {
          s1 = s.substring(1, 3) + s.substring(4, 5);
        } else if (s[n-3] == 'أ' && s.endsWith('ّ')) {
          s1 = s.substring(1, 5);
        } else if (s[n-3] == 'ن') {
          s1 = s.substring(1, 3) + s.substring(4);
        } else {
          s1 = s;
        }
      } else {
        s1 = s;
      }
    }

    s1 = pr.postRoot(s1, n); // Post-processing
    return s1;
  }
}