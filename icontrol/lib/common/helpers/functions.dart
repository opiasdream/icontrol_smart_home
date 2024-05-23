abstract class Functions {
  static String trToEng(Match match) {
    switch (match.group(0)) {
      case 'ç':
        return 'c';
      case 'ı':
        return 'i';
      case 'ğ':
        return 'g';
      case 'ö':
        return 'o';
      case 'ü':
        return 'u';
      case ' ':
        return '';
      default:
        return '';
    }
  }
}
