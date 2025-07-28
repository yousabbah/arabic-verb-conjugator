import 'package:arabic_verb_final/core/conjugation/pre_post_processing.dart';
class ActPart {
  String activeParticiple(String s) {
    final pr = PrePostProcessing();
    
    if (s.isNotEmpty) {
      s = pr.removeMarks(s); // Remove punctuation and morphology marks
    }

    final i = s.length;

    if (i < 2 || i > 6) {
      s = " إدخال خاطئ!: $i"; // Less than minimum or more than maximum length
    } else {
      s = pr.preAct(s, i); // Pre-process the verb
    }

    if (i == 2) {
      if (s.startsWith("آ")) {
        // آل: آيِل
        s = "${s[0]}يِ${s[1]}";
      } else {
        s = " إدخال خاطئ!: $i"; // Incorrect verb length
      }
    } 
    else if (i == 3) {
      if (s[i - 2] == 'ا' || s[i - 2] == 'أ') {
        if (!s.endsWith("ئ")) {
          // If the penultimate character is ا or أ, and last character isn't ئ
          s = s.replaceRange(i - 2, i - 1, 'ئ');
          s = "${s[0]}ا${s[1]}ِ${s[2]}"; // سال، سأل:سائل
        } else {
          s = "$sِي"; // ساء:سائِي،ساءٍ
        }
      } 
      else if (s.startsWith("أ")) {
        if (s.endsWith("ي")) {
          if (s[1] != 'ر') {
            s = "آ${s[1]}ِ${s[2]}"; // أتى:آتي،آتٍ
          } else {
            s = "مُ${s[1]}ِ${s[2]}"; // أرى:مُري،مُرٍ
          }
        } 
        else if (s.endsWith("ّ")) {
          s = "آ${s.substring(1, 3)}"; // أمّ:آمّ
        } 
        else if (s[i - 2] == 'آ') {
          s = "مُئِي${s[2]}"; // أآن:مُئين (from quadrilateral root)
        } 
        else {
          s = "آ${s[1]}ِ${s[2]}"; // أمِن:آمِن
        }
      } 
      else if (s.endsWith("ّ") && !s.startsWith("آ")) {
        s = s[1] == 'ي' 
            ? "${s[0]}يِ${s.substring(1, 3)}" // عيّ:عيِيّ
            : "${s[0]}ا${s.substring(1, 3)}"; // ردّ:رادّ
      } 
      else if (s.endsWith("ي") && !s.startsWith("آ")) {
        s = s[1] == 'ي'
            ? "${s.substring(0, 2)}ِ${s[2]}ّ" // عيِيَ:عيِيّ
            : "${s[0]}ا${s[1]}ِ${s[2]}"; // Other verbs follow the standard pattern
      } 
      else if (s.startsWith("آ")) {
        if (s.endsWith("ّ")) {
          s = "مُؤا${s.substring(1, 3)}/ مُئِ${s.substring(1, 3)}"; // آمّ:مؤامّ،مئمّ
        } else {
          s = "مُؤا${s[1]}ِ${s[2]}/ مُؤ${s[1]}ِ${s[2]}"; // آمن:مؤامن،مؤمن
        }
      } 
      else {
        // خسئ،جرؤ،بدأ:خاسئ،جارئ، بادئ and other trilateral verbs
        s = "${s[0]}ا${s[1]}ِ${s[2]}";
      }
    } 
    else if (i == 4) {
      if (s.startsWith("أ")) {
        if (s[i - 2] == 'ّ') {
          s = "مُؤَ${s.substring(1, 3)}ِ${s[3]}"; // أثّر،أتّى:مؤثِّر،مؤتِّي/مؤَتٍّ
        } 
        else if (s.endsWith("ّ")) {
          s = "مُ${s[1]}ِ${s.substring(2, 4)}"; // أصرّ
        } 
        else if (s[i - 2] == 'ا') {
          s = "مُ${s[1]}ي${s[3]}"; // أقام:مُقيم
        } 
        else if (s[i - 2] == 'ئ') {
          s = "مُ${s.substring(1, 3)}ِ${s[3]}"; // أسأل:مُسئِل
        } 
        else if (s[i - 3] == 'ي') {
          s = "مُو${s[2]}ِ${s[3]}"; // أوصى:موصي، موصٍ،أيقن،موقن
        } 
        else {
          s = "مُ${s.substring(1, 3)}ِ${s[3]}"; // أقبل:مُقبِل،أجبر
        }
      } 
      else if ((s[i - 3] == 'ا' || s[i - 3] == 'آ') && s.endsWith("ّ")) {
        s = "مُ$s"; // تآنّ:originally pentagonal, and وادّ
      } 
      else if (s.startsWith("ا")) {
        if (s[1] == 'ن') {
          s = "مُ${s.substring(1, 4)}"; // Originally pentagonal: انآس،انآل:مُنآس،مُنآل
        }
      } 
      else if (s[2] == 'ء') {
        s = "مُ${s.substring(0, i - 2)}ئِ${s.substring(i - 1)}"; // ساءل:مسائل
      } 
      else if (s[1] == 'أ' && s[2] == 'ّ') {
        s = "مُ${s.substring(0, i - 3)}ئِّ${s.substring(i - 1)}"; // رأّى:مرئِّي،مرئٍّ، سأّل:مسئّل
      } 
      else {
        s = "مُ${s.substring(0, i - 1)}ِ${s.substring(i - 1)}";
      }
    } 
    else if (i == 5) {
      if (s[i - 3] == 'ا' && s.endsWith("ّ")) {
        s = "مُ$s"; // توادّ
      } 
      else if (s.startsWith("ا")) {
        if (s.endsWith("ّ") && s[1] != 'ئ') {
          s = "مُ${s.substring(1, i - 2)}َ${s.substring(i - 2)}"; // انحلّ، احتلّ، احمرّ، ازورّ
        } 
        else if (s[i - 2] == 'ا' && s[1] != 'ئ') {
          s = "مُ${s.substring(1)}"; // احتال، انحاز
        } 
        else if (s[1] == 'ئ') {
          if (s.endsWith("ّ") || s[i - 2] == 'ا') {
            s = "مُؤ${s.substring(2)}"; // ائتنّ،ائتال
          } else {
            s = "مُؤ${s.substring(2, i - 1)}ِ${s.substring(i - 1)}"; // ائتمر
          }
        } 
        else if (s.endsWith("ي")) {
          s = "مُ${s.substring(1, i - 1)}ِ${s.substring(i - 1)}"; // التقى:ملتقي،ملتقٍ، التأم:ملتئم
        } 
        else if (s[i - 2] == 'آ') {
          s = "مُ${s.substring(1, i - 2)}ئي${s.substring(i - 1)}"; // (originally hexagonal)استآل:مستئيل
        } 
        else {
          s = "مُ${s.substring(1, i - 1)}ِ${s.substring(i - 1)}"; // انفعل، افتعل
        }
      } 
      else if (s[3] == 'ء') {
        s = "مُ${s.substring(0, i - 2)}ئِ${s.substring(i - 1)}"; // تساءل:متسائل
      } 
      else if (s[2] == 'أ' && s[3] == 'ّ') {
        s = "مُ${s.substring(0, i - 3)}ئِّ${s.substring(i - 1)}"; // ترأّى:مترئِّي،مرئٍّ، تسأّل:متسئّل
      } 
      else {
        s = "مُ${s.substring(0, i - 1)}ِ${s.substring(i - 1)}"; // تفاعل، تفعّل
      }
    } 
    else if (i == 6) {
      if (s[i - 2] == 'ا') {
        s = "مُ${s.substring(1, i - 2)}ي${s.substring(i - 1)}"; // استفاد:مستفيد
      } 
      else if (s.endsWith("ّ")) {
        if (s[i - 3] == 'أ') {
          s = "مُ${s.substring(1, i - 3)}ئِ${s.substring(i - 2)}"; // استأمّ،مُستئِمّ
        } 
        else if (s[i - 3] == 'ا') {
          s = "مُ${s.substring(1)}"; // احوالّ:مُحوالّ
        } 
        else {
          s = "مُ${s.substring(1, i - 2)}ِ${s.substring(i - 2)}"; // استقرّ
        }
      } 
      else {
        s = "مُ${s.substring(1, i - 1)}ِ${s.substring(i - 1)}"; // اعشوشب،استقبل
        if (s[2] == 'ئ') {
          s = s.replaceRange(2, 3, 'ؤ'); // ائنَوْنَن from the verb أنّ
        }
        if (s.endsWith("ى")) {
          s = "${s.replaceRange(i - 1, i, 'ي')}/ ${s.replaceRange(i - 1, i, 'ٍ')}"; // استلقى:مستلقي،مستلقٍ
        }
        if (s[i - 1] == 'أ') {
          s = s.replaceRange(i - 1, i, 'ئ'); // استسأل:مستسئل
        }
      }
    }

    s = pr.postAct(s); // Post-processing
    return s;
  }
}