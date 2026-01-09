class NameValidator {
  static String? validate(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return "이름을 입력해주세요.";
    }

    if (trimmed.length < 2) {
      return "이름은 최소 2글자 이상이어야 합니다.";
    }

    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(trimmed)) {
      return "한글 또는 영문만 입력 가능합니다.\n(특수문자, 숫자 불가)";
    }

    return null;
  }
}