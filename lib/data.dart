import 'package:flutter/widgets.dart';

typedef DataWidgetBuilder<T> = Widget Function(
  BuildContext context,
  Iterable<T> values,
);

typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object? e,
  StackTrace? s,
  VoidCallback? onRetry,
);

@immutable
class PaginatedScrollViewData<T> {
  final VoidCallback? onRetry;
  final DataWidgetBuilder<T> sliverData;
  final Widget sliverEmpty;
  final Widget loading;
  final Widget sliverLoadingMore;
  final ErrorWidgetBuilder error;
  final ErrorWidgetBuilder sliverErrorWhenLoadingMore;

  const PaginatedScrollViewData({
    this.onRetry,
    required this.sliverData,
    required this.sliverEmpty,
    required this.loading,
    required this.sliverLoadingMore,
    required this.error,
    required this.sliverErrorWhenLoadingMore,
  });

  PaginatedScrollViewData<T> copyWith({
    VoidCallback? onRetry,
    DataWidgetBuilder<T>? sliverData,
    Widget? sliverEmpty,
    Widget? loading,
    Widget? sliverLoadingMore,
    ErrorWidgetBuilder? error,
    ErrorWidgetBuilder? sliverErrorWhenLoadingMore,
  }) {
    return PaginatedScrollViewData(
      onRetry: onRetry ?? this.onRetry,
      sliverData: sliverData ?? this.sliverData,
      sliverEmpty: sliverEmpty ?? this.sliverEmpty,
      error: error ?? this.error,
      sliverLoadingMore: sliverLoadingMore ?? this.sliverLoadingMore,
      loading: loading ?? this.loading,
      sliverErrorWhenLoadingMore:
          sliverErrorWhenLoadingMore ?? this.sliverErrorWhenLoadingMore,
    );
  }
}
