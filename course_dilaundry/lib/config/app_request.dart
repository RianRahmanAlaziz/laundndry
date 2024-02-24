class AppRequest {
  static Map<String, String> header([String? bearerToken]) {
    if (bearerToken == null) {
      return {
        "Accept": "application/json",
      };
    } else {
      return {
        "Accept": "application/json",
        'Authorization': 'Bearer $bearerToken',
      };
    }
  }
}

class AppRequestJson {
  static Map<String, String> header([String? bearerToken]) {
    if (bearerToken == null) {
      return {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
    } else {
      return {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $bearerToken',
      };
    }
  }
}
