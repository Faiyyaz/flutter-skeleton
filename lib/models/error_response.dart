class ErrorResponse {
  ErrorResponse({
    required this.error,
    required this.message,
  });

  Map<String, dynamic>? error;
  String message;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
