import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class SafeBlocListener<B extends StateStreamable<S>, S>
    extends SingleChildStatelessWidget {
  const SafeBlocListener({
    required this.listener,
    super.key,
    super.child,
    this.listenWhen,
  });

  final BlocListenerCondition<S>? listenWhen;
  final BlocWidgetListener<S> listener;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocListener<B, S>(
      listenWhen: listenWhen,
      listener: (ctx, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!ctx.mounted) return;
          listener(ctx, state);
        });
      },
      child: child,
    );
  }
}
