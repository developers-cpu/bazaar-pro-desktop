import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../bloc/support/support_bloc.dart';
import '../widgets/support/support_chat_panel.dart';
import '../widgets/support/support_conversation_list.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupportBloc>()..add(LoadSupportData()),
      child: const _SupportView(),
    );
  }
}

class _SupportView extends StatefulWidget {
  const _SupportView();

  @override
  State<_SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<_SupportView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportBloc, SupportState>(
      builder: (context, state) {
        if (state is SupportLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SupportError) {
          return Center(
            child: Text(
              state.message,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                color: AppColors.primaryBlue,
              ),
            ),
          );
        }
        if (state is! SupportLoaded) {
          return const SizedBox.shrink();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 900;
            final sidebar = SizedBox(
              width: isCompact ? double.infinity : 360.w,
              child: SupportConversationList(
                searchController: _searchController,
                conversations: state.filteredConversations,
                selectedConversationId: state.selectedConversationId,
                onSearchChanged: (value) {
                  context.read<SupportBloc>().add(
                    SearchSupportConversations(value),
                  );
                },
                onConversationTap: (conversationId) {
                  context.read<SupportBloc>().add(
                    SelectSupportConversation(conversationId),
                  );
                },
              ),
            );

            final chatPanel = Expanded(
              child: SupportChatPanel(
                conversation: state.selectedConversation,
                onSendMessage: (message) {
                  context.read<SupportBloc>().add(SendSupportMessage(message));
                },
              ),
            );

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: isCompact
                  ? Column(
                      children: [
                        SizedBox(height: 260.h, child: sidebar),
                        SizedBox(height: 10.h),
                        chatPanel,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [sidebar, chatPanel],
                    ),
            );
          },
        );
      },
    );
  }
}
