import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/auth/presentation/presentation.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAuthenticated = context.select(
      (AuthCubit cubit) => cubit.state.isAuthenticated,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.xs,
      children: [
        const Expanded(child: SearchField()),
        const ClipboardItemTypeFilter(),
        const IncognitoModeToggleButton(),
        ProGateOverlay(
          blockInteractions: false,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            onPressed: () async {
              if (isAuthenticated) {
                // TODO(Ethiel97): Sync functionality

                //invoke supabase edge function to sync
                /*
                final authUser = context.read<AuthCubit>().state.user.data;

                final accessToken =
                    getIt<SupabaseClient>().auth.currentSession?.accessToken;

                print("accessToken: $accessToken");

                final res = await getIt<HttpClient>().post(
                  'https://c76a5e9309ee.ngrok-free.app/api/checkout?&products=089849ee-7f31-47ec-b9d1-78e40488322d',
                  headers: {'Authorization': 'Bearer ${accessToken ?? ''}'},
                  data: {
                    'productId': '089849ee-7f31-47ec-b9d1-78e40488322d',
                    'customerEmail': authUser?.email,
                    'metadata': {'supabaseUserId': authUser?.id},
                  },
                );

                log('Edge function response data: ${res}');*/
              } else {
                context.router.root.navigate(const LoginRoute());
              }
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedDatabaseSync01,
              size: 18,
            ),
            label: Text(l10n.sync.sentenceCase),
          ),
        ),
      ],
    );
  }
}
