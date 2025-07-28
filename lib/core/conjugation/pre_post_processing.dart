class PrePostProcessing {
  PrePostProcessing();
  
  String removeMarks(String verb) {
    // Pre-processing the root by removing spaces, punctuation, and diacritics
    List<String> marks = ["؟", "َ", "ُ", "ِ", "ْ", "،", ".", "!", ":", " ", "ٌ", "ٍ", "ً"];
    if (verb.isNotEmpty) {
      for (String mark in marks) {
        verb = verb.replaceAll(mark, "");
      }
    }
    return verb;
  }

  String postRoot(String verb, int l) {
    // Post-processing the root by correcting spelling resulting from structural changes
    if (verb.length >= 3) {
      if (verb[1] == verb[2]) {
        // ردّد:ردد->ردّ
        verb = verb.substring(0, 2) + "ّ";
      }
    }
    if (verb.startsWith("ئ")) {
      // ائتمن:ئمن->أمن
      verb = verb.replaceFirst("ئ", "أ");
    }
    if (l > 3 && verb.length == 3) {
      // Doesn't include what enters as three-letter or what was its root is four-letter
      if (verb.endsWith("أ")) {
        // ابتدأ:بدأ،اجترأ:جرؤ،أظمأ:ظمئ
        verb = verb + "/ " + verb.substring(0, 2) + "ؤ" + "/ " + verb.substring(0, 2) + "ئ";
      }
      if (verb.endsWith("ى")) {
        if (verb[1] != 'أ') {
          if (verb[1] == 'ء') {
            // رءى من تراءى:رأى
            verb = verb.replaceFirst("ء", "أ");
          } else if (verb[1] == 'و') {
            // ارتوى:روى،روي
            verb = verb + "/ " + verb.substring(0, 2) + "ي";
          } else if (!verb.startsWith("ت")) {
            // استثناء التاء المنقلبة .تخذ.
            // التقى:لقي،ارتمى:رمى،أدنى:دنا
            verb = verb + "/ " + verb.substring(0, 2) + "ا" + "/ " + verb.substring(0, 2) + "ي";
          }
        }
      } else if (verb[1] == 'و' || verb[1] == 'ي') {
        // قوَل أو قيَد:قال،قوَل،قاد،قيَد
        verb = verb.substring(0, 1) + "a" + verb.substring(2) + "/ " + verb;
      }
      if (verb.startsWith("ت")) {
        // تصل:وصل،تبع:تبع،تخذ:أخذ
        if (verb.endsWith("ى")) {
          verb = "و" +
              verb.substring(1) +
              "/ " +
              "أ" +
              verb.substring(1) +
              "/ " +
              verb +
              " | " + // وقى، تقى،أقى
              "و" +
              verb.substring(1, 2) +
              "ا" +
              "/ " +
              "أ" +
              verb.substring(1, 2) +
              "a" +
              "/ " +
              verb.substring(0, 2) +
              "a" +
              " | " + // وقا، تقا،أقا
              "و" +
              verb.substring(1, 2) +
              "ي" +
              "/ " +
              "أ" +
              verb.substring(1, 2) +
              "ي" +
              "/ " +
              verb.substring(0, 2) +
              "ي"; // وقي، تقي،أقي
        } else {
          verb = "و" + verb.substring(1) + "/ " + "أ" + verb.substring(1) + "/ " + verb;
        }
      }
    }
    return verb;
  }

  String preAct(String s, int i) {
    // Pre-processing by removing spaces, punctuation, and diacritics
    if (s.endsWith("ى") || s.endsWith("ا") || s.endsWith("و")) {
      s = s.replaceRange(i - 1, i, "ي"); // If the last character is ى،ا،و replace with ي
    }
    if (s.endsWith("أ") || s.endsWith("ؤ") || s.endsWith("ء")) {
      s = s.substring(0, i - 1) + "ئ"; // If the last character is أ،ؤ،ء replace with ئ
    }
    if (s[i - 2] == 'أ' || s[i - 2] == 'ؤ') {
      s = s.substring(0, i - 2) + "ئ" + s.substring(i - 1, i); // If the character before last is أ، replace with ئ
    }
    return s;
  }

  String postAct(String s) {
    // Post-processing for active participle by correcting spelling resulting from structural changes
    if (s.endsWith("ي")) {
      if (s[s.length - 3] == 'ئ') {
        // Any active participle ending with ياء is replaced with kasra tanween:ئ before ي
        s = s + "/ " + s.substring(0, s.length - 3) + "ءٍ"; // رأى،جاء:رائي،راءٍ،جائي،جاءٍ
      } else if (s.startsWith("مُؤا")) {
        // Any active participle ending with ياء is replaced with kasra tanween:no ئ before ي
        s = s + "/ " + s.replaceAll("ي", "ٍ"); // آوى:مؤاوي،مؤاوٍ، مؤوي،مؤوٍ
      } else {
        // رمى،دنا،روي،نهى:رامي،رامٍ،داني،دانٍ،راوي،راوٍ،ناهي،ناهٍ
        s = s + "/ " + s.substring(0, s.length - 2) + "ٍ";
      }
    }
    return s;
  }

  String preOnce(String s) {
    if (s.endsWith("ى")) {
      // حمى:حَمية
      s = s.substring(0, 2) + "ي";
    }
    if (s.endsWith("ا")) {
      // دعا:دَعوة
      s = s.substring(0, 2) + "و";
    }
    if (s.endsWith("ؤ") || s.endsWith("ئ")) {
      // جرؤ،خسئ:جَرأة،خَسأة
      s = s.substring(0, 2) + "أ";
    }
    if (s[1] == 'ا') {
      if (s.endsWith("ء")) {
        // جاء،هاء:جَيئة،هَيئة
        s = s.replaceRange(1, 2, "ي");
        s = s.substring(0, 2) + "ئ";
      } else {
        // صال:صَولة
        s = s.replaceRange(1, 2, "و");
      }
    }
    return s;
  }

  String postOnce(String s) {
    if (s[2] == 'و') {
      if (s[3] == 'ي') {
        // نوى:نَوية،نَيّة
        s = s + "/ " + s.substring(0, 2) + "يّ" + s.substring(4);
      } else {
        // صال:صَولة،مال:مَيلة
        s = s + "/ " + s.substring(0, 2) + "ي" + s.substring(3);
      }
    }
    return s;
  }

  String preState(String s) {
    if (s.startsWith("أ")) {
      // أكل:إِكلة
      s = s.replaceRange(0, 1, "إ");
    }
    if (s[1] == 'ا' || s[1] == 'و') {
      // سال:سِيلة،سول:سِيلة
      s = s.replaceRange(1, 2, "ي");
    }
    if (s[1] == 'أ') {
      // سأل:سِئلة
      s = s.replaceRange(1, 2, "ئ");
    }
    if (s.endsWith("ى")) {
      // حمى:حِمية
      s = s.substring(0, 2) + "ي";
    }
    if (s.endsWith("ا")) {
      // دعا:دِعوة
      s = s.substring(0, 2) + "و";
    }
    if (s.endsWith("ؤ") || s.endsWith("ئ")) {
      // جرؤ،خسئ:جِرأة،خِسأة
      s = s.substring(0, 2) + "أ";
    }
    if (s.endsWith("ء")) {
      // جاء:جِيئة
      s = s.substring(0, 2) + "ئ";
    }
    if (s[1] == s[2]) {
      // نوى:نِيِّة
      s = s.substring(0, 2) + "ّ";
    }
    return s;
  }
}