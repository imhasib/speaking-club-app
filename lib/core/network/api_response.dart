/// Generic API response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? code;
  final Map<String, dynamic>? meta;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.code,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      message: json['message'],
      code: json['code'],
      meta: json['meta'],
    );
  }

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String message, {String? code}) {
    return ApiResponse(
      success: false,
      message: message,
      code: code,
    );
  }

  bool get isSuccess => success && data != null;
  bool get isError => !success;

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, message: $message, code: $code)';
  }
}

/// Paginated API response
class PaginatedResponse<T> {
  final List<T> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final items = (data['items'] as List? ?? [])
        .map((e) => fromJsonT(e as Map<String, dynamic>))
        .toList();

    return PaginatedResponse(
      items: items,
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 20,
      total: data['total'] ?? items.length,
      totalPages: data['totalPages'] ?? 1,
      hasNextPage: data['hasNextPage'] ?? false,
      hasPrevPage: data['hasPrevPage'] ?? false,
    );
  }

  PaginatedResponse<T> copyWith({
    List<T>? items,
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPrevPage,
  }) {
    return PaginatedResponse(
      items: items ?? this.items,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPrevPage: hasPrevPage ?? this.hasPrevPage,
    );
  }

  /// Merge with another page of results
  PaginatedResponse<T> merge(PaginatedResponse<T> other) {
    return PaginatedResponse(
      items: [...items, ...other.items],
      page: other.page,
      limit: other.limit,
      total: other.total,
      totalPages: other.totalPages,
      hasNextPage: other.hasNextPage,
      hasPrevPage: hasPrevPage,
    );
  }
}
