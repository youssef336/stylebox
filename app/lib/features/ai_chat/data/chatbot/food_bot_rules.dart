class FoodBotRule {
  const FoodBotRule({
    required this.keywords,
    required this.response,
    required this.responseAr,
  });

  final List<String> keywords;
  final String response;
  final String responseAr;

  bool matches(String textLower) {
    return keywords.any(
      (keyword) => textLower.contains(FoodBotRules._normalizeKeyword(keyword)),
    );
  }
}

/// Offline fallback for the StyleBox style assistant, used when the AI
/// server is unreachable. Matches Arabic and English keywords and replies in
/// the language of the question.
class FoodBotRules {
  static const String nonFoodReply =
      'I can help with StyleBox and fashion questions only (Style Boxes, reserving, pickup, sizes, payment, points, styling tips).';

  static const String nonFoodReplyAr =
      'أقدر أساعدك في أسئلة StyleBox والموضة بس (الستايل بوكس، الحجز، الاستلام، المقاسات، الدفع، النقاط، ونصايح التنسيق).';

  static const String fallbackReply =
      'Tell me what you need help with: how Style Boxes work, reserving, pickup, sizes, returns, payment, points & coupons, or styling tips.';

  static const String fallbackReplyAr =
      'قولّي محتاج مساعدة في إيه: الستايل بوكس بيشتغل إزاي، الحجز، الاستلام، المقاسات، الاسترجاع، الدفع، النقاط والكوبونات، أو نصايح التنسيق.';

  static const List<String> allowedKeywords = [
    'stylebox',
    'style',
    'box',
    'cloth',
    'fashion',
    'wardrobe',
    'outfit',
    'wear',
    'shirt',
    'jeans',
    'denim',
    'pants',
    'trousers',
    'dress',
    'skirt',
    'jacket',
    'coat',
    'hoodie',
    'sweater',
    'blouse',
    'shoe',
    'sneaker',
    'accessor',
    'size',
    'store',
    'shop',
    'boutique',
    'ستايل',
    'بوكس',
    'ملابس',
    'لبس',
    'هدوم',
    'موضة',
    'دولاب',
    'قميص',
    'تيشيرت',
    'بنطلون',
    'جينز',
    'فستان',
    'جيبة',
    'جاكيت',
    'جاكت',
    'هودي',
    'سويتر',
    'بلوزة',
    'جزمة',
    'كوتشي',
    'شنطة',
    'إكسسوار',
    'مقاس',
    'متجر',
    'محل',
  ];

  static const List<FoodBotRule> rules = [
    FoodBotRule(
      keywords: [
        'size',
        'sizing',
        'fit me',
        'fits me',
        ' small ',
        ' medium ',
        ' large ',
        ' xl ',
        ' xxl ',
        'مقاس',
        'سايز',
        'هيجي علي',
      ],
      response:
          'Each Style Box shows its category and sizes when the store provides them. If the sizes are "not specified", contact the store (Contact on the box page) before reserving. Boxes are surprises, so pieces and sizes can vary.',
      responseAr:
          'كل ستايل بوكس بيوضح الفئة والمقاسات لو المتجر حددها. لو المقاسات غير محددة، تواصل مع المتجر من صفحة البوكس قبل الحجز. البوكس مفاجأة، فالقطع والمقاسات ممكن تختلف.',
    ),
    FoodBotRule(
      keywords: [
        'return',
        'exchange',
        'refund',
        'swap',
        'cancel',
        'استرجاع',
        'إرجاع',
        'ترجيع',
        'ارجع',
        'استبدال',
        'تبديل',
        'أبدل',
        'استرداد',
        'إلغاء',
        'ألغي',
      ],
      response:
          'Returns, exchanges and cancellations depend on each store\'s policy, since Style Boxes are discounted surprise items. Check with the store using the Contact info on the box page, and check your pieces when you pick them up.',
      responseAr:
          'الاسترجاع والاستبدال والإلغاء بيعتمدوا على سياسة كل متجر، لأن الستايل بوكس قطع مخفضة ومفاجأة. اتأكد من المتجر عن طريق بيانات التواصل في صفحة البوكس، وافحص القطع وقت الاستلام.',
    ),
    FoodBotRule(
      keywords: [
        'pay',
        'cash',
        'visa',
        'credit',
        'checkout',
        'دفع',
        'ادفع',
        'فيزا',
        'كاش',
        'كارت',
        'بطاقة',
      ],
      response:
          'At checkout you can choose cash or pay with a Visa card saved on this device (only the last 4 digits are stored). All prices are in EGP.',
      responseAr:
          'في صفحة الدفع تقدر تختار الدفع كاش أو بكارت فيزا محفوظ على جهازك (بنحفظ آخر 4 أرقام بس). كل الأسعار بالجنيه المصري.',
    ),
    FoodBotRule(
      keywords: [
        'point',
        'coupon',
        'promo',
        'code',
        'reward',
        'loyalty',
        'نقاط',
        'نقط',
        'كوبون',
        'كود',
        'مكافأ',
        'برومو',
      ],
      response:
          'You collect points with your orders. Go to Profile > Points to see your rewards; once a discount is unlocked you get a coupon code to copy and use at checkout.',
      responseAr:
          'بتجمع نقاط مع طلباتك. ادخل على الملف الشخصي ثم النقاط علشان تشوف المكافآت، ولما يتفتح خصم هتاخد كود كوبون تنسخه وتستخدمه في صفحة الدفع.',
    ),
    FoodBotRule(
      keywords: [
        'pickup',
        'pick up',
        'collect',
        'location',
        'address',
        'استلام',
        'استلم',
        'ميعاد',
        'معاد',
        'موعد',
        'عنوان',
        'مكان',
      ],
      response:
          'Pick up your Style Box from the store during the pickup time shown on the box page (for example 4:00 PM - 11:00 PM). You will find the store location and contact on the same page.',
      responseAr:
          'استلم الستايل بوكس من المتجر في وقت الاستلام الموضح في صفحة البوكس (مثلاً من 4:00 م لـ 11:00 م). هتلاقي عنوان المتجر وبيانات التواصل في نفس الصفحة.',
    ),
    FoodBotRule(
      keywords: [
        'reserve',
        'reservation',
        'book',
        'order',
        'buy',
        'cart',
        'حجز',
        'احجز',
        'اطلب',
        'طلب',
        'اشتري',
        'شراء',
        'عربة',
        'سلة',
      ],
      response:
          'To reserve: open a store, choose an available Style Box, tap Reserve and complete checkout. Boxes are limited, so reserve early - each card shows how many boxes are left.',
      responseAr:
          'علشان تحجز: افتح المتجر، اختار ستايل بوكس متاح، اضغط احجز وكمّل الدفع. البوكسات عددها محدود، فاحجز بدري - كل كارت بيوضح عدد البوكسات المتبقية.',
    ),
    FoodBotRule(
      keywords: [
        'price',
        'cost',
        'how much',
        'cheap',
        'expensive',
        'سعر',
        'أسعار',
        'بكام',
        ' بكم ',
        ' تمن ',
        'التمن',
        'تمنه',
        'تمنها',
        'غالي',
        'رخيص',
      ],
      response:
          'Style Boxes are sold at a big discount on the pieces\' original value. Each box card shows the current price and the original price in EGP.',
      responseAr:
          'الستايل بوكس بيتباع بخصم كبير على السعر الأصلي للقطع. كل كارت بيوضح السعر الحالي والسعر الأصلي بالجنيه.',
    ),
    FoodBotRule(
      keywords: [
        'condition',
        'quality',
        'used',
        'tags',
        'damaged',
        'defect',
        'حالة',
        'جودة',
        'مستعمل',
        'تيكيت',
        'عيب',
      ],
      response:
          'Style Boxes contain surplus, overstock and end-of-season pieces - usually new with tags or like new. If an item is not as described, contact the store. You can also use Style Scan to check an item.',
      responseAr:
          'الستايل بوكس فيه قطع فائضة وستوك وآخر موسم - غالباً جديدة بالتيكيت أو شبه جديدة. لو في قطعة مش زي الوصف، تواصل مع المتجر. وتقدر كمان تستخدم فحص الستايل علشان تشوف القطعة.',
    ),
    FoodBotRule(
      keywords: [
        'inside',
        "what's in",
        'whats in',
        'what is in',
        'contain',
        'category',
        ' men ',
        "men's",
        ' mens ',
        'women',
        'kids',
        'unisex',
        'جوه',
        'فيه ايه',
        'محتوى',
        'فئة',
        'رجالي',
        'حريمي',
        'أطفال',
        'ولادي',
        'بناتي',
        'للجنسين',
      ],
      response:
          'Each Style Box is a surprise mix of about 3-5 pieces (tops, jeans, jackets, accessories...) picked by the store. The box page shows its category (Men, Women, Kids or Unisex) and the sizes when available.',
      responseAr:
          'كل ستايل بوكس فيه تشكيلة مفاجأة من حوالي 3 لـ 5 قطع (بلوزات، جينز، جواكت، إكسسوارات...) بيختارها المتجر. صفحة البوكس بتوضح الفئة (رجالي، حريمي، أطفال أو للجنسين) والمقاسات لو متاحة.',
    ),
    FoodBotRule(
      keywords: [
        'scan',
        'camera',
        'photo',
        'picture',
        'image',
        'فحص',
        'صورة',
        'أصور',
        'تصوير',
        'كاميرا',
        'سكان',
      ],
      response:
          'Use Style Scan: take or pick a photo of a clothing item (good lighting, simple background, no blur) and the app will identify it and suggest how to style it.',
      responseAr:
          'استخدم فحص الستايل: صوّر أو اختار صورة لقطعة لبس (إضاءة كويسة، خلفية بسيطة، بدون تشويش) والتطبيق هيتعرف عليها ويقترح عليك تنسقها إزاي.',
    ),
    FoodBotRule(
      keywords: [
        'store',
        'shop',
        'boutique',
        'branch',
        'near',
        'متجر',
        'متاجر',
        'محل',
        'فرع',
        'فروع',
        ' قريب ',
        'قريب مني',
        'أقرب',
      ],
      response:
          'Browse stores from Home and Products to see their available Style Boxes, branches and distance. Each store sets its own box contents, sizes, price and pickup time.',
      responseAr:
          'تصفح المتاجر من الرئيسية والمنتجات علشان تشوف البوكسات المتاحة والفروع والمسافة. كل متجر بيحدد محتوى البوكس والمقاسات والسعر ووقت الاستلام بتاعه.',
    ),
    FoodBotRule(
      keywords: [
        'how does it work',
        'how it works',
        'how does stylebox',
        'what is stylebox',
        'stylebox',
        'style box',
        'surprise',
        'mystery',
        'surplus',
        'overstock',
        'season',
        'about the app',
        'ستايل بوكس',
        'بوكس',
        'صندوق',
        'مفاجأ',
        'فائض',
        'ستوك',
        'موسم',
        'بيشتغل ازاي',
        'ازاي بيشتغل',
        'فكرة التطبيق',
        'يعني ايه',
      ],
      response:
          'StyleBox connects you with clothing stores that sell surplus, overstock and end-of-season clothes in discounted surprise Style Boxes. Browse stores, reserve a box in the app, then pick it up from the store at the pickup time - great value, and it gives clothes a second life.',
      responseAr:
          'StyleBox بيوصلك بمحلات ملابس بتبيع القطع الفائضة والستوك وآخر الموسم في ستايل بوكس مفاجأة بخصم كبير. تصفح المتاجر، احجز البوكس من التطبيق، واستلمه من المتجر في وقت الاستلام - توفير أكتر وفرصة تانية للملابس بدل ما تتهدر.',
    ),
    FoodBotRule(
      keywords: [
        'style',
        'outfit',
        'match',
        'wear',
        'color',
        'colour',
        'look',
        'combine',
        'occasion',
        'تنسيق',
        'نسق',
        'ألبس',
        'ستايل',
        'لون',
        'ألوان',
        'لوك',
        'اوتفيت',
        'خروجة',
        'مناسبة',
        'موضة',
      ],
      response:
          'Styling tips: build the look around one statement piece and keep the rest simple. Denim goes with almost everything, and neutral colors (white, black, beige, navy) are easy to mix. Finish the outfit with one accessory.',
      responseAr:
          'نصايح تنسيق: ابني اللوك حوالين قطعة واحدة مميزة وخلي الباقي بسيط. الجينز بيمشي مع كل حاجة تقريباً، والألوان المحايدة (أبيض، أسود، بيج، كحلي) سهل تنسقها مع بعض. وكمّل اللوك بإكسسوار واحد.',
    ),
    FoodBotRule(
      keywords: ['thank', 'thx', 'شكرا', 'متشكر', 'تسلم', 'ميرسي'],
      response: 'You\'re welcome! Happy styling.',
      responseAr: 'العفو! استمتع بالستايل الجديد.',
    ),
    FoodBotRule(
      keywords: [
        ' hi ',
        'hello',
        ' hey ',
        'good morning',
        'good evening',
        'مرحبا',
        'أهلا',
        'السلام',
        ' هاي ',
        'ازيك',
        'صباح الخير',
        'مساء الخير',
      ],
      response:
          'Hi! I\'m your StyleBox style assistant. Ask me how Style Boxes work, reserving and pickup, sizes, payment, points and coupons, or for styling tips.',
      responseAr:
          'أهلاً! أنا مساعد الستايل في StyleBox. اسألني عن الستايل بوكس بيشتغل إزاي، الحجز والاستلام، المقاسات، الدفع، النقاط والكوبونات، أو نصايح التنسيق.',
    ),
  ];

  static final RegExp _arabicPattern = RegExp(r'[؀-ۿ]');
  static final RegExp _arabicMarksPattern = RegExp(r'[ً-ْـ]');
  static final RegExp _alefPattern = RegExp('[أإآ]');
  static final RegExp _separatorPattern = RegExp(
    r"[^\p{L}\p{N}']+",
    unicode: true,
  );

  /// Lowercases and unifies Arabic letter variants (hamza on alef, taa
  /// marbuta, alef maqsura, diacritics) so keywords match common spellings.
  static String _normalizeKeyword(String text) {
    return text
        .toLowerCase()
        .replaceAll('’', "'")
        .replaceAll(_arabicMarksPattern, '')
        .replaceAll(_alefPattern, 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه');
  }

  /// Normalizes the user's message and pads it with spaces so keywords
  /// written with surrounding spaces (e.g. ' hi ') match whole words only.
  static String _normalizeText(String text) {
    final normalized = _normalizeKeyword(
      text,
    ).replaceAll(_separatorPattern, ' ').trim();
    return ' $normalized ';
  }

  static bool isFoodQuestion(String text) {
    final t = _normalizeText(text);
    return allowedKeywords.any((k) => t.contains(_normalizeKeyword(k))) ||
        rules.any((rule) => rule.matches(t));
  }

  static String reply(String text) {
    final t = _normalizeText(text);
    final isArabic = _arabicPattern.hasMatch(text);

    if (!isFoodQuestion(t)) {
      return isArabic ? nonFoodReplyAr : nonFoodReply;
    }

    for (final rule in rules) {
      if (rule.matches(t)) return isArabic ? rule.responseAr : rule.response;
    }

    return isArabic ? fallbackReplyAr : fallbackReply;
  }
}
