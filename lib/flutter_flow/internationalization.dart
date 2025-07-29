import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['zh_Hans', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? zh_HansText = '',
    String? enText = '',
  }) =>
      [zh_HansText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // AdminDashboard
  {
    '3qdzok6f': {
      'zh_Hans': 'Admin Dashboard',
      'en': 'Admin Dashboard',
    },
    'omqirzhm': {
      'zh_Hans': '1214',
      'en': '1214',
    },
    '2deva6hz': {
      'zh_Hans': 'Active Users',
      'en': 'Active Users',
    },
    'vwsd282b': {
      'zh_Hans': '2000',
      'en': '2000',
    },
    'zwczaws4': {
      'zh_Hans': 'Active Vendors',
      'en': 'Active Vendors',
    },
    'pectxchd': {
      'zh_Hans': 'Quick Actions',
      'en': 'Quick Actions',
    },
    'rd5vfxnm': {
      'zh_Hans': 'Manage Accounts',
      'en': 'Manage Accounts',
    },
    'm7qdayui': {
      'zh_Hans': 'Moderate Contents',
      'en': 'Moderate Contents',
    },
    'odjggdup': {
      'zh_Hans': 'Tune Suggestions',
      'en': 'Tune Suggestions',
    },
    '3m9lh9cz': {
      'zh_Hans': 'Reports & Insights',
      'en': 'Reports & Insights',
    },
    'kuspfn4p': {
      'zh_Hans': 'Recent Activity',
      'en': 'Recent Activity',
    },
    'r84r7dd0': {
      'zh_Hans': 'New item uploaded by User #123',
      'en': 'New item uploaded by User #123',
    },
    'ezfmqmhw': {
      'zh_Hans': '2 minutes ago',
      'en': '2 minutes ago',
    },
    '080bxwqk': {
      'zh_Hans': 'New item uploaded by User #123',
      'en': 'New item uploaded by User #123',
    },
    'zesjss5w': {
      'zh_Hans': '2 minutes ago',
      'en': '2 minutes ago',
    },
    '1xkv7vyr': {
      'zh_Hans': 'New item uploaded by User #123',
      'en': 'New item uploaded by User #123',
    },
    'x5vi9anh': {
      'zh_Hans': '2 minutes ago',
      'en': '2 minutes ago',
    },
    'w2g0g2i4': {
      'zh_Hans': 'New item uploaded by User #123',
      'en': 'New item uploaded by User #123',
    },
    'oqtmdkzg': {
      'zh_Hans': '2 minutes ago',
      'en': '2 minutes ago',
    },
    'e672oaec': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // VendorDashboard
  {
    'bmyk6uai': {
      'zh_Hans': 'Admin Dashboard',
      'en': '',
    },
    'rat39zhn': {
      'zh_Hans': 'Fashion Brand Name',
      'en': '',
    },
    'v6mkehgt': {
      'zh_Hans': 'Welcome to your dashboard',
      'en': '',
    },
    '117xolf0': {
      'zh_Hans': 'Quick Actions',
      'en': '',
    },
    'wku26ku8': {
      'zh_Hans': 'Virtual Try-On Setting',
      'en': '',
    },
    '2vh8qpif': {
      'zh_Hans': 'Generate Discount Codes',
      'en': '',
    },
    '3f7k9yr8': {
      'zh_Hans': 'Setting Buy Links',
      'en': '',
    },
    'u9cj6y8q': {
      'zh_Hans': 'Your Branded Products',
      'en': '',
    },
    'a5gpunvx': {
      'zh_Hans': '+ Add New Product',
      'en': '',
    },
    'f9i8ahkt': {
      'zh_Hans': 'Profile',
      'en': '',
    },
    'ox7iiivm': {
      'zh_Hans': 'Code',
      'en': '',
    },
    '9v4dj9ym': {
      'zh_Hans': 'Virtual',
      'en': '',
    },
    '2n3m97us': {
      'zh_Hans': 'Link',
      'en': '',
    },
    'clbgcl56': {
      'zh_Hans': 'Add',
      'en': '',
    },
    'zm8jicd4': {
      'zh_Hans': 'Home',
      'en': '',
    },
  },
  // UserProfile
  {
    'zwwzyv36': {
      'zh_Hans': 'User Profile',
      'en': 'User Profile',
    },
    'kzujog58': {
      'zh_Hans': 'Information',
      'en': 'Information',
    },
    'yy7glkn6': {
      'zh_Hans': 'Username:',
      'en': 'Username:',
    },
    'qkmkxzuj': {
      'zh_Hans': 'REX',
      'en': 'REX',
    },
    'ylpfyxj0': {
      'zh_Hans': 'Gender:',
      'en': 'Gender:',
    },
    '5f57qp0r': {
      'zh_Hans': 'Man',
      'en': 'Man',
    },
    'f825olxn': {
      'zh_Hans': 'Email:',
      'en': 'Email:',
    },
    'iuzwtrmj': {
      'zh_Hans': 'Rex@gmail.com',
      'en': 'Rex@gmail.com',
    },
    'ki7tg1yu': {
      'zh_Hans': 'Body View:',
      'en': 'Body View:',
    },
    'om941oto': {
      'zh_Hans': 'Upload',
      'en': 'Upload',
    },
    'eu6fuvgb': {
      'zh_Hans': 'Update Profile Details:',
      'en': 'Update Profile Details:',
    },
    'qbj7ohxv': {
      'zh_Hans': 'TextField',
      'en': 'TextField',
    },
    'p1qrzh2e': {
      'zh_Hans': 'Email Address',
      'en': 'Email Address',
    },
    'wj3f1imp': {
      'zh_Hans': '',
      'en': '',
    },
    'g3761ypm': {
      'zh_Hans': 'Password',
      'en': 'Password',
    },
    'ge9pbfs8': {
      'zh_Hans': 'Update',
      'en': '',
    },
    'hk89n3i3': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
    '6zqt65w8': {
      'zh_Hans': 'Wardrobe',
      'en': 'Wardrobe',
    },
    'lro74946': {
      'zh_Hans': 'Match',
      'en': 'Match',
    },
    'zb5cyhgc': {
      'zh_Hans': 'Shop',
      'en': 'Shop',
    },
    '3odu0pvd': {
      'zh_Hans': 'Calander',
      'en': 'Calendar',
    },
    '120dmwbn': {
      'zh_Hans': 'Profile',
      'en': 'Profile',
    },
    '4t90wynl': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // UploadBodyView
  {
    'qe0737ot': {
      'zh_Hans': 'Your Body View',
      'en': 'Your Body View',
    },
    'cs2lmymo': {
      'zh_Hans': 'Front',
      'en': '',
    },
    'mbdmag96': {
      'zh_Hans': 'Back',
      'en': 'Front',
    },
    'bz6944ea': {
      'zh_Hans': 'Upload',
      'en': 'Upload',
    },
    '7gfp5xrd': {
      'zh_Hans': 'Upload',
      'en': 'Upload',
    },
    'pbap9nym': {
      'zh_Hans': 'Upload Body View',
      'en': 'Upload Body View',
    },
    'zglkyapq': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // MyWardrode
  {
    'cc9n9pk0': {
      'zh_Hans': 'My Wardrode',
      'en': 'My Wardrode',
    },
    'xx8781di': {
      'zh_Hans': 'Your Virtual Wardrobe',
      'en': 'Your Virtual Wardrobe',
    },
    '0k6okwgq': {
      'zh_Hans': 'Add Item',
      'en': 'Add Item',
    },
    'h95v1vtg': {
      'zh_Hans': 'Sort by:',
      'en': 'Sort by:',
    },
    '7d4ufn4n': {
      'zh_Hans': 'Select',
      'en': 'Select',
    },
    'fz3fb6g2': {
      'zh_Hans': 'Search...',
      'en': 'Search...',
    },
    'cpq9du9v': {
      'zh_Hans': 'Tops',
      'en': 'Tops',
    },
    'eo25c4tp': {
      'zh_Hans': 'Buttoms',
      'en': 'Bottoms',
    },
    'ead0ezpk': {
      'zh_Hans': 'Skirts',
      'en': 'Skirts',
    },
    'wxdpmikr': {
      'zh_Hans': 'Shoes',
      'en': 'Shoes',
    },
    'xo4uesmp': {
      'zh_Hans': 'All Clothes',
      'en': 'All Clothes',
    },
    'yveetctd': {
      'zh_Hans': 'Match New Outfit',
      'en': 'Match New Outfit',
    },
    'l1ne2qaz': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
    'zg10biwv': {
      'zh_Hans': 'Wardrobe',
      'en': 'Wardrobe',
    },
    '53fiy14s': {
      'zh_Hans': 'Match',
      'en': 'Match',
    },
    'fe3q2shz': {
      'zh_Hans': 'Shop',
      'en': 'Shop',
    },
    'un7ew6mp': {
      'zh_Hans': 'Calander',
      'en': 'Calendar',
    },
    'dme19kzg': {
      'zh_Hans': 'Profile',
      'en': 'Profile',
    },
    '9arxitgu': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // AddNewItem
  {
    'ow3qma8g': {
      'zh_Hans': 'Add New Item',
      'en': 'Add New Item',
    },
    'cc859zez': {
      'zh_Hans': 'Upload from library',
      'en': 'Upload from library',
    },
    'vuv90gs2': {
      'zh_Hans': 'Item Name',
      'en': 'Item Name',
    },
    'e14u07za': {
      'zh_Hans': 'TextField',
      'en': 'TextField',
    },
    '2q3gtuqn': {
      'zh_Hans': 'Exp: Uniqlo basic tee',
      'en': 'Exp: Uniqlo basic tee',
    },
    'nirmg1m7': {
      'zh_Hans': 'Category',
      'en': 'Category',
    },
    '3oum1l5g': {
      'zh_Hans': 'TextField',
      'en': 'TextField',
    },
    'nr7uasfe': {
      'zh_Hans': 'XXX',
      'en': 'XXX',
    },
    'czrqfq2i': {
      'zh_Hans': 'Colour',
      'en': 'Colour',
    },
    'z50xfu04': {
      'zh_Hans': 'Select...',
      'en': 'Select...',
    },
    'p55qp45r': {
      'zh_Hans': 'Search...',
      'en': 'Search...',
    },
    '32t7j0ox': {
      'zh_Hans': 'Black',
      'en': 'Black',
    },
    'sb5a4mym': {
      'zh_Hans': 'Grey',
      'en': 'Grey',
    },
    'oq9hrk71': {
      'zh_Hans': 'White',
      'en': 'White',
    },
    'uqwch6z9': {
      'zh_Hans': 'Red',
      'en': 'Red',
    },
    'rljgfv19': {
      'zh_Hans': 'Orange',
      'en': 'Orange',
    },
    'pxt893ag': {
      'zh_Hans': 'Yellow',
      'en': 'Yellow',
    },
    '27budk5s': {
      'zh_Hans': 'Green',
      'en': 'Green',
    },
    'x0ecz6xg': {
      'zh_Hans': 'Blue',
      'en': 'Blue',
    },
    '2lxbi12e': {
      'zh_Hans': 'Indigo',
      'en': 'Indigo',
    },
    'bl5lnthq': {
      'zh_Hans': 'Violet',
      'en': 'Violet',
    },
    'ojtqxeu8': {
      'zh_Hans': 'Pink',
      'en': 'Pink',
    },
    '8f82kzvh': {
      'zh_Hans': 'Brown',
      'en': 'Brown',
    },
    'wm5lcswo': {
      'zh_Hans': 'Category',
      'en': 'Category',
    },
    'awsfuuvq': {
      'zh_Hans': 'Casual',
      'en': 'Casual',
    },
    '24lwqrct': {
      'zh_Hans': 'Formal',
      'en': 'Formal',
    },
    'l2gip9up': {
      'zh_Hans': 'Party',
      'en': 'Party',
    },
    'zjj4rmpz': {
      'zh_Hans': 'Save',
      'en': 'Save',
    },
    'ter5cnpd': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // AccountManagement
  {
    'lje39ygt': {
      'zh_Hans': 'User',
      'en': 'User',
    },
    'ykuz0p52': {
      'zh_Hans': 'Accounts',
      'en': 'Accounts',
    },
    'zpml24qc': {
      'zh_Hans': 'Search user here',
      'en': 'Search user here',
    },
    '5v79c0kn': {
      'zh_Hans': 'Abby',
      'en': 'Abby',
    },
    '95flk64i': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': 'Joined since 1/1/2024',
    },
    '7sqi7e8s': {
      'zh_Hans': 'Suspend',
      'en': 'Suspend',
    },
    '8u8xgpp9': {
      'zh_Hans': 'Alice',
      'en': 'Alice',
    },
    'gsan4iwo': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'nnbez7ip': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    '7jjzz6bf': {
      'zh_Hans': 'Benjamin',
      'en': '',
    },
    'i0xhluv4': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    '9ml3wxag': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'i10momu6': {
      'zh_Hans': 'Catherine',
      'en': '',
    },
    'sprak2dn': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'dlwr5kio': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'treq4e2e': {
      'zh_Hans': 'Derrick',
      'en': '',
    },
    'ix1lr12z': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'nz4jwmyd': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    '7fesfdv4': {
      'zh_Hans': 'Esther',
      'en': '',
    },
    '077q9gfj': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'vr9jarp5': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'khuplumb': {
      'zh_Hans': 'Gigi',
      'en': '',
    },
    'a80uyslo': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'gpe5mz8x': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'qt8za9ts': {
      'zh_Hans': 'Hayne',
      'en': '',
    },
    'w5114tcg': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'mn86c4aq': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'c66ekjfu': {
      'zh_Hans': 'Jestina',
      'en': '',
    },
    'n0lv7k57': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    '9b5wdr99': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    '4yvq011t': {
      'zh_Hans': 'Admin',
      'en': '',
    },
    'yuxikj23': {
      'zh_Hans': 'Application',
      'en': '',
    },
    'wlvyfl8a': {
      'zh_Hans': 'Admin #123',
      'en': '',
    },
    'uik52ehi': {
      'zh_Hans': '1/1/2025 10:00am',
      'en': '',
    },
    'ayv1hqq0': {
      'zh_Hans': 'Approve',
      'en': '',
    },
    '293x4v5p': {
      'zh_Hans': 'Decline',
      'en': '',
    },
    '6h6ypwt8': {
      'zh_Hans': 'Admin #456',
      'en': '',
    },
    'c6dcat4r': {
      'zh_Hans': '1/1/2025 10:00am',
      'en': '',
    },
    'brzuvzk2': {
      'zh_Hans': 'Approve',
      'en': '',
    },
    'bc74iehy': {
      'zh_Hans': 'Decline',
      'en': '',
    },
    'imkmi4fg': {
      'zh_Hans': 'Accounts',
      'en': '',
    },
    'y6kk42fl': {
      'zh_Hans': 'Search user here',
      'en': '',
    },
    'rx3nvea9': {
      'zh_Hans': 'Admin #001',
      'en': '',
    },
    'ehze79y5': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'guu9kfqs': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'cquxrq4u': {
      'zh_Hans': 'Admin #002',
      'en': '',
    },
    'avg9xxir': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'ygbyx121': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    's19sqlet': {
      'zh_Hans': 'Admin #003',
      'en': '',
    },
    '729gk9l4': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'uzyvzb3y': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'bokabnjs': {
      'zh_Hans': 'Admin #004',
      'en': '',
    },
    'ir9mt3a0': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'ul42fglt': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    '559ql3s2': {
      'zh_Hans': 'Vendor',
      'en': '',
    },
    'he4jcb94': {
      'zh_Hans': 'Application',
      'en': '',
    },
    'dfz84zkl': {
      'zh_Hans': 'H&M',
      'en': '',
    },
    'arizso25': {
      'zh_Hans': '1/1/2025 10:00am',
      'en': '',
    },
    'rokb7msg': {
      'zh_Hans': 'Approve',
      'en': '',
    },
    '8demc7fe': {
      'zh_Hans': 'Decline',
      'en': '',
    },
    '1lnmbchy': {
      'zh_Hans': 'Padini',
      'en': '',
    },
    'emh1qlob': {
      'zh_Hans': '1/1/2025 10:00am',
      'en': '',
    },
    '0xaptwmx': {
      'zh_Hans': 'Approve',
      'en': '',
    },
    '37sp9t1f': {
      'zh_Hans': 'Decline',
      'en': '',
    },
    'nlpaqit2': {
      'zh_Hans': 'Accounts',
      'en': '',
    },
    'jw27th2m': {
      'zh_Hans': 'Search user here',
      'en': '',
    },
    'opmfcmtf': {
      'zh_Hans': 'Brands Outlet',
      'en': '',
    },
    'gzz0wlw8': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'si9bz8cd': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'mxsm0f1b': {
      'zh_Hans': 'Cotton On',
      'en': '',
    },
    '4fwv8zt7': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'qq8yj5k4': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'gwa25vz9': {
      'zh_Hans': 'Zara',
      'en': '',
    },
    'pw0pkgxy': {
      'zh_Hans': 'Joined since 1/1/2024',
      'en': '',
    },
    'yrxtlfwz': {
      'zh_Hans': 'Suspend',
      'en': '',
    },
    'uh4cjov9': {
      'zh_Hans': 'Account Management',
      'en': '',
    },
    '0iup9ncb': {
      'zh_Hans': 'Accounts',
      'en': '',
    },
  },
  // ModerateContent
  {
    '4xfefwma': {
      'zh_Hans': 'Moderation Request',
      'en': '',
    },
    'kq0kxhzp': {
      'zh_Hans': 'Pending Reviews',
      'en': '',
    },
    'cjl5jpjn': {
      'zh_Hans': 'Inappropriate Content',
      'en': '',
    },
    '6xao5r9z': {
      'zh_Hans': 'Brand: Padini',
      'en': '',
    },
    'uscx5iwm': {
      'zh_Hans': 'Duplicate Listing',
      'en': '',
    },
    'ka67neqx': {
      'zh_Hans': 'Brand: Zara',
      'en': '',
    },
    'mofhj8rj': {
      'zh_Hans': 'Invalid Product',
      'en': '',
    },
    'gyd4oo3l': {
      'zh_Hans': 'Brand: H&M',
      'en': '',
    },
    'o5317htn': {
      'zh_Hans': 'Delete Item',
      'en': '',
    },
    'ufoohno2': {
      'zh_Hans': 'Decline Request',
      'en': '',
    },
    'vnqhtx12': {
      'zh_Hans': 'Content Moderation Panel',
      'en': '',
    },
    '8nx7t99c': {
      'zh_Hans': 'Contents',
      'en': '',
    },
  },
  // SmartSuggestions
  {
    'un3s6v21': {
      'zh_Hans': 'Smart Suggestion Settings',
      'en': '',
    },
    'xaw5szxi': {
      'zh_Hans': 'Fine tune the rules here!',
      'en': '',
    },
    'h48t29ci': {
      'zh_Hans': 'Style Weighting',
      'en': '',
    },
    'is3686yf': {
      'zh_Hans': 'Adjust the priority of style to suggest here',
      'en': '',
    },
    '8clhansy': {
      'zh_Hans': 'Minimalism',
      'en': '',
    },
    'yr2njmjb': {
      'zh_Hans': 'Select level',
      'en': '',
    },
    '5fyjpnnq': {
      'zh_Hans': 'Search...',
      'en': '',
    },
    'knd0ii2y': {
      'zh_Hans': 'High',
      'en': '',
    },
    'zfkghy4y': {
      'zh_Hans': 'Medium',
      'en': '',
    },
    '8yn1w2rj': {
      'zh_Hans': 'Low',
      'en': '',
    },
    'igzyzqxz': {
      'zh_Hans': 'Streetwear',
      'en': '',
    },
    'pa5uq1a1': {
      'zh_Hans': 'Select level',
      'en': '',
    },
    'zwu5rs6q': {
      'zh_Hans': 'Search...',
      'en': '',
    },
    'bcihz3hh': {
      'zh_Hans': 'High',
      'en': '',
    },
    'fg6klzic': {
      'zh_Hans': 'Medium',
      'en': '',
    },
    'mmru33ds': {
      'zh_Hans': 'Low',
      'en': '',
    },
    'bh9pz8o2': {
      'zh_Hans': 'Formal',
      'en': '',
    },
    'f08upd3v': {
      'zh_Hans': 'Select level',
      'en': '',
    },
    'ukzsd9ar': {
      'zh_Hans': 'Search...',
      'en': '',
    },
    'kc8i0zz7': {
      'zh_Hans': 'High',
      'en': '',
    },
    'qezx8fr4': {
      'zh_Hans': 'Medium',
      'en': '',
    },
    'u1nn5xot': {
      'zh_Hans': 'Low',
      'en': '',
    },
    'mlirp01v': {
      'zh_Hans': 'Seasonal Adjustments',
      'en': '',
    },
    'zarbns34': {
      'zh_Hans': 'Adjust the weather parameter of suggestion here',
      'en': '',
    },
    '43yztk3g': {
      'zh_Hans': 'When temperature',
      'en': '',
    },
    '9nrmlok4': {
      'zh_Hans': 'More / Less than',
      'en': '',
    },
    'ba7h5kwm': {
      'zh_Hans': 'Search...',
      'en': '',
    },
    'gzl4aqmk': {
      'zh_Hans': 'More than',
      'en': '',
    },
    '89t13o63': {
      'zh_Hans': 'Less than',
      'en': '',
    },
    'cd4fin3h': {
      'zh_Hans': 'Recommend',
      'en': '',
    },
    '53y0f75y': {
      'zh_Hans': 'Select temperature',
      'en': '',
    },
    'fzrcjq5s': {
      'zh_Hans': 'Search...',
      'en': '',
    },
    '2pmp3a9w': {
      'zh_Hans': '10°C',
      'en': '',
    },
    'r2y8z2pk': {
      'zh_Hans': '20°C',
      'en': '',
    },
    'w6vhkddn': {
      'zh_Hans': '30°C',
      'en': '',
    },
    '7r2pucqq': {
      'zh_Hans': '40°C',
      'en': '',
    },
    'qq6yr3u8': {
      'zh_Hans': 'Rain detected',
      'en': '',
    },
    'hf73l9fl': {
      'zh_Hans': 'The system will recommend rainy day outfit',
      'en': '',
    },
    'jj4xqtgw': {
      'zh_Hans': 'Brand Integration Frequency',
      'en': '',
    },
    'geyydghx': {
      'zh_Hans': 'Adjust values promote vendor items in user suggestions',
      'en': '',
    },
    'jqg4cfmy': {
      'zh_Hans':
          'Higher value will promote vendor items more\noften in user suggestions',
      'en': '',
    },
    '7caqoc99': {
      'zh_Hans': 'Suggestions',
      'en': '',
    },
  },
  // ReportsInsights
  {
    'txjxqwig': {
      'zh_Hans': 'Daily Users',
      'en': '',
    },
    'p3c2kxra': {
      'zh_Hans': 'Users Today',
      'en': '',
    },
    'lzgttw8u': {
      'zh_Hans': '1200',
      'en': '',
    },
    '9k3uunzk': {
      'zh_Hans': '+10%',
      'en': '',
    },
    'hssvl0kl': {
      'zh_Hans': 'Active Sessions',
      'en': '',
    },
    'xih2h3um': {
      'zh_Hans': '850',
      'en': '',
    },
    '8mc5w0iw': {
      'zh_Hans': '+5%',
      'en': '',
    },
    'kowkcjcv': {
      'zh_Hans': 'Daily User Growth',
      'en': '',
    },
    'kcy463p8': {
      'zh_Hans': 'Most Used Tag',
      'en': '',
    },
    'ofaguamr': {
      'zh_Hans': '#Korean',
      'en': '',
    },
    'rxm6r98o': {
      'zh_Hans': '300',
      'en': '',
    },
    'pux4cmof': {
      'zh_Hans': '#Minimalist',
      'en': '',
    },
    'q6rfp1lh': {
      'zh_Hans': '270',
      'en': '',
    },
    'ez90i3ob': {
      'zh_Hans': '#Japanese',
      'en': '',
    },
    '4u8wfvbx': {
      'zh_Hans': '150',
      'en': '',
    },
    'oxi1w6ae': {
      'zh_Hans': 'Promo Code Conversion',
      'en': '',
    },
    'f1a1jp4f': {
      'zh_Hans': 'Codes Applied',
      'en': '',
    },
    'h39os2ds': {
      'zh_Hans': '800',
      'en': '',
    },
    'p10k80u4': {
      'zh_Hans': '+15%',
      'en': '',
    },
    '3kvdiew8': {
      'zh_Hans': 'Conversion Rate',
      'en': '',
    },
    '64cmgw2q': {
      'zh_Hans': '20%',
      'en': '',
    },
    '7jxd1lbx': {
      'zh_Hans': '+2%',
      'en': '',
    },
    '6t68oj3o': {
      'zh_Hans': 'Promo Code Conversions Over Time',
      'en': '',
    },
    '87c6psir': {
      'zh_Hans': 'Download CSV',
      'en': '',
    },
    'gwox7mgs': {
      'zh_Hans': 'Print Report',
      'en': '',
    },
    'tg3hle71': {
      'zh_Hans': 'Export Summary',
      'en': '',
    },
    'buh52ydw': {
      'zh_Hans': 'Reports & Insights',
      'en': '',
    },
    'h1prxzlw': {
      'zh_Hans': 'Reports',
      'en': '',
    },
  },
  // OutfitMatch
  {
    '5dhiappa': {
      'zh_Hans': 'Virtual Try On',
      'en': 'Virtual Try On',
    },
    'g4u9xixw': {
      'zh_Hans': 'Name:',
      'en': 'Name:',
    },
    'lbkrfgsv': {
      'zh_Hans': 'Exp: Formal Look 1',
      'en': 'Exp: Formal Look 1',
    },
    'a3xnhq5c': {
      'zh_Hans': 'Body Image View',
      'en': 'Body Image View',
    },
    'mei3jpkb': {
      'zh_Hans': 'Current Outfit',
      'en': 'Current Outfit',
    },
    'ukv9i4qw': {
      'zh_Hans': 'Top',
      'en': 'Top',
    },
    'rwunccy8': {
      'zh_Hans': 'Add',
      'en': 'Add',
    },
    'hsdd5kux': {
      'zh_Hans': 'Bottom',
      'en': 'Bottom',
    },
    'jpps5g3t': {
      'zh_Hans': 'Add',
      'en': 'Add',
    },
    'b9bs4kez': {
      'zh_Hans': 'Shoes',
      'en': 'Shoes',
    },
    'i9rlpddc': {
      'zh_Hans': 'Add',
      'en': 'Add',
    },
    'mk70q9xz': {
      'zh_Hans': 'Save',
      'en': 'Save',
    },
    'gxiqwln6': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
    'v9tq8h9e': {
      'zh_Hans': 'Wardrobe',
      'en': 'Wardrobe',
    },
    's0c3e49b': {
      'zh_Hans': 'Match',
      'en': 'Match',
    },
    '957557to': {
      'zh_Hans': 'Shop',
      'en': 'Shop',
    },
    'rccz29xa': {
      'zh_Hans': 'Calander',
      'en': 'Calander',
    },
    '06sx6hcx': {
      'zh_Hans': 'Profile',
      'en': 'Profile',
    },
    'buuyitvb': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // LoginPage
  {
    'a3lp1r00': {
      'zh_Hans': 'Welcome Back',
      'en': 'Welcome Back',
    },
    'v5n4f0wb': {
      'zh_Hans': 'Let\'s get started by filling your details',
      'en': 'Let\'s get started by filling your details',
    },
    'c04owza0': {
      'zh_Hans': 'Email',
      'en': 'Email',
    },
    'c30wh58y': {
      'zh_Hans': 'Password',
      'en': 'Password',
    },
    'fkuuvpdn': {
      'zh_Hans': 'Sign In',
      'en': 'Sign In',
    },
    '005e5ab3': {
      'zh_Hans': 'Don\'t have an account? ',
      'en': 'Don\'t have an account?',
    },
    'q4cp642g': {
      'zh_Hans': 'Sign Up here',
      'en': 'Sign Up here',
    },
    '70133uxl': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // CreateAccount
  {
    'rixejr8h': {
      'zh_Hans': 'Create an account',
      'en': '',
    },
    'get556q8': {
      'zh_Hans': 'Select a role',
      'en': '',
    },
    '06k2gf4y': {
      'zh_Hans': 'User',
      'en': '',
    },
    '2ovd445v': {
      'zh_Hans': 'Vendor',
      'en': '',
    },
    'mfal0xbm': {
      'zh_Hans': 'Admin',
      'en': '',
    },
    '770nud54': {
      'zh_Hans': '',
      'en': '',
    },
    's9orzkmh': {
      'zh_Hans': 'Username',
      'en': '',
    },
    'g04jhy1a': {
      'zh_Hans': 'Phone number',
      'en': '',
    },
    'plk2mp0y': {
      'zh_Hans': 'Email',
      'en': '',
    },
    '57zv0fmm': {
      'zh_Hans': 'Password',
      'en': '',
    },
    'yvrnw8v7': {
      'zh_Hans': 'Confirm Password',
      'en': '',
    },
    'gm0twroz': {
      'zh_Hans': 'Gender',
      'en': '',
    },
    '4hl22f37': {
      'zh_Hans': 'Woman',
      'en': '',
    },
    'k4lpgjdx': {
      'zh_Hans': 'Man',
      'en': '',
    },
    '77s48p2n': {
      'zh_Hans': 'Others',
      'en': '',
    },
    'lwt2zgv4': {
      'zh_Hans': '',
      'en': '',
    },
    'ehphbgks': {
      'zh_Hans': 'Create',
      'en': '',
    },
    'xf40fqvr': {
      'zh_Hans': 'Already have an account? ',
      'en': '',
    },
    '4ubb9e4o': {
      'zh_Hans': 'Sign In here',
      'en': '',
    },
    'b8prik1w': {
      'zh_Hans': 'Home',
      'en': '',
    },
  },
  // BuyClothes
  {
    'w55wjj9s': {
      'zh_Hans': 'Trending Item',
      'en': 'Trending Item',
    },
    'hs58xf8k': {
      'zh_Hans': 'Basic tee',
      'en': 'Basic tee',
    },
    '9tihb0xl': {
      'zh_Hans': 'black, Oversized',
      'en': 'black, Oversized',
    },
    'h24sp7lh': {
      'zh_Hans': '\$11.00',
      'en': '\$11.00',
    },
    'z4bvdrc9': {
      'zh_Hans': 'Basic tee',
      'en': 'Basic tee',
    },
    '4e5yftz1': {
      'zh_Hans': 'black, Oversized',
      'en': 'black, Oversized',
    },
    'cgys3n0e': {
      'zh_Hans': '\$11.00',
      'en': '\$11.00',
    },
    'kct65ez9': {
      'zh_Hans': 'Basic tee',
      'en': 'Basic tee',
    },
    'b9gv3suz': {
      'zh_Hans': 'black, Oversized',
      'en': 'black, Oversized',
    },
    '9x9lhwld': {
      'zh_Hans': '\$11.00',
      'en': '\$11.00',
    },
    'suhbn0j2': {
      'zh_Hans': 'Basic tee',
      'en': 'Basic tee',
    },
    '5r1e69ik': {
      'zh_Hans': 'black, Oversized',
      'en': 'black, Oversized',
    },
    'yr195bd2': {
      'zh_Hans': '\$11.00',
      'en': '\$11.00',
    },
    'n3q30sf4': {
      'zh_Hans': 'Basic tee',
      'en': 'Basic tee',
    },
    'jamznb8a': {
      'zh_Hans': 'black, Oversized',
      'en': 'black, Oversized',
    },
    'vrdmqyuk': {
      'zh_Hans': '\$11.00',
      'en': '\$11.00',
    },
    'ub5liqsx': {
      'zh_Hans': 'Basic tee',
      'en': 'Basic tee',
    },
    '1nbds7up': {
      'zh_Hans': 'black, Oversized',
      'en': 'black, Oversized',
    },
    '52xd1l7n': {
      'zh_Hans': '\$11.00',
      'en': '\$11.00',
    },
    '6gy8wi1k': {
      'zh_Hans': 'Basic tee',
      'en': 'Basic tee',
    },
    '7coce3tk': {
      'zh_Hans': 'black, Oversized',
      'en': 'black, Oversized',
    },
    'f5axp05j': {
      'zh_Hans': '\$11.00',
      'en': '\$11.00',
    },
    'k2zguh04': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
    'ytjey4nz': {
      'zh_Hans': 'Wardrobe',
      'en': 'Wardrobe',
    },
    'sb84rzww': {
      'zh_Hans': 'Match',
      'en': 'Match',
    },
    'cgqaozjc': {
      'zh_Hans': 'Shop',
      'en': 'Shop',
    },
    'mweqp94u': {
      'zh_Hans': 'Calander',
      'en': 'Calander',
    },
    'yaat7jcy': {
      'zh_Hans': 'Profile',
      'en': 'Profile',
    },
    'hd7cqguf': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // HomePage
  {
    '5ppbgqhi': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
    'ljy2dica': {
      'zh_Hans': 'Welcome back,',
      'en': 'Welcome back,',
    },
    '7ylrldap': {
      'zh_Hans': 'hope you enjoy the virtual wardrobe.',
      'en': 'hope you enjoy the virtual wardrobe.',
    },
    'z7zma923': {
      'zh_Hans': 'Date',
      'en': 'Date',
    },
    'a3rgpvwx': {
      'zh_Hans': '18/6',
      'en': '18/6',
    },
    '7l2m0dmr': {
      'zh_Hans': 'Temperature',
      'en': 'Temperature',
    },
    'omhhl9gx': {
      'zh_Hans': '27',
      'en': '27',
    },
    '8nn2q56u': {
      'zh_Hans': 'Outfit Suggest',
      'en': 'Outfit Suggest',
    },
    '9rqy3n49': {
      'zh_Hans': 'Today is cold day, wear a warmer jacket',
      'en': 'Today is cold day, wear a warmer jacket',
    },
    'fca3pt0z': {
      'zh_Hans': 'Quick Action',
      'en': 'Quick Action',
    },
    '9aptqlfu': {
      'zh_Hans': 'Add Item',
      'en': 'Add Item',
    },
    'coav3yn9': {
      'zh_Hans': 'Match Outfit',
      'en': 'Match Outfit',
    },
    'hi7i3b2j': {
      'zh_Hans': 'Trending Items',
      'en': 'Trending Items',
    },
    '5tcd6ojt': {
      'zh_Hans': 'Basic tee',
      'en': 'Basic tee',
    },
    'p2v94voy': {
      'zh_Hans': 'A wonderfully delicious 2 patty melt that melts into your...',
      'en': 'A wonderfully delicious 2 patty melt that melts into your...',
    },
    'pzoni9ux': {
      'zh_Hans': 'Long pands',
      'en': 'Long pands',
    },
    '4wwcnrjk': {
      'zh_Hans': 'Learn how to brew a delicious pourover every morning.',
      'en': 'Learn how to brew a delicious pourover every morning.',
    },
    'syg4oh76': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
    '8pv8eu1d': {
      'zh_Hans': 'Wardrobe',
      'en': 'Wardrobe',
    },
    'p35nqmcv': {
      'zh_Hans': 'Match',
      'en': 'Match',
    },
    'egb8i29n': {
      'zh_Hans': 'Shop',
      'en': 'Shop',
    },
    'bzj3zlzq': {
      'zh_Hans': 'Calander',
      'en': 'Calander',
    },
    'zbeaamf9': {
      'zh_Hans': 'Profile',
      'en': 'Profile',
    },
    'wtb0bf9n': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // OutfitPlanner2
  {
    'f672pt78': {
      'zh_Hans': 'Month',
      'en': 'Month',
    },
    'yvs9q8r4': {
      'zh_Hans': 'Coming Outfit',
      'en': 'Coming Outfit',
    },
    'fws7opjh': {
      'zh_Hans': 'Casual Look 1',
      'en': 'Casual Look 1',
    },
    'ghshq8v3': {
      'zh_Hans': '21/7/2025',
      'en': '21/7/2025',
    },
    'w1frybzr': {
      'zh_Hans': 'Formal Look 1',
      'en': 'Formal Look 1',
    },
    'wsqwby5x': {
      'zh_Hans': '19/7/2025',
      'en': '19/7/2025',
    },
    'cn07med3': {
      'zh_Hans': 'Week',
      'en': 'Week',
    },
    'y1nw7258': {
      'zh_Hans': 'Coming outfit',
      'en': 'Coming outfit',
    },
    '2gkeuncv': {
      'zh_Hans': 'Doctors Check In',
      'en': 'Doctors Check In',
    },
    'wsszbsco': {
      'zh_Hans': '2:20pm',
      'en': '2:20pm',
    },
    'gtjrmgr9': {
      'zh_Hans': 'Wed, 03/08/2022',
      'en': 'Wed, 03/08/2022',
    },
    '8rkkp3im': {
      'zh_Hans': 'Doctors Check In',
      'en': 'Doctors Check In',
    },
    'wj0kzcrc': {
      'zh_Hans': '2:20pm',
      'en': '2:20pm',
    },
    'a6guz6gn': {
      'zh_Hans': 'Wed, 03/08/2022',
      'en': 'Wed, 03/08/2022',
    },
    'juu7t29n': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
    'j10f5yzy': {
      'zh_Hans': 'Wardrobe',
      'en': 'Wardrobe',
    },
    'rud9dgwq': {
      'zh_Hans': 'Match',
      'en': 'Match',
    },
    'addqz4ow': {
      'zh_Hans': 'Shop',
      'en': 'Shop',
    },
    '4sm6nxfd': {
      'zh_Hans': 'Calander',
      'en': 'Calander',
    },
    'lswy1ody': {
      'zh_Hans': 'Profile',
      'en': 'Profile',
    },
    'nb7yeaja': {
      'zh_Hans': 'Outfit Planner',
      'en': 'Outfit Planner',
    },
    '67hx1n15': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // OnboardingPage
  {
    'yyq0zs37': {
      'zh_Hans': 'Welcome to PakaiJe',
      'en': 'Welcome to PakaiJe',
    },
    '0u3a7jag': {
      'zh_Hans':
          'Pakaije helps you organize, match, and elevate your wardrobe—all in one app.',
      'en':
          'Pakaije helps you organize, match, and elevate your wardrobe—all in one app.',
    },
    '2ak7aw59': {
      'zh_Hans': 'Snap and Save Your Outfits',
      'en': 'Snap and Save Your Outfits',
    },
    '5yephrea': {
      'zh_Hans':
          'Easily upload your clothes and tag them by type, color, and brand.',
      'en':
          'Easily upload your clothes and tag them by type, color, and brand.',
    },
    'tf24is8o': {
      'zh_Hans': 'Create Perfect Outfits',
      'en': 'Create Perfect Outfits',
    },
    'ysjl0g50': {
      'zh_Hans':
          'Try different combinations and get suggestions based on your wardrobe.',
      'en':
          'Try different combinations and get suggestions based on your wardrobe.',
    },
    'rhwyc9ka': {
      'zh_Hans': 'Stay Stylish with Famous Brands',
      'en': 'Stay Stylish with Famous Brands',
    },
    '7pifj4yo': {
      'zh_Hans': 'Explore trending outfits from Uniqlo, Padini, Zara & more.',
      'en': 'Explore trending outfits from Uniqlo, Padini, Zara & more.',
    },
    'qvsmo5i3': {
      'zh_Hans': 'Sign In',
      'en': 'Sign In',
    },
    '9k0e1xqc': {
      'zh_Hans': 'Sign Up',
      'en': 'Sign Up',
    },
    'c8nhkdl0': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // RedirectPage
  {
    'e2pxdx14': {
      'zh_Hans': '50%',
      'en': '',
    },
    'iwft93pd': {
      'zh_Hans': 'Redirecting....',
      'en': '',
    },
    'svavlb3a': {
      'zh_Hans': 'Home',
      'en': '',
    },
  },
  // VirtualTryOnSetting
  {
    'l1irw7eq': {
      'zh_Hans': 'Virtual Try-On Setting',
      'en': '',
    },
    '4rcpwvxb': {
      'zh_Hans': 'Product Lists',
      'en': '',
    },
    'ij57il7x': {
      'zh_Hans': 'Product Name',
      'en': '',
    },
    'vf8y14fk': {
      'zh_Hans': 'Product Tags',
      'en': '',
    },
    'zckull2v': {
      'zh_Hans': 'Product Name',
      'en': '',
    },
    '6havdzbu': {
      'zh_Hans': 'Product Tags',
      'en': '',
    },
    '67atclb6': {
      'zh_Hans': 'Product Name',
      'en': '',
    },
    'zx0g3xbe': {
      'zh_Hans': 'Product Tags',
      'en': '',
    },
    'p3coiibg': {
      'zh_Hans': 'Product Name',
      'en': '',
    },
    'sid0gtkc': {
      'zh_Hans': 'Product Tags',
      'en': '',
    },
    'gm7403p0': {
      'zh_Hans': 'Profile',
      'en': '',
    },
    'zq6kx6x4': {
      'zh_Hans': 'Code',
      'en': '',
    },
    'w13stjta': {
      'zh_Hans': 'Virtual',
      'en': '',
    },
    'gmbq92yg': {
      'zh_Hans': 'Link',
      'en': '',
    },
    'o5zfriuv': {
      'zh_Hans': 'Add',
      'en': '',
    },
    'qzcdgb6w': {
      'zh_Hans': 'Home',
      'en': '',
    },
  },
  // AddProduct
  {
    'k3w9ry00': {
      'zh_Hans': 'Add Products',
      'en': '',
    },
    '0r8d0raw': {
      'zh_Hans': 'Item Name',
      'en': '',
    },
    'zm5egajg': {
      'zh_Hans': 'Category',
      'en': '',
    },
    'nssko5kl': {
      'zh_Hans': 'Color',
      'en': '',
    },
    '375rwf4t': {
      'zh_Hans': 'Black',
      'en': '',
    },
    't8doh37e': {
      'zh_Hans': 'Grey',
      'en': '',
    },
    'x6kl63tw': {
      'zh_Hans': 'White',
      'en': '',
    },
    'acccbms9': {
      'zh_Hans': 'Black',
      'en': '',
    },
    'ql6isws2': {
      'zh_Hans': 'Occasion Tags',
      'en': '',
    },
    '1awwtnay': {
      'zh_Hans': 'Casual',
      'en': '',
    },
    'ozxi91k5': {
      'zh_Hans': 'Formal',
      'en': '',
    },
    'z7abcmwq': {
      'zh_Hans': 'Party',
      'en': '',
    },
    'usg1yymt': {
      'zh_Hans': 'Casual',
      'en': '',
    },
    'u36bholv': {
      'zh_Hans': 'Create Product',
      'en': '',
    },
    'sej18ric': {
      'zh_Hans': 'Save',
      'en': '',
    },
    '8frq85ql': {
      'zh_Hans': 'Profile',
      'en': '',
    },
    '5trwn39z': {
      'zh_Hans': 'Code',
      'en': '',
    },
    'eeh7xl3c': {
      'zh_Hans': 'Virtual',
      'en': '',
    },
    'fdion0op': {
      'zh_Hans': 'Link',
      'en': '',
    },
    'pc3lg6jl': {
      'zh_Hans': 'Add',
      'en': '',
    },
    'oy0kayvu': {
      'zh_Hans': 'Home',
      'en': '',
    },
  },
  // ManageDiscountCodes
  {
    'xwlevjds': {
      'zh_Hans': 'Manage Discount Codes',
      'en': '',
    },
    'etppbzr1': {
      'zh_Hans': 'check.io',
      'en': '',
    },
    'vr4flxkv': {
      'zh_Hans': 'Andrew D.',
      'en': '',
    },
    'ponprkbl': {
      'zh_Hans': 'admin@gmail.com',
      'en': '',
    },
    'hoencd76': {
      'zh_Hans': 'Dashboard',
      'en': '',
    },
    'b8i20jv5': {
      'zh_Hans': 'Chats',
      'en': '',
    },
    'qulp6qla': {
      'zh_Hans': 'Projects',
      'en': '',
    },
    '3w51ylz8': {
      'zh_Hans': 'Explore',
      'en': '',
    },
    '3h91ikuf': {
      'zh_Hans': 'Active Promo Codes',
      'en': '',
    },
    '0ljq5e68': {
      'zh_Hans': 'Assign',
      'en': '',
    },
    'ykbvge6x': {
      'zh_Hans': 'PAKAIJE50\nDiscount: 50%\nValid dates: 1/1/2024 - 2/2/2024',
      'en': '',
    },
    'iod49a3i': {
      'zh_Hans': 'Edit',
      'en': '',
    },
    'bf2yp0ft': {
      'zh_Hans': 'PAKAIJE20\nDiscount: 20%\nValid dates: 1/1/2024 - 2/2/2024',
      'en': '',
    },
    'vu3gwq3g': {
      'zh_Hans': 'Edit',
      'en': '',
    },
    'wll42vop': {
      'zh_Hans': 'Promo Code Performance',
      'en': '',
    },
    '6rqz6jcx': {
      'zh_Hans': 'Redemptions',
      'en': '',
    },
    'xy9i6322': {
      'zh_Hans': '255',
      'en': '',
    },
    'ctfrkl3h': {
      'zh_Hans': '32.2%',
      'en': '',
    },
    '3f1k2qda': {
      'zh_Hans': 'Click-throughs',
      'en': '',
    },
    'jmuh71g1': {
      'zh_Hans': '67',
      'en': '',
    },
    '6tn64a6d': {
      'zh_Hans': '45.5%',
      'en': '',
    },
    'apxtqn7o': {
      'zh_Hans': 'Activity',
      'en': '',
    },
    'bxyfgt4k': {
      'zh_Hans': 'Recent completed tasks from your team.',
      'en': '',
    },
    'ltr0e827': {
      'zh_Hans': 'Rudy Fernandez',
      'en': '',
    },
    '1g0hoba1': {
      'zh_Hans': '4m ago',
      'en': '',
    },
    'y21k4ybk': {
      'zh_Hans': 'Completed ',
      'en': '',
    },
    '5qmtiy4l': {
      'zh_Hans': 'Marketing Plan',
      'en': '',
    },
    'pfum60d7': {
      'zh_Hans': 'Rudy Fernandez',
      'en': '',
    },
    'eb3i5x7g': {
      'zh_Hans': '4m ago',
      'en': '',
    },
    'zif1dvnn': {
      'zh_Hans': 'Started ',
      'en': '',
    },
    '0rsxpcgl': {
      'zh_Hans': 'Marketing Plan',
      'en': '',
    },
    'wqz48rjc': {
      'zh_Hans': 'Abigail Rojas',
      'en': '',
    },
    'ptkf4jam': {
      'zh_Hans': '4m ago',
      'en': '',
    },
    'kndnat3v': {
      'zh_Hans': 'Assigned  ',
      'en': '',
    },
    'r31f62cp': {
      'zh_Hans': 'Rudy Fernandez ',
      'en': '',
    },
    'qqh8gl9y': {
      'zh_Hans': 'to ',
      'en': '',
    },
    'j53kl5iz': {
      'zh_Hans': 'Marketing Plan',
      'en': '',
    },
    '0jm7hm2o': {
      'zh_Hans': 'Abigail Rojas',
      'en': '',
    },
    'c01l12iu': {
      'zh_Hans': '4m ago',
      'en': '',
    },
    'lj9pcsh2': {
      'zh_Hans': 'Created a project: ',
      'en': '',
    },
    '1dbksa1p': {
      'zh_Hans': 'Marketing Plan',
      'en': '',
    },
    'j2jhlqyu': {
      'zh_Hans': 'Liz Ambridge',
      'en': '',
    },
    '889j2h33': {
      'zh_Hans': '4m ago',
      'en': '',
    },
    'hudkd77d': {
      'zh_Hans': 'Sent a plan update for ',
      'en': '',
    },
    'qv35tx2n': {
      'zh_Hans': 'Marketing Plan',
      'en': '',
    },
    'jo5w9bgs': {
      'zh_Hans': 'Project Started',
      'en': '',
    },
    'vpma45yw': {
      'zh_Hans': '12d ago',
      'en': '',
    },
    'l7skuy9l': {
      'zh_Hans': 'Create Promo Codes',
      'en': '',
    },
    'jnvjtmn6': {
      'zh_Hans': 'Code Name',
      'en': '',
    },
    't94fypf6': {
      'zh_Hans': 'Discount Amount',
      'en': '',
    },
    '598vuny0': {
      'zh_Hans': 'Valid Dates',
      'en': '',
    },
    'jhxjqnbs': {
      'zh_Hans': 'TO',
      'en': '',
    },
    'ujvbgiqy': {
      'zh_Hans': 'Valid Dates',
      'en': '',
    },
    'r2l2pz2t': {
      'zh_Hans': 'Create',
      'en': '',
    },
    'b2ht1p2s': {
      'zh_Hans': 'Profile',
      'en': '',
    },
    '1vsozrgq': {
      'zh_Hans': 'Code',
      'en': '',
    },
    'l7n0rp1w': {
      'zh_Hans': 'Virtual',
      'en': '',
    },
    'hg9sdk4r': {
      'zh_Hans': 'Link',
      'en': '',
    },
    '2tldyeb2': {
      'zh_Hans': 'Add',
      'en': '',
    },
    'zjaszf4e': {
      'zh_Hans': 'Home',
      'en': '',
    },
  },
  // SettingBuyLinks
  {
    'vc0z2c89': {
      'zh_Hans': 'Setting Buy Links',
      'en': '',
    },
    'lx6xy3wb': {
      'zh_Hans': 'Product Lists',
      'en': '',
    },
    'u76io6j9': {
      'zh_Hans': 'Product Name',
      'en': '',
    },
    '344gtxo0': {
      'zh_Hans': 'Update Link',
      'en': '',
    },
    '1jxttfrd': {
      'zh_Hans': 'Product Name',
      'en': '',
    },
    '9lq1ywon': {
      'zh_Hans': 'Update Link',
      'en': '',
    },
    '85n5db5t': {
      'zh_Hans': 'Update Link',
      'en': '',
    },
    'qmmo6rxo': {
      'zh_Hans': 'Product URL',
      'en': '',
    },
    'z3o6utsk': {
      'zh_Hans': 'Enter your store link',
      'en': '',
    },
    '69dnbbu3': {
      'zh_Hans': 'e.g., https://shopee.com/yourbrand',
      'en': '',
    },
    'za59wi9n': {
      'zh_Hans': 'Upload',
      'en': '',
    },
    'pwngu30y': {
      'zh_Hans': 'Profile',
      'en': '',
    },
    'n26mt2u2': {
      'zh_Hans': 'Code',
      'en': '',
    },
    '0pzsdkbf': {
      'zh_Hans': 'Virtual',
      'en': '',
    },
    'cami1du1': {
      'zh_Hans': 'Link',
      'en': '',
    },
    '3vs28wrf': {
      'zh_Hans': 'Add',
      'en': '',
    },
    'uzdc168y': {
      'zh_Hans': 'Home',
      'en': '',
    },
  },
  // ProductDetailsPage
  {
    'e1sx93uq': {
      'zh_Hans': 'Basic Tees',
      'en': 'Basic Tees',
    },
    'hngxe2rz': {
      'zh_Hans': '100% Suprima Cotton, 260gsm, Easy Care',
      'en': '100% Suprima Cotton, 260gsm, Easy Care',
    },
    'rfkb0i6i': {
      'zh_Hans': '\$50.00',
      'en': '',
    },
    'iqapzjta': {
      'zh_Hans': 'Copy Link',
      'en': 'Copy PromoLink',
    },
    'poeqw8p8': {
      'zh_Hans': 'Product Details',
      'en': 'Product Details',
    },
    'mnbrvhd6': {
      'zh_Hans': 'Home',
      'en': 'Home',
    },
  },
  // Miscellaneous
  {
    'gkagtzym': {
      'zh_Hans': '',
      'en': '',
    },
    'ugkg4y5x': {
      'zh_Hans': '',
      'en': '',
    },
    'cbmkob1s': {
      'zh_Hans': '',
      'en': '',
    },
    'anlyc0tz': {
      'zh_Hans': '',
      'en': '',
    },
    'gjvkoio8': {
      'zh_Hans': '',
      'en': '',
    },
    'c5rvhhwb': {
      'zh_Hans': '',
      'en': '',
    },
    '6oqy54t6': {
      'zh_Hans': '',
      'en': '',
    },
    'we7epptg': {
      'zh_Hans': '',
      'en': '',
    },
    'azd7g7yn': {
      'zh_Hans': '',
      'en': '',
    },
    'q2qrtuvz': {
      'zh_Hans': '',
      'en': '',
    },
    's1o4qgxf': {
      'zh_Hans': '',
      'en': '',
    },
    'kq2a96wi': {
      'zh_Hans': '',
      'en': '',
    },
    'ybunff3g': {
      'zh_Hans': '',
      'en': '',
    },
    '4zwj0i7j': {
      'zh_Hans': '',
      'en': '',
    },
    '7dfnaqo9': {
      'zh_Hans': '',
      'en': '',
    },
    '98php6yt': {
      'zh_Hans': '',
      'en': '',
    },
    'lw2j5l93': {
      'zh_Hans': '',
      'en': '',
    },
    'fu7tme7f': {
      'zh_Hans': '',
      'en': '',
    },
    '2ag423f7': {
      'zh_Hans': '',
      'en': '',
    },
    't9i16mdo': {
      'zh_Hans': '',
      'en': '',
    },
    '7poi46zb': {
      'zh_Hans': '',
      'en': '',
    },
    '2qdbsopt': {
      'zh_Hans': '',
      'en': '',
    },
    'qqeglvz5': {
      'zh_Hans': '',
      'en': '',
    },
    '978cljmn': {
      'zh_Hans': '',
      'en': '',
    },
    '4krzdv48': {
      'zh_Hans': '',
      'en': '',
    },
    '6dxh70zd': {
      'zh_Hans': '',
      'en': '',
    },
    '9jt9o40x': {
      'zh_Hans': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
