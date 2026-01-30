import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_text_field.dart';
import '../../../bloc/user_form/user_form_bloc.dart';
import '../../../bloc/user_form/user_form_event.dart';
import '../../../bloc/user_form/user_form_state.dart';


class PnlSharingStep extends StatefulWidget {
  const PnlSharingStep({super.key});

  @override
  State<PnlSharingStep> createState() => _PnlSharingStepState();
}

class _PnlSharingStepState extends State<PnlSharingStep> {
  late TextEditingController _plSharingController;
  late TextEditingController _brokerageSharingController;

  @override
  void initState() {
    super.initState();
    final state = context.read<UserFormBloc>().state;
    _plSharingController = TextEditingController(text: state.plSharing);
    _brokerageSharingController = TextEditingController(
      text: state.brokerageSharing,
    );
  }

  @override
  void dispose() {
    _plSharingController.dispose();
    _brokerageSharingController.dispose();
    super.dispose();
  }

  void _updateField(String field, String value) {
    context.read<UserFormBloc>().add(
      UpdateFormFieldEvent(fieldName: field, value: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppTextField(
              controller: _plSharingController,
              hintText: 'P/L Sharing (%)',
              helperText: 'Our:60 | Downline: 20 |Upline: 20',
              keyboardType: TextInputType.number,
              onChanged: (v) => _updateField('plSharing', v),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AppTextField(
              controller: _brokerageSharingController,
              hintText: 'Brokerage Sharing (%)',
              helperText: 'Our:60 | Downline: 20 |Upline: 20',
              keyboardType: TextInputType.number,
              onChanged: (v) => _updateField('brokerageSharing', v),
            ),
          ),
        ],
      ),
    );
  }
}
