class UrlChecker {
  static final urlCheckReg = RegExp(r"((http|https)://)(www.)?"
      "[a-zA-Z0-9@:%._\\+~#?&//=]"
      "{2,256}\\.[a-z]"
      "{2,6}\\b([-a-zA-Z0-9@:%"
      "._\\+~#?&//=]*)");

  static final checkImageUrlReg =
      RegExp(r"(https?:\/\/.*\.(?:jpg|jpeg|png|webp|avif|gif|svg))");

  static final checkImageSvgUrlReg = RegExp(r"(https?:\/\/.*\.(?:svg))");

  static final checkVideoUrlReg = RegExp(r"(https?:\/\/.*\.(?:mp4))");

  static final checkPdfUrlReg = RegExp(r"(https?:\/\/.*\.(?:pdf))");

  static bool isImageUrl(String url) {
    return isValid(url) && checkImageUrlReg.hasMatch(url);
  }

  static bool isImageSvgUrl(String url) {
    return isValid(url) && checkImageSvgUrlReg.hasMatch(url);
  }

  static bool isVideoUrl(String url) {
    return isValid(url) && checkVideoUrlReg.hasMatch(url);
  }

  static bool isPdfUrl(String url) {
    return isValid(url) && checkPdfUrlReg.hasMatch(url);
  }

  static bool isValid(String url) {
    return urlCheckReg.hasMatch(url);
  }
}
