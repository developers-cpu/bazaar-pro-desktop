import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../bloc/server/server_bloc.dart';
import '../../bloc/server/server_event.dart';
import '../../bloc/server/server_state.dart';
import '../../widgets/server/add_edit_server_dialog.dart';
import '../../widgets/server/server_data_table.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({super.key});
  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ServerBloc>().add(LoadServersEvent());
    _searchCtrl.addListener(() {
      context.read<ServerBloc>().add(SearchServerEvent(_searchCtrl.text));
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showAddServerDialog() {
    showDialog(
      context: context,
      builder: (_) => AddEditServerDialog(
        title: 'Add Server',
        buttonText: 'Add',
        onSubmit: (name, logo) {
          context.read<ServerBloc>().add(
            AddServerEvent(serverName: name, logoPath: logo),
          );
        },
      ),
    );
  }

  void _showEditServerDialog(String id, String initialName) {
    showDialog(
      context: context,
      builder: (_) => AddEditServerDialog(
        title: 'Edit Server',
        buttonText: 'Updated',
        initialServerName: initialName,
        onSubmit: (name, logo) {
          context.read<ServerBloc>().add(
            EditServerEvent(id: id, serverName: name, logoPath: logo),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: BlocBuilder<ServerBloc, ServerState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomActionButton(
                text: 'Add New Server',
                onPressed: _showAddServerDialog,
                width: 140.w,
                height: 35.h,
                borderRadius: 8.r,
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  CustomInputField(
                    hintText: 'Search',
                    controller: _searchCtrl,
                    prefixSvgPath: AppImages.searchIcon,
                    width: 200.w,
                    height: 35.h,
                  ),
                  const Spacer(),
                  Text(
                    'RECORD : ${state.filteredServers.length}',
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: state.status == ServerStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ServerDataTable(
                        data: state.filteredServers,
                        onToggleStatus: (id, val) {
                          context.read<ServerBloc>().add(
                            UpdateServerStatusEvent(id: id, status: val),
                          );
                        },
                        onEditServer: (server) {
                          _showEditServerDialog(server.id, server.serverName);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
