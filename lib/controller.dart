import 'dart:async' show Completer;

import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

import 'async_value.dart';

typedef OnFetchCallback<T> = Future<Iterable<T>> Function(
  int current,
  int limit,
);

class PagingData<T> {
  final int current;
  final int limit;
  final AsyncValue<Iterable<T>> lastValues;
  final Iterable<T>? values;
  final Object _token;

  const PagingData(
    this.current,
    this.limit,
    this.values,
    this.lastValues,
    this._token,
  );

  int get length => values?.length ?? 0;

  bool get nextAvailable => (values == null) || ((length % limit) == 0);

  PagingData<T> copyWith({
    int? current,
    int? limit,
    Iterable<T>? values,
    AsyncValue<Iterable<T>>? lastValues,
  }) {
    return PagingData(
      current ?? this.current,
      limit ?? this.limit,
      values ?? this.values,
      lastValues ?? this.lastValues,
      _token,
    );
  }
}

class PaginationDataController<T> extends StateNotifier<PagingData<T>> {
  PaginationDataController({
    required this.fetch,
    this.initial = 0,
    this.limit = 20,
    this.loadThreshold = 200,
  }) : super(PagingData<T>(
          initial - 1,
          limit,
          null,
          const AsyncValue.loading(),
          Object(),
        )) {
    load();
  }

  final int initial;

  void refresh() {
    final initialState = PagingData<T>(
      initial - 1,
      limit,
      null,
      const AsyncValue.loading(),
      Object(),
    );
    state = initialState;
    load();
  }

  void _setState(PagingData<T> value) {
    final val = state;
    // If tokens are not identical, then the state might have refreshed. In this case, we don't want to update the state.
    if (!identical(val._token, value._token)) return;
    state = val;
  }

  final OnFetchCallback<T> fetch;
  final int limit;
  final double loadThreshold;

  bool onScrollUpdate(ScrollUpdateNotification notification) {
    if (shouldLoad(notification)) {
      load();
    }
    return true;
  }

  bool shouldLoad(ScrollUpdateNotification notification) =>
      state.nextAvailable && notification.metrics.extentAfter <= loadThreshold;

  Completer? _completer;

  @protected
  Future<void> load() async {
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer();
      _loadData().then((value) {
        _completer?.complete();
      });
    }

    return _completer!.future;
  }

  Future<void> _loadData() async {
    final oldState = state;
    assert(oldState.nextAvailable);
    try {
      final nextPage = oldState.current + 1;
      final data = await fetch(nextPage, oldState.limit);

      final newValues = List<T>.unmodifiable([
        ...?oldState.values,
        ...data,
      ]);

      final asyncValue = AsyncValue<Iterable<T>>.data(newValues);

      _setState(oldState.copyWith(
        current: nextPage,
        values: newValues,
        lastValues: asyncValue,
      ));
    } catch (e, s) {
      final asyncValue = AsyncValue<Iterable<T>>.error(e, stackTrace: s);
      _setState(oldState.copyWith(lastValues: asyncValue));
    }
  }
}
