import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import '../services/studio_state_service.dart';
import '../models/studio_exceptions.dart';

/// Convenience widget that provides easy access to StudioStateService signals
/// Eliminates the need to manually get the service instance in every widget
class StudioSignalBuilder<T> extends StatelessWidget {
  const StudioSignalBuilder({
    super.key,
    required this.signal,
    required this.builder,
  });

  final ReadSignal<T> signal;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder<T>(
      signal: signal,
      builder: (context, value, _) => builder(context, value),
    );
  }
}

/// Widget that automatically rebuilds when multiple signals change
class MultiSignalBuilder extends StatelessWidget {
  const MultiSignalBuilder({
    super.key,
    required this.signals,
    required this.builder,
  });

  final List<ReadSignal> signals;
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder<List<dynamic>>(
      signal: Computed(() => signals.map((s) => s.value).toList()),
      builder: (context, _, __) => builder(context),
    );
  }
}

/// Common state access patterns as extension methods
extension StudioStateAccess on BuildContext {
  StudioStateService get state => StudioStateService.instance;
}

/// Reactive list builder that automatically updates when list signals change
class ReactiveListBuilder<T> extends StatelessWidget {
  const ReactiveListBuilder({
    super.key,
    required this.listSignal,
    required this.itemBuilder,
    this.separatorBuilder,
    this.emptyBuilder,
  });

  final ReadSignal<List<T>> listSignal;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    return StudioSignalBuilder<List<T>>(
      signal: listSignal,
      builder: (context, items) {
        if (items.isEmpty && emptyBuilder != null) {
          return emptyBuilder!(context);
        }

        if (separatorBuilder != null) {
          return ListView.separated(
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(context, items[index], index),
            separatorBuilder: separatorBuilder!,
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(context, items[index], index),
        );
      },
    );
  }
}

/// Reactive selector that rebuilds only when the selected value changes
class ReactiveSelector<T, R> extends StatelessWidget {
  const ReactiveSelector({
    super.key,
    required this.signal,
    required this.selector,
    required this.builder,
  });

  final ReadSignal<T> signal;
  final R Function(T value) selector;
  final Widget Function(BuildContext context, R selected) builder;

  @override
  Widget build(BuildContext context) {
    final selectedSignal = Computed(() => selector(signal.value));

    return StudioSignalBuilder<R>(
      signal: selectedSignal,
      builder: builder,
    );
  }
}

/// State-aware widget that shows loading states automatically
class StateAwareWidget extends StatelessWidget {
  const StateAwareWidget({
    super.key,
    required this.child,
    this.showLoading = true,
    this.showErrors = true,
    this.loadingWidget,
    this.errorBuilder,
  });

  final Widget child;
  final bool showLoading;
  final bool showErrors;
  final Widget? loadingWidget;
  final Widget Function(BuildContext context, List<StudioException> errors)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final state = context.state;

    return MultiSignalBuilder(
      signals: [state.isLoading, state.errors],
      builder: (context) {
        final isLoading = state.isLoading.value;
        final errors = state.errors.value;

        // Show loading overlay
        if (showLoading && isLoading) {
          return Stack(
            children: [
              child,
              if (loadingWidget != null)
                loadingWidget!
              else
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        }

        // Show errors
        if (showErrors && errors.isNotEmpty && errorBuilder != null) {
          return Column(
            children: [
              errorBuilder!(context, errors),
              Expanded(child: child),
            ],
          );
        }

        return child;
      },
    );
  }
}

/// Error display widget that automatically shows current errors
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    this.maxErrors = 3,
    this.autoDismiss = true,
  });

  final int maxErrors;
  final bool autoDismiss;

  @override
  Widget build(BuildContext context) {
    final state = context.state;

    return StudioSignalBuilder<List<StudioException>>(
      signal: state.errors,
      builder: (context, errors) {
        if (errors.isEmpty) return const SizedBox.shrink();

        final displayErrors = errors.take(maxErrors).toList();

        return Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: displayErrors.map((error) {
              return Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(error.toString()),
                  trailing: autoDismiss
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => state.removeError(error),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}