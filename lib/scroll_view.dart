import 'package:flutter/widgets.dart';

import 'async_value.dart';
import 'controller.dart';
import 'data.dart';
import 'scroll_observer.dart';

class PaginatedScrollView<T> extends StatelessWidget {
  const PaginatedScrollView({
    Key? key,
    required this.controller,
    required this.data,
  }) : super(key: key);

  final PaginationDataController<T> controller;
  final PaginatedScrollViewData<T> data;

  void onRetryCall() {
    if (data.onRetry != null) {
      data.onRetry!();
    } else {
      controller.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PaginationScrollUpdateObserver(
      controller: controller,
      child: StreamBuilder<PagingData<T>>(
        stream: controller.stream,
        builder: (context, snapshot) {
          final pagination = snapshot.data;

          final values = pagination?.values;
          final lastValues = pagination?.lastValues;

          if (lastValues is AsyncLoading || pagination == null) {
            return data.loading;
          } else if (values == null || values.isEmpty) {
            final asyncError =
                lastValues is AsyncError ? (lastValues as AsyncError) : null;
            return data.error(
              context,
              asyncError?.error,
              asyncError?.stackTrace,
              data.onRetry,
            );
          }

          const sliverNothing = SliverToBoxAdapter(child: SizedBox());

          final isEmptyAndNotLoading =
              values.isEmpty && !pagination.nextAvailable;

          return CustomScrollView(
            slivers: [
              // To avoid a bug which occurs when first item in a custom scroll view changes.
              sliverNothing,
              if (isEmptyAndNotLoading) data.sliverEmpty,
              if (!isEmptyAndNotLoading) data.sliverData(context, values),
              if (lastValues is AsyncData && pagination.nextAvailable)
                data.sliverLoadingMore,
              if (lastValues is AsyncError)
                data.sliverErrorWhenLoadingMore(
                  context,
                  (lastValues as AsyncError).error,
                  (lastValues as AsyncError).stackTrace,
                  data.onRetry,
                ),
            ],
          );
        },
      ),
    );
  }
}
