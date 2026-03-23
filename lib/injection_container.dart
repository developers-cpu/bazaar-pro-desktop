import 'package:bazarpro/features/operations/domain/repositories/exchange_settings/exchange_settings_repository.dart';
import 'package:bazarpro/features/operations/data/repositories/exchange_settings/exchange_settings_repository_impl.dart';
import 'package:bazarpro/features/operations/data/datasources/exchange_settings/exchange_settings_remote_data_source.dart';
import 'package:bazarpro/features/operations/data/datasources/exchange_settings/exchange_settings_remote_data_source_impl.dart';
import 'package:bazarpro/features/operations/domain/repositories/group/group_repository.dart';
import 'package:bazarpro/features/operations/data/repositories/group/group_repository_impl.dart';
import 'package:bazarpro/features/operations/data/datasources/group/group_remote_data_source.dart';
import 'package:bazarpro/features/operations/data/datasources/group/group_remote_data_source_impl.dart';
import 'package:bazarpro/features/operations/domain/usecases/exchange_settings/get_exchange_settings.dart';
import 'package:bazarpro/features/operations/domain/repositories/date_settings/date_settings_repository.dart';
import 'package:bazarpro/features/operations/data/repositories/date_settings/date_settings_repository_impl.dart';
import 'package:bazarpro/features/operations/data/datasources/date_settings/date_settings_remote_data_source.dart';
import 'package:bazarpro/features/operations/data/datasources/date_settings/date_settings_remote_data_source_impl.dart';
import 'package:bazarpro/features/operations/domain/usecases/date_settings/get_date_settings.dart';
import 'package:bazarpro/features/operations/domain/usecases/date_settings/update_date_settings.dart';
import 'package:bazarpro/features/operations/presentation/bloc/date_settings/date_settings_bloc.dart';
import 'package:bazarpro/features/operations/domain/repositories/script_settings/script_settings_repository.dart';
import 'package:bazarpro/features/operations/data/repositories/script_settings/script_settings_repository_impl.dart';
import 'package:bazarpro/features/operations/data/datasources/script_settings/script_settings_remote_data_source.dart';
import 'package:bazarpro/features/operations/data/datasources/script_settings/script_settings_remote_data_source_impl.dart';
import 'package:bazarpro/features/operations/domain/usecases/script_settings/get_script_settings.dart';
import 'package:bazarpro/features/operations/domain/usecases/script_settings/update_script_settings.dart';
import 'package:bazarpro/features/operations/presentation/bloc/script_settings/script_settings_bloc.dart';
import 'package:bazarpro/features/operations/domain/repositories/surveillance/surveillance_repository.dart';
import 'package:bazarpro/features/operations/data/repositories/surveillance/surveillance_repository_impl.dart';
import 'package:bazarpro/features/operations/data/datasources/surveillance/surveillance_remote_data_source.dart';
import 'package:bazarpro/features/operations/data/datasources/surveillance/surveillance_remote_data_source_impl.dart';
import 'package:bazarpro/features/operations/domain/usecases/surveillance/get_surveillance_data.dart';
import 'package:bazarpro/features/operations/domain/usecases/surveillance/update_surveillance_data.dart';
import 'package:bazarpro/features/operations/presentation/bloc/surveillance/surveillance_bloc.dart';
import 'package:bazarpro/features/operations/domain/usecases/exchange_settings/update_exchange_settings.dart';
import 'package:bazarpro/features/operations/presentation/bloc/exchange_settings/exchange_settings_bloc.dart';
import 'package:bazarpro/features/operations/presentation/bloc/trade_settings/trade_settings_bloc.dart';
import 'package:bazarpro/features/operations/domain/repositories/trade_settings/trade_settings_repository.dart';
import 'package:bazarpro/features/operations/data/repositories/trade_settings/trade_settings_repository_impl.dart';
import 'package:bazarpro/features/operations/data/datasources/trade_settings/trade_settings_remote_data_source.dart';
import 'package:bazarpro/features/operations/data/datasources/trade_settings/trade_settings_remote_data_source_impl.dart';
import 'package:bazarpro/features/operations/domain/usecases/trade_settings/get_trade_settings.dart';
import 'package:bazarpro/features/operations/domain/usecases/trade_settings/update_trade_settings.dart';
import 'package:bazarpro/features/operations/domain/repositories/settlement_progress/settlement_progress_repository.dart';
import 'package:bazarpro/features/operations/data/repositories/settlement_progress/settlement_progress_repository_impl.dart';
import 'package:bazarpro/features/operations/data/datasources/settlement_progress/settlement_progress_remote_data_source.dart';
import 'package:bazarpro/features/operations/data/datasources/settlement_progress/settlement_progress_remote_data_source_impl.dart';
import 'package:bazarpro/features/operations/domain/usecases/settlement_progress/get_settlement_data_usecase.dart';
import 'package:bazarpro/features/operations/domain/usecases/settlement_progress/import_bhav_copy_usecase.dart';
import 'package:bazarpro/features/operations/domain/usecases/settlement_progress/submit_bhav_copy_usecase.dart';
import 'package:bazarpro/features/operations/presentation/bloc/settlement_progress/settlement_progress_bloc.dart';
import 'package:bazarpro/features/report/presentation/bloc/trade_log/trade_log_bloc.dart';
import 'package:bazarpro/features/users/data/datasources/user/user_remote_datasource.dart';
import 'package:bazarpro/features/users/data/datasources/user_brokerage_setting/user_brokerage_setting_datasource.dart';
import 'package:bazarpro/features/users/data/datasources/user_credit_transaction/user_credit_datasource.dart';
import 'package:bazarpro/features/users/domain/usecases/user/export_users_to_excel.dart';
import 'package:bazarpro/features/users/domain/usecases/user/export_users_to_pdf.dart';
import 'package:bazarpro/features/users/domain/usecases/user/get_user_statuses.dart';
import 'package:bazarpro/features/users/domain/usecases/user/get_user_types.dart';
import 'package:bazarpro/features/users/domain/usecases/user/get_users.dart';
import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/market_watch/data/datasources/market_watch_local_datasource.dart';
import 'features/market_watch/data/repositories/market_watch_repository_impl.dart';
import 'features/market_watch/domain/repositories/market_watch_repository.dart';
import 'features/market_watch/domain/usecases/add_market_item.dart';
import 'features/market_watch/domain/usecases/delete_market_item.dart';
import 'features/market_watch/domain/usecases/get_market_items.dart';
import 'features/market_watch/presentation/bloc/arrangesymbol/arrange_symbol_bloc.dart';
import 'features/market_watch/presentation/bloc/market_depth/market_depth_bloc.dart';
import 'features/market_watch/presentation/bloc/marketwatch/market_watch_bloc.dart';
import 'features/market_watch/presentation/bloc/order/order_dialog_bloc.dart';
import 'features/market_watch/presentation/bloc/symbolfont/symbol_font_bloc.dart';
import 'features/market_watch/presentation/bloc/theme/theme_bloc.dart';
import 'features/market_watch/presentation/bloc/watchlist/watch_list_bloc.dart';
import 'features/operations/domain/usecases/group/add_group.dart';
import 'features/operations/domain/usecases/group/get_groups.dart';
import 'features/users/domain/usecases/user/get_users_with_filters.dart';
import 'features/view/data/datasources/deals/deals_remote_datasource.dart';
import 'features/view/data/datasources/intraday_history/intraday_history_remote_datasource.dart';
import 'features/view/data/datasources/login_history/login_history_remote_datasource.dart';
import 'features/view/data/datasources/net_position/net_position_remote_datasource.dart';
import 'features/view/data/datasources/pending_order/pending_orders_remote_datasource.dart';
import 'features/view/data/datasources/rejection_log/rejection_log_remote_datasource.dart';
import 'features/view/data/datasources/deleted_trade/deleted_trade_remote_datasource.dart';
import 'features/view/data/datasources/rejected_trade/rejected_trade_remote_datasource.dart';
import 'features/view/data/datasources/script_master/script_master_remote_datasource.dart';
import 'features/view/data/datasources/script_quantity/script_quantity_remote_datasource.dart';
import 'features/view/data/datasources/trades/trades_remote_datasource.dart';
import 'features/view/data/datasources/broker_list/broker_remote_data_source.dart';
import 'features/view/data/repositories/deals/deals_repository_impl.dart';
import 'features/view/data/repositories/intraday_history/intraday_history_repository_impl.dart';
import 'features/view/data/repositories/login_history/login_history_repository_impl.dart';
import 'features/view/data/repositories/net_postion/net_position_repository_impl.dart';
import 'features/view/data/repositories/pending_orders/pending_orders_repository_impl.dart';
import 'features/view/data/repositories/rejection_log/rejection_log_repository_impl.dart';
import 'features/view/data/repositories/deleted_trade/deleted_trade_repository_impl.dart';
import 'features/view/data/repositories/rejected_trade/rejected_trade_repository_impl.dart';
import 'features/view/data/repositories/script_master/script_master_repository_impl.dart';
import 'features/view/data/repositories/script_quantity/script_quantity_repository_impl.dart';
import 'features/view/data/repositories/trades/trades_repository_impl.dart';
import 'features/view/data/repositories/broker_list/broker_repository_impl.dart';
import 'features/view/domain/repositories/deals/deals_repository.dart';
import 'features/view/domain/repositories/intraday_history/intraday_history_repository.dart';
import 'features/view/domain/repositories/login_history/login_history_repository.dart';
import 'features/view/domain/repositories/net_postion/net_position_repository.dart';
import 'features/view/domain/repositories/pending_orders/pending_orders_repository.dart';
import 'features/view/domain/repositories/rejection_log/rejection_log_repository.dart';
import 'features/view/domain/repositories/deleted_trade/deleted_trade_repository.dart';
import 'features/view/domain/repositories/rejected_trade/rejected_trade_repository.dart';
import 'features/view/domain/repositories/script_master/script_master_repository.dart';
import 'features/view/domain/repositories/script_quantity/script_quantity_repository.dart';
import 'features/view/domain/repositories/trades/trades_repository.dart';
import 'features/view/domain/repositories/broker_list/broker_repository.dart';
import 'features/view/domain/usecases/ rejection_log/rejection_log_usecases.dart';
import 'features/view/domain/usecases/deleted_trade/deleted_trade_usecases.dart';
import 'features/view/domain/usecases/rejected_trade/rejected_trade_usecases.dart';
import 'features/view/domain/usecases/deals/deals_usecases.dart';
import 'features/view/domain/usecases/intraday_history/intraday_history_usecases.dart';
import 'features/view/domain/usecases/login_history/login_history_usecases.dart';
import 'features/view/domain/usecases/netposition/net_position_usecases.dart';
import 'features/view/domain/usecases/pending_order/export_orders.dart';
import 'features/view/domain/usecases/pending_order/get_filter_data.dart';
import 'features/view/domain/usecases/pending_order/get_pending_orders.dart';
import 'features/view/domain/usecases/script_master/script_master_usecases.dart';
import 'features/view/domain/usecases/script_quantity/script_quantity_usecases.dart';
import 'features/view/domain/usecases/trade/trades_usecases.dart';
import 'features/view/presentation/bloc/deals/deals_bloc.dart';
import 'features/view/presentation/bloc/intraday_history/intraday_history_bloc.dart';
import 'features/view/presentation/bloc/login_history/login_history_bloc.dart';
import 'features/view/presentation/bloc/net_position/net_position_bloc.dart';
import 'features/view/presentation/bloc/pending_orders/pending_orders_bloc.dart';
import 'features/view/presentation/bloc/rejection_log/rejection_log_bloc.dart';
import 'features/view/presentation/bloc/deleted_trade/deleted_trade_bloc.dart';
import 'features/view/presentation/bloc/rejected_trade/rejected_trade_bloc.dart';
import 'features/view/presentation/bloc/script_master/script_master_bloc.dart';
import 'features/view/presentation/bloc/script_quantity/script_quantity_bloc.dart';
import 'features/view/presentation/bloc/trade/trades_bloc.dart';
import 'features/view/presentation/bloc/broker_list/broker_list_bloc.dart';
import 'features/view/presentation/bloc/broker_list/client_breakdown_bloc.dart';
import 'features/view/domain/usecases/broker_list/get_client_breakdown.dart';
import 'features/view/domain/repositories/broker_list/client_breakdown_repository.dart';
import 'features/view/data/repositories/broker_list/client_breakdown_repository_impl.dart';
import 'features/view/data/datasources/broker_list/client_breakdown_remote_datasource.dart';
import 'features/users/data/repositories/user/user_repository_impl.dart';
import 'features/users/domain/repositories/user/user_repository.dart';
import 'features/users/presentation/bloc/user_list/user_list_bloc.dart';
import 'features/users/presentation/bloc/inactive_user_list/inactive_user_list_bloc.dart';
import 'features/users/presentation/bloc/search_user/search_user_bloc.dart';
import 'features/users/domain/usecases/user_trades/get_user_trades.dart';
import 'features/users/domain/usecases/user_brokerage_setting/get_user_brokerage_settings.dart';
import 'features/users/domain/usecases/user_brokerage_setting/update_brokerage_settings.dart';
import 'features/users/domain/usecases/user/get_exchanges.dart'
    as user_exchanges;
import 'features/users/domain/usecases/user/get_symbols.dart' as user_symbols;
import 'features/users/presentation/bloc/user_trades/user_trades_bloc.dart';
import 'features/users/presentation/bloc/user_position/user_position_bloc.dart';
import 'features/users/presentation/bloc/user_brokerage/user_brokerage_bloc.dart';
import 'features/users/presentation/bloc/user_pending_order/user_pending_order_bloc.dart';
import 'features/users/presentation/bloc/user_quantity_settings/user_quantity_settings_bloc.dart';
import 'features/users/presentation/bloc/user_rejection_log/user_rejection_log_bloc.dart';
import 'features/users/presentation/bloc/user_sharing/user_sharing_bloc.dart';
import 'features/users/presentation/bloc/user_trade_margin/user_trade_margin_bloc.dart';
import 'features/users/domain/usecases/user_pending_order/get_user_pending_orders_usecase.dart';
import 'features/users/domain/usecases/user_pending_order/get_user_pending_order_metadata_usecase.dart';
import 'features/users/domain/usecases/user_quantity_setting/get_user_quantity_settings_usecase.dart';
import 'features/users/domain/usecases/user_quantity_setting/get_user_quantity_settings_metadata_usecase.dart';
import 'features/users/domain/usecases/user_rejection_log/get_user_rejection_log_usecase.dart';
import 'features/users/domain/usecases/user_rejection_log/get_user_rejection_log_metadata_usecase.dart';
import 'features/users/domain/usecases/user_sharing_details/get_user_sharing_details_usecase.dart';
import 'features/users/domain/usecases/user_trade_margin/get_user_trade_margin_usecase.dart';
import 'features/users/domain/usecases/user_trade_margin/get_user_trade_margin_metadata_usecase.dart';
import 'features/users/data/datasources/user_pending_order/user_pending_order_datasource.dart';
import 'features/users/data/datasources/user_quantity_setting/user_quantity_settings_datasource.dart';
import 'features/users/data/datasources/user_rejection_log/user_rejection_log_datasource.dart';
import 'features/users/data/datasources/user_sharing_details/user_sharing_details_datasource.dart';
import 'features/users/data/datasources/user_trade_margin/user_trade_margin_datasource.dart';
import 'features/users/domain/repositories/user_pending_order/user_pending_order_repository.dart';
import 'features/users/domain/repositories/user_quantity_setting/user_quantity_settings_repository.dart';
import 'features/users/data/repositories/user_position/user_position_repository_impl.dart';
import 'features/users/domain/repositories/user_position/user_position_repository.dart';
import 'features/users/domain/repositories/user_rejection_log/user_rejection_log_repository.dart';
import 'features/users/domain/repositories/user_sharing_details/user_sharing_details_repository.dart';
import 'features/users/domain/repositories/user_trade_margin/user_trade_margin_repository.dart';
import 'features/users/data/repositories/user_pending_order/user_pending_order_repository_impl.dart';
import 'features/users/data/repositories/user_quantity_setting/user_quantity_settings_repository_impl.dart';
import 'features/users/data/repositories/user_rejection_log/user_rejection_log_repository_impl.dart';
import 'features/users/data/repositories/user_sharing_details/user_sharing_details_repository_impl.dart';
import 'features/users/presentation/bloc/user_credit/user_credit_bloc.dart';
import 'features/users/presentation/bloc/user_group_settings/user_group_settings_bloc.dart';
import 'features/users/presentation/bloc/user_intraday/user_intraday_bloc.dart';
import 'features/operations/presentation/bloc/message/operations_message_bloc.dart';
import 'features/operations/presentation/bloc/server/server_bloc.dart';
import 'features/operations/domain/repositories/server/server_repository.dart';
import 'features/operations/domain/usecases/server/get_servers.dart';
import 'features/operations/domain/usecases/server/update_server_status.dart';
import 'features/operations/data/datasources/server/server_remote_data_source.dart';
import 'features/operations/data/datasources/server/server_remote_data_source_impl.dart';
import 'features/operations/data/repositories/server/server_repository_impl.dart';
import 'features/operations/presentation/bloc/bill_comparison/bill_comparison_bloc.dart';
import 'features/operations/domain/repositories/bill_comparison/bill_comparison_repository.dart';
import 'features/operations/domain/usecases/bill_comparison/get_bill_comparison_data.dart';
import 'features/operations/data/datasources/bill_comparison/bill_comparison_remote_data_source.dart';
import 'features/operations/data/datasources/bill_comparison/bill_comparison_remote_data_source_impl.dart';
import 'features/operations/data/repositories/bill_comparison/bill_comparison_repository_impl.dart';
import 'features/users/presentation/bloc/nested_users/nested_users_bloc.dart';
import 'features/users/domain/usecases/user/get_nested_users_usecase.dart';
import 'features/users/domain/usecases/user_credit_transaction/get_user_credit_usecase.dart';
import 'features/users/domain/usecases/user_group_settings/get_user_group_settings_usecase.dart';
import 'features/users/domain/usecases/user_intraday_square_off/get_user_intraday_square_off_usecase.dart';
import 'features/users/data/datasources/user_group_settings/user_group_settings_datasource.dart';
import 'features/users/data/datasources/user_intraday_square_off/user_intraday_square_off_datasource.dart';
import 'features/users/data/repositories/user_credit_transaction/user_credit_repository_impl.dart';
import 'features/users/data/repositories/user_group_settings/user_group_settings_repository_impl.dart';
import 'features/users/data/repositories/user_intraday_square_off/user_intraday_square_off_repository_impl.dart';
import 'features/users/domain/repositories/user_credit_transaction/user_credit_repository.dart';
import 'features/users/domain/repositories/user_group_settings/user_group_settings_repository.dart';
import 'features/users/domain/repositories/user_intraday_square_off/user_intraday_square_off_repository.dart';
import 'features/users/data/repositories/user_trade_margin/user_trade_margin_repository_impl.dart';
import 'features/users/presentation/bloc/user_form/user_form_bloc.dart';
import 'features/users/domain/usecases/user_trades/get_user_trades_metadata_usecase.dart';
import 'features/users/domain/repositories/user_trades/user_trades_repository.dart';
import 'features/users/data/repositories/user_trades/user_trades_repository_impl.dart';
import 'features/users/data/datasources/user_trades/user_trades_datasource.dart';
import 'features/users/domain/usecases/user_position/get_user_positions.dart';
import 'features/users/data/datasources/user_position/user_position_datasource.dart';
import 'features/users/domain/repositories/user_brokerage_setting/user_brokerage_setting_repository.dart';
import 'features/users/data/repositories/user_brokerage_setting/user_brokerage_setting_repository_impl.dart';
import 'features/report/data/datasources/trade_log/trade_log_remote_datasource.dart';
import 'features/view/data/datasources/trade_margin/trade_margin_remote_datasource.dart';
import 'features/report/data/datasources/credit_history/credit_history_remote_datasource.dart';
import 'features/report/data/datasources/activity_report/activity_report_remote_datasource.dart';
import 'features/report/data/repositories/trade_log_repository_impl.dart';
import 'features/view/data/repositories/trade_margin/trade_margin_repository_impl.dart';
import 'features/report/data/repositories/credit_history_repository_impl.dart';
import 'features/report/data/repositories/activity_report_repository_impl.dart';
import 'features/report/domain/repositories/trade_log_repository.dart';
import 'features/view/domain/repositories/trade_margin/trade_margin_repository.dart';
import 'features/report/domain/repositories/credit_history_repository.dart';
import 'features/report/domain/repositories/activity_report_repository.dart';
import 'features/report/domain/usecases/get_trade_logs.dart';
import 'features/view/domain/usecases/trade_margin/get_trade_margins.dart';
import 'features/report/domain/usecases/get_credit_history.dart';
import 'features/report/domain/usecases/get_activity_report.dart';
import 'features/view/presentation/bloc/trade_margin/trade_margin_bloc.dart';
import 'features/report/presentation/bloc/credit_history/credit_history_bloc.dart';
import 'features/report/presentation/bloc/activity_report/activity_report_bloc.dart';
import 'features/report/data/datasources/back_office_activity_report/back_office_activity_report_remote_datasource.dart';
import 'features/report/data/repositories/back_office_activity_report_repository_impl.dart';
import 'features/report/domain/repositories/back_office_activity_report_repository.dart';
import 'features/report/domain/usecases/get_back_office_activity_report.dart';
import 'features/report/presentation/bloc/back_office_activity_report/back_office_activity_report_bloc.dart';
import 'features/report/domain/repositories/symbol_wise_position_report_repository.dart';
import 'features/report/domain/usecases/get_symbol_wise_position_report.dart';
import 'features/report/data/datasources/symbol_wise_pl/symbol_wise_position_report_remote_datasource.dart';
import 'features/report/data/repositories/symbol_wise_position_report_repository_impl.dart';
import 'features/report/presentation/bloc/symbol_wise_position_report/symbol_wise_position_report_bloc.dart';
import 'features/report/presentation/bloc/profit_and_loss_report/profit_and_loss_report_bloc.dart';
import 'features/report/domain/usecases/get_profit_and_loss_report.dart';
import 'features/report/domain/repositories/profit_and_loss_report_repository.dart';
import 'features/report/data/repositories/profit_and_loss_report_repository_impl.dart';
import 'features/report/data/datasources/profit_and_loss_report/profit_and_loss_report_remote_datasource.dart';
import 'features/report/presentation/bloc/user_script_position_tracking/user_script_position_tracking_bloc.dart';
import 'features/report/domain/usecases/get_user_script_position_tracking.dart';
import 'features/report/domain/repositories/user_script_position_tracking_repository.dart';
import 'features/report/data/repositories/user_script_position_tracking_repository_impl.dart';
import 'features/report/data/datasources/user_script_position_tracking/user_script_position_tracking_remote_datasource.dart';
import 'features/report/presentation/bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_bloc.dart';
import 'features/report/domain/usecases/get_user_wise_profit_and_loss_report.dart';
import 'features/report/domain/repositories/user_wise_profit_and_loss_repository.dart';
import 'features/report/data/repositories/user_wise_profit_and_loss_repository_impl.dart';
import 'features/report/data/datasources/user_wise_profit_and_loss/user_wise_profit_and_loss_remote_datasource.dart';
import 'features/report/presentation/bloc/symbol_wise_pl/symbol_wise_pl_bloc.dart';
import 'features/report/domain/usecases/symbol_wise_pl/get_symbol_wise_pl_report.dart';
import 'features/report/domain/repositories/symbol_wise_pl/symbol_wise_pl_repository.dart';
import 'features/report/data/repositories/symbol_wise_pl/symbol_wise_pl_repository_impl.dart';
import 'features/report/data/datasources/symbol_wise_pl/symbol_wise_pl_remote_datasource.dart';
import 'features/report/presentation/bloc/symbol_wise_pl/trade_list/symbol_trade_list_bloc.dart';
import 'features/report/presentation/bloc/symbol_wise_pl/open_postion/symbol_open_position_bloc.dart';
import 'features/report/presentation/bloc/exchange_wise_pl/exchange_wise_pl_bloc.dart';
import 'features/report/domain/usecases/exchange_wise_pl/get_exchange_wise_pl_report.dart';
import 'features/report/domain/repositories/exchange_wise_pl/exchange_wise_pl_repository.dart';
import 'features/report/data/repositories/exchange_wise_pl/exchange_wise_pl_repository_impl.dart';
import 'features/report/data/datasources/exchange_wise_pl/exchange_wise_pl_remote_datasource.dart';
import 'features/report/presentation/bloc/bill_generate/bill_generate_bloc.dart';
import 'features/report/domain/usecases/get_bill_generate_report.dart';
import 'features/report/domain/repositories/bill_generate_repository.dart';
import 'features/report/data/repositories/bill_generate_repository_impl.dart';
import 'features/report/data/datasources/bill_generate_remote_datasource.dart';
import 'features/report/presentation/bloc/settlement_report/settlement_report_bloc.dart';
import 'features/report/domain/usecases/get_settlement_report.dart';
import 'features/report/domain/repositories/settlement_report_repository.dart';
import 'features/report/data/repositories/settlement_report_repository_impl.dart';
import 'features/report/data/datasources/settlement_report_remote_datasource.dart';
import 'features/report/presentation/bloc/settlement_sharing_report/settlement_sharing_report_bloc.dart';
import 'features/report/domain/usecases/get_settlement_sharing_report.dart';
import 'features/report/domain/repositories/settlement_sharing_report_repository.dart';
import 'features/report/data/repositories/settlement_sharing_report_repository_impl.dart';
import 'features/report/data/datasources/settlement_sharing_report_remote_datasource.dart';
import 'features/report/presentation/bloc/users_bill_summary/users_bill_summary_bloc.dart';
import 'features/report/domain/usecases/users_bill_summary/get_users.dart'
    as bill_summary_users;
import 'features/report/domain/usecases/users_bill_summary/get_bill_summary_data.dart';
import 'features/report/domain/repositories/users_bill_summary/users_bill_summary_repository.dart';
import 'features/report/data/repositories/users_bill_summary/users_bill_summary_repository_impl.dart';
import 'features/report/data/datasources/users_bill_summary/users_bill_summary_remote_data_source.dart';
import 'features/tools/data/datasources/message_remote_datasource.dart';
import 'features/tools/data/repositories/message_repository_impl.dart';
import 'features/tools/domain/repositories/message_repository.dart';
import 'features/tools/domain/usecases/get_messages_usecase.dart';
import 'features/tools/presentation/bloc/message/message_bloc.dart';
import 'features/tools/data/datasources/announcement_remote_datasource.dart';
import 'features/tools/data/repositories/announcement_repository_impl.dart';
import 'features/tools/domain/repositories/announcement_repository.dart';
import 'features/tools/domain/usecases/get_announcements_usecase.dart';
import 'features/tools/presentation/bloc/announcement/announcement_bloc.dart';
import 'features/tools/data/datasources/rules_remote_datasource.dart';
import 'features/tools/data/repositories/rules_repository_impl.dart';
import 'features/tools/domain/repositories/rules_repository.dart';
import 'features/tools/domain/usecases/get_rules_usecase.dart';
import 'features/tools/presentation/bloc/rules/rules_bloc.dart';
import 'features/tools/presentation/bloc/market_timing/market_timing_bloc.dart';
import 'features/tools/domain/usecases/get_market_timing_usecase.dart';
import 'features/tools/domain/repositories/market_timing_repository.dart';
import 'features/tools/data/repositories/market_timing_repository_impl.dart';
import 'features/tools/data/datasources/market_timing_remote_datasource.dart';
import 'features/tools/data/datasources/total_volume_remote_datasource.dart';
import 'features/tools/data/repositories/total_volume_repository_impl.dart';
import 'features/tools/domain/repositories/total_volume_repository.dart';
import 'features/tools/domain/usecases/get_total_volume_usecase.dart';
import 'features/tools/presentation/bloc/total_volume/total_volume_bloc.dart';
import 'features/tools/presentation/bloc/shortcuts/shortcuts_bloc.dart';
import 'features/tools/domain/usecases/get_shortcuts_usecase.dart';
import 'features/tools/domain/repositories/shortcuts_repository.dart';
import 'features/tools/data/repositories/shortcuts_repository_impl.dart';
import 'features/tools/data/datasources/shortcuts_remote_datasource.dart';
import 'features/operations/presentation/bloc/group/group_bloc.dart';
import 'features/view/presentation/bloc/brokerage/brokerage_bloc.dart';
import 'features/view/domain/repositories/brokerage/brokerage_repository.dart';
import 'features/view/data/repositories/brokerage/brokerage_repository_impl.dart';
import 'features/view/data/datasources/brokerage/brokerage_remote_datasource.dart';
import 'features/operations/presentation/bloc/settlement_master_sharing/settlement_master_sharing_bloc.dart';
import 'features/operations/domain/usecases/get_settlement_master_sharing.dart';
import 'features/operations/domain/repositories/settlement_master_sharing_repository.dart';
import 'features/operations/data/repositories/settlement_master_sharing_repository_impl.dart';
import 'features/operations/data/datasources/settlement_master_sharing_datasource.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton(() => ApiClient());
  sl.registerFactory(() => AuthBloc(loginUser: sl()));
  sl.registerFactory(() => UserFormBloc());
  sl.registerLazySingleton(() => LoginUser(repository: sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => MarketWatchBloc(
      getMarketItems: sl(),
      addMarketItem: sl(),
      deleteMarketItem: sl(),
    ),
  );
  sl.registerLazySingleton(() => ThemeBloc());
  sl.registerLazySingleton(() => WatchlistBloc());
  sl.registerLazySingleton(() => ArrangeSymbolBloc());
  sl.registerLazySingleton(() => SymbolFontBloc());
  sl.registerLazySingleton(() => OrderDialogBloc());
  sl.registerLazySingleton(() => MarketDepthBloc());
  sl.registerLazySingleton(() => GetMarketItems(sl()));
  sl.registerLazySingleton(() => AddMarketItem(sl()));
  sl.registerLazySingleton(() => DeleteMarketItem(sl()));
  sl.registerLazySingleton<MarketWatchRepository>(
    () => MarketWatchRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<MarketWatchLocalDataSource>(
    () => MarketWatchLocalDataSourceImpl(),
  );
  sl.registerFactory(() => DashboardBloc(repository: sl()));
  sl.registerLazySingleton(() => GetDashboardDataUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTradeReportsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetSymbolReportsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetDashboardSummaryUseCase(repository: sl()));
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<DashboardDataSource>(() => DashboardDataSource());
  sl.registerFactory(
    () => PendingOrdersBloc(
      getPendingOrders: sl(),
      getPendingOrdersWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getOrderTypes: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetPendingOrders(sl()));
  sl.registerLazySingleton(() => GetPendingOrdersWithFilters(sl()));
  sl.registerLazySingleton(() => GetClients(sl()));
  sl.registerLazySingleton(() => GetExchanges(sl()));
  sl.registerLazySingleton(() => GetSymbols(sl()));
  sl.registerLazySingleton(() => GetOrderTypes(sl()));
  sl.registerLazySingleton(() => ExportToPdf(sl()));
  sl.registerLazySingleton(() => ExportToExcel(sl()));
  sl.registerLazySingleton<PendingOrdersRepository>(
    () => PendingOrdersRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PendingOrdersRemoteDataSource>(
    () => PendingOrdersRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => TradesBloc(
      getTrades: sl(),
      getTradesWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getOrderTypes: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetTrades(sl()));
  sl.registerLazySingleton(() => GetTradesWithFilters(sl()));
  sl.registerLazySingleton(() => GetTradesClients(sl()));
  sl.registerLazySingleton(() => GetTradesExchanges(sl()));
  sl.registerLazySingleton(() => GetTradesSymbols(sl()));
  sl.registerLazySingleton(() => GetTradesOrderTypes(sl()));
  sl.registerLazySingleton(() => ExportTradesToPdf(sl()));
  sl.registerLazySingleton(() => ExportTradesToExcel(sl()));
  sl.registerLazySingleton<TradesRepository>(
    () => TradesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TradesRemoteDataSource>(
    () => TradesRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => DealsBloc(
      getDeals: sl(),
      getDealsWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getOrderTypes: sl(),
      getStatuses: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetDeals(sl()));
  sl.registerLazySingleton(() => GetDealsWithFilters(sl()));
  sl.registerLazySingleton(() => GetDealsClients(sl()));
  sl.registerLazySingleton(() => GetDealsExchanges(sl()));
  sl.registerLazySingleton(() => GetDealsSymbols(sl()));
  sl.registerLazySingleton(() => GetDealsOrderTypes(sl()));
  sl.registerLazySingleton(() => GetDealsStatuses(sl()));
  sl.registerLazySingleton(() => ExportDealsToPdf(sl()));
  sl.registerLazySingleton(() => ExportDealsToExcel(sl()));
  sl.registerLazySingleton<DealsRepository>(
    () => DealsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DealsRemoteDataSource>(
    () => DealsRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => NetPositionBloc(
      getNetPositions: sl(),
      getNetPositionsWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getUserTypes: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
      getPositionDetails: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetNetPositions(sl()));
  sl.registerLazySingleton(() => GetNetPositionsWithFilters(sl()));
  sl.registerLazySingleton(() => GetNetPositionClients(sl()));
  sl.registerLazySingleton(() => GetNetPositionExchanges(sl()));
  sl.registerLazySingleton(() => GetNetPositionSymbols(sl()));
  sl.registerLazySingleton(() => GetNetPositionUserTypes(sl()));
  sl.registerLazySingleton(() => ExportNetPositionsToPdf(sl()));
  sl.registerLazySingleton(() => ExportNetPositionsToExcel(sl()));
  sl.registerLazySingleton(() => GetPositionDetails(sl()));
  sl.registerLazySingleton<NetPositionRepository>(
    () => NetPositionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NetPositionRemoteDataSource>(
    () => NetPositionRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => RejectionLogBloc(
      getRejectionLogs: sl(),
      getRejectionLogsWithFilters: sl(),
      getClients: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetRejectionLogs(sl()));
  sl.registerLazySingleton(() => GetRejectionLogsWithFilters(sl()));
  sl.registerLazySingleton(() => GetRejectionLogClients(sl()));
  sl.registerLazySingleton(() => GetRejectionLogExchanges(sl()));
  sl.registerLazySingleton(() => GetRejectionLogSymbols(sl()));
  sl.registerLazySingleton(() => ExportRejectionLogsToPdf(sl()));
  sl.registerLazySingleton(() => ExportRejectionLogsToExcel(sl()));
  sl.registerLazySingleton<RejectionLogRepository>(
    () => RejectionLogRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RejectionLogRemoteDataSource>(
    () => RejectionLogRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => DeletedTradeBloc(
      getDeletedTrades: sl(),
      getDeletedTradesWithFilters: sl(),
      getUserTypes: sl(),
      getUsers: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetDeletedTrades(sl()));
  sl.registerLazySingleton(() => GetDeletedTradesWithFilters(sl()));
  sl.registerLazySingleton(() => GetDeletedTradeUserTypes(sl()));
  sl.registerLazySingleton(() => GetDeletedTradeUsers(sl()));
  sl.registerLazySingleton(() => GetDeletedTradeExchanges(sl()));
  sl.registerLazySingleton(() => GetDeletedTradeSymbols(sl()));
  sl.registerLazySingleton(() => ExportDeletedTradesToPdf(sl()));
  sl.registerLazySingleton(() => ExportDeletedTradesToExcel(sl()));
  sl.registerLazySingleton<DeletedTradeRepository>(
    () => DeletedTradeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DeletedTradeRemoteDataSource>(
    () => DeletedTradeRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => RejectedTradeBloc(
      getRejectedTrades: sl(),
      getRejectedTradesWithFilters: sl(),
      getUserTypes: sl(),
      getUsers: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetRejectedTrades(sl()));
  sl.registerLazySingleton(() => GetRejectedTradesWithFilters(sl()));
  sl.registerLazySingleton(() => GetRejectedTradeUserTypes(sl()));
  sl.registerLazySingleton(() => GetRejectedTradeUsers(sl()));
  sl.registerLazySingleton(() => GetRejectedTradeExchanges(sl()));
  sl.registerLazySingleton(() => GetRejectedTradeSymbols(sl()));
  sl.registerLazySingleton(() => ExportRejectedTradesToPdf(sl()));
  sl.registerLazySingleton(() => ExportRejectedTradesToExcel(sl()));
  sl.registerLazySingleton<RejectedTradeRepository>(
    () => RejectedTradeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RejectedTradeRemoteDataSource>(
    () => RejectedTradeRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => LoginHistoryBloc(
      getLoginHistory: sl(),
      getClients: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetLoginHistory(sl()));
  sl.registerLazySingleton(() => GetLoginHistoryClients(sl()));
  sl.registerLazySingleton(() => ExportLoginHistoryToPdf(sl()));
  sl.registerLazySingleton(() => ExportLoginHistoryToExcel(sl()));
  sl.registerLazySingleton<LoginHistoryRepository>(
    () => LoginHistoryRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LoginHistoryRemoteDataSource>(
    () => LoginHistoryRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => ScriptMasterBloc(
      getScriptMasters: sl(),
      getScriptMastersWithFilters: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetScriptMasters(sl()));
  sl.registerLazySingleton(() => GetScriptMastersWithFilters(sl()));
  sl.registerLazySingleton(() => GetScriptMasterExchanges(sl()));
  sl.registerLazySingleton(() => GetScriptMasterSymbols(sl()));
  sl.registerLazySingleton(() => ExportScriptMastersToPdf(sl()));
  sl.registerLazySingleton(() => ExportScriptMastersToExcel(sl()));
  sl.registerLazySingleton<ScriptMasterRepository>(
    () => ScriptMasterRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ScriptMasterRemoteDataSource>(
    () => ScriptMasterRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => ScriptQuantityBloc(
      getExchanges: sl(),
      getGroups: sl(),
      getScriptQuantities: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetScriptQuantityExchanges(sl()));
  sl.registerLazySingleton(() => GetScriptQuantityGroups(sl()));
  sl.registerLazySingleton(() => GetScriptQuantities(sl()));
  sl.registerLazySingleton<ScriptQuantityRepository>(
    () => ScriptQuantityRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ScriptQuantityRemoteDataSource>(
    () => ScriptQuantityRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(
    () => IntradayHistoryBloc(
      getIntradayHistory: sl(),
      getIntradayHistoryInSeconds: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
      getTimings: sl(),
      exportToPdf: sl(),
      exportToExcel: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetIntradayHistory(sl()));
  sl.registerLazySingleton(() => GetIntradayHistoryInSeconds(sl()));
  sl.registerLazySingleton(() => GetIntradayExchanges(sl()));
  sl.registerLazySingleton(() => GetIntradaySymbols(sl()));
  sl.registerLazySingleton(() => GetIntradayTimings(sl()));
  sl.registerLazySingleton(() => GetAvailableTimeSlots(sl()));
  sl.registerLazySingleton(() => ExportIntradayToPdf(sl()));
  sl.registerLazySingleton(() => ExportIntradayToExcel(sl()));
  sl.registerLazySingleton<IntradayHistoryRepository>(
    () => IntradayHistoryRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<IntradayHistoryRemoteDataSource>(
    () => IntradayHistoryRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(() => BrokerListBloc(repository: sl()));
  sl.registerLazySingleton<BrokerRepository>(
    () => BrokerRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BrokerRemoteDataSource>(
    () => BrokerRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => ClientBreakdownBloc(getClientBreakdown: sl()));
  sl.registerLazySingleton(() => GetClientBreakdown(sl()));
  sl.registerLazySingleton<ClientBreakdownRepository>(
    () => ClientBreakdownRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ClientBreakdownRemoteDataSource>(
    () => ClientBreakdownRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => BrokerageBloc(repository: sl()));
  sl.registerLazySingleton<BrokerageRepository>(
    () => BrokerageRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<BrokerageRemoteDataSource>(
    () => BrokerageRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => UserListBloc(
      getUsers: sl(),
      getUsersWithFilters: sl(),
      getUserTypes: sl(),
      getUserStatuses: sl(),
      exportUsersToPdf: sl(),
      exportUsersToExcel: sl(),
    ),
  );
  sl.registerFactory(
    () => InactiveUserListBloc(
      getUsers: sl(),
      getUsersWithFilters: sl(),
      getUserTypes: sl(),
      getUserStatuses: sl(),
      exportUsersToPdf: sl(),
      exportUsersToExcel: sl(),
    ),
  );
  sl.registerFactory(() => SearchUserBloc(getUsers: sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUsersWithFilters(sl()));
  sl.registerLazySingleton(() => GetUserTypes(sl()));
  sl.registerLazySingleton(() => GetUserStatuses(sl()));
  sl.registerLazySingleton(() => ExportUsersToPdf(sl()));
  sl.registerLazySingleton(() => ExportUsersToExcel(sl()));
  sl.registerFactory(
    () => UserTradesBloc(getUserTrades: sl(), getUserTradesMetadata: sl()),
  );
  sl.registerLazySingleton(() => GetUserTrades(sl()));
  sl.registerLazySingleton(() => GetUserTradesMetadata(sl()));
  sl.registerLazySingleton<UserTradesRepository>(
    () => UserTradesRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserTradesDataSource>(
    () => UserTradesDataSourceImpl(),
  );
  sl.registerFactory(
    () => UserPositionBloc(
      getUserPositions: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetUserPositions(sl()));
  sl.registerLazySingleton<UserPositionRepository>(
    () => UserPositionRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserPositionDataSource>(
    () => UserPositionDataSourceImpl(),
  );
  sl.registerFactory(
    () => UserBrokerageBloc(
      getUserBrokerageSettings: sl(),
      updateBrokerageSettings: sl(),
      getExchanges: sl(),
      getSymbols: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetUserBrokerageSettings(sl()));
  sl.registerLazySingleton(() => UpdateBrokerageSettings(sl()));
  sl.registerLazySingleton(() => user_exchanges.GetExchanges(sl()));
  sl.registerLazySingleton(() => user_symbols.GetSymbols(sl()));
  sl.registerLazySingleton<UserBrokerageSettingRepository>(
    () => UserBrokerageSettingRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserBrokerageSettingDataSource>(
    () => UserBrokerageSettingDataSourceImpl(),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(() => UserCreditBloc(getUserCredit: sl()));
  sl.registerFactory(() => UserGroupSettingsBloc(getUserGroupSettings: sl()));
  sl.registerFactory(() => UserIntradayBloc(getUserIntradaySquareOff: sl()));
  sl.registerFactory(() => NestedUsersBloc(getNestedUsers: sl()));
  sl.registerLazySingleton(() => GetNestedUsers(sl()));
  sl.registerFactory(
    () => UserPendingOrderBloc(
      getUserPendingOrders: sl(),
      getUserPendingOrderMetadata: sl(),
    ),
  );
  sl.registerFactory(
    () => UserQuantitySettingsBloc(
      getUserQuantitySettings: sl(),
      getUserQuantitySettingsMetadata: sl(),
    ),
  );
  sl.registerFactory(
    () => UserRejectionLogBloc(
      getUserRejectionLog: sl(),
      getUserRejectionLogMetadata: sl(),
    ),
  );
  sl.registerFactory(() => TradeLogBloc(getTradeLogs: sl()));
  sl.registerFactory(() => TradeMarginBloc(getTradeMargins: sl()));
  sl.registerLazySingleton(() => GetTradeLogsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTradeMarginsUseCase(repository: sl()));
  sl.registerFactory(() => UserSharingBloc(getUserSharingDetails: sl()));
  sl.registerFactory(
    () => UserTradeMarginBloc(
      getUserTradeMargin: sl(),
      getUserTradeMarginMetadata: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetUserCredit(sl()));
  sl.registerLazySingleton(() => GetUserGroupSettings(sl()));
  sl.registerLazySingleton(() => GetUserIntradaySquareOff(sl()));
  sl.registerLazySingleton<UserCreditDataSource>(
    () => UserCreditDataSourceImpl(),
  );
  sl.registerLazySingleton<UserGroupSettingsDataSource>(
    () => UserGroupSettingsDataSourceImpl(),
  );
  sl.registerLazySingleton<UserIntradaySquareOffDataSource>(
    () => UserIntradaySquareOffDataSourceImpl(),
  );
  sl.registerLazySingleton<UserCreditRepository>(
    () => UserCreditRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserGroupSettingsRepository>(
    () => UserGroupSettingsRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserIntradaySquareOffRepository>(
    () => UserIntradaySquareOffRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => GetUserPendingOrders(sl()));
  sl.registerLazySingleton(() => GetUserPendingOrderMetadata(sl()));
  sl.registerLazySingleton(() => GetUserQuantitySettings(sl()));
  sl.registerLazySingleton(() => GetUserQuantitySettingsMetadata(sl()));
  sl.registerLazySingleton(() => GetUserRejectionLog(sl()));
  sl.registerLazySingleton(() => GetUserRejectionLogMetadata(sl()));
  sl.registerLazySingleton(() => GetUserSharingDetails(sl()));
  sl.registerLazySingleton(() => GetUserTradeMargin(sl()));
  sl.registerLazySingleton(() => GetUserTradeMarginMetadata(sl()));
  sl.registerLazySingleton<UserPendingOrderDataSource>(
    () => UserPendingOrderDataSourceImpl(),
  );
  sl.registerLazySingleton<UserQuantitySettingsDataSource>(
    () => UserQuantitySettingsDataSourceImpl(),
  );
  sl.registerLazySingleton<UserRejectionLogDataSource>(
    () => UserRejectionLogDataSourceImpl(),
  );
  sl.registerLazySingleton<TradeLogRemoteDataSource>(
    () => TradeLogRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<TradeMarginRemoteDataSource>(
    () => TradeMarginRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<UserSharingDetailsDataSource>(
    () => UserSharingDetailsDataSourceImpl(),
  );
  sl.registerLazySingleton<UserTradeMarginDataSource>(
    () => UserTradeMarginDataSourceImpl(),
  );
  sl.registerLazySingleton<UserPendingOrderRepository>(
    () => UserPendingOrderRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserQuantitySettingsRepository>(
    () => UserQuantitySettingsRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserRejectionLogRepository>(
    () => UserRejectionLogRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<TradeLogRepository>(
    () => TradeLogRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TradeMarginRepository>(
    () => TradeMarginRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserSharingDetailsRepository>(
    () => UserSharingDetailsRepositoryImpl(dataSource: sl()),
  );
  sl.registerFactory(() => CreditHistoryBloc(getCreditHistory: sl()));
  sl.registerLazySingleton(() => GetCreditHistoryUseCase(repository: sl()));
  sl.registerLazySingleton<CreditHistoryRepository>(
    () => CreditHistoryRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CreditHistoryRemoteDataSource>(
    () => CreditHistoryRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => ActivityReportBloc(getActivityReport: sl()));
  sl.registerLazySingleton(() => GetActivityReportUseCase(repository: sl()));
  sl.registerLazySingleton<ActivityReportRepository>(
    () => ActivityReportRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<ActivityReportRemoteDataSource>(
    () => ActivityReportRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => BackOfficeActivityReportBloc(getBackOfficeActivityReport: sl()),
  );
  sl.registerLazySingleton(
    () => GetBackOfficeActivityReportUseCase(repository: sl()),
  );
  sl.registerLazySingleton<BackOfficeActivityReportRepository>(
    () => BackOfficeActivityReportRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<BackOfficeActivityReportRemoteDataSource>(
    () => BackOfficeActivityReportRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => SymbolWisePositionReportBloc(getSymbolWisePositionReport: sl()),
  );
  sl.registerLazySingleton(
    () => GetSymbolWisePositionReportUseCase(repository: sl()),
  );
  sl.registerLazySingleton<SymbolWisePositionReportRepository>(
    () => SymbolWisePositionReportRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<SymbolWisePositionReportRemoteDataSource>(
    () => SymbolWisePositionReportRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<UserTradeMarginRepository>(
    () => UserTradeMarginRepositoryImpl(dataSource: sl()),
  );
  sl.registerFactory(
    () => ProfitAndLossReportBloc(getProfitAndLossReport: sl()),
  );
  sl.registerLazySingleton(
    () => GetProfitAndLossReportUseCase(repository: sl()),
  );
  sl.registerLazySingleton<ProfitAndLossReportRepository>(
    () => ProfitAndLossReportRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<ProfitAndLossReportRemoteDataSource>(
    () => ProfitAndLossReportRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => UserScriptPositionTrackingBloc(
      getUserScriptPositionTracking: sl(),
      getExchanges: sl<user_exchanges.GetExchanges>(),
      getSymbols: sl<user_symbols.GetSymbols>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetUserScriptPositionTrackingUseCase(repository: sl()),
  );
  sl.registerLazySingleton<UserScriptPositionTrackingRepository>(
    () => UserScriptPositionTrackingRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserScriptPositionTrackingRemoteDataSource>(
    () => UserScriptPositionTrackingRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => UserWiseProfitAndLossBloc(getUserWiseProfitAndLossReport: sl()),
  );
  sl.registerLazySingleton(
    () => GetUserWiseProfitAndLossReportUseCase(repository: sl()),
  );
  sl.registerLazySingleton<UserWiseProfitAndLossRepository>(
    () => UserWiseProfitAndLossRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserWiseProfitAndLossRemoteDataSource>(
    () => UserWiseProfitAndLossRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => SymbolWisePLBloc(getSymbolWisePLReport: sl()));
  sl.registerLazySingleton(() => GetSymbolWisePLReport(sl()));
  sl.registerLazySingleton<SymbolWisePLRepository>(
    () => SymbolWisePLRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<SymbolWisePLRemoteDataSource>(
    () => SymbolWisePLRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => SymbolTradeListBloc(repository: sl()));
  sl.registerFactory(() => SymbolOpenPositionBloc(repository: sl()));
  sl.registerFactory(() => ExchangeWisePLBloc(getExchangeWisePLReport: sl()));
  sl.registerLazySingleton(() => GetExchangeWisePLReport(sl()));
  sl.registerLazySingleton<ExchangeWisePLRepository>(
    () => ExchangeWisePLRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<ExchangeWisePLRemoteDataSource>(
    () => ExchangeWisePLRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => BillGenerateBloc(getBillGenerateReport: sl()));
  sl.registerLazySingleton(() => GetBillGenerateReport(sl()));
  sl.registerLazySingleton<BillGenerateRepository>(
    () => BillGenerateRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BillGenerateRemoteDataSource>(
    () => BillGenerateRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => SettlementReportBloc(getSettlementReport: sl()));
  sl.registerLazySingleton(() => GetSettlementReport(sl()));
  sl.registerLazySingleton<SettlementReportRepository>(
    () => SettlementReportRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SettlementReportRemoteDataSource>(
    () => SettlementReportRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => SettlementSharingReportBloc(getSettlementSharingReport: sl()),
  );
  sl.registerLazySingleton(() => GetSettlementSharingReport(sl()));
  sl.registerLazySingleton<SettlementSharingReportRepository>(
    () => SettlementSharingReportRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SettlementSharingReportRemoteDataSource>(
    () => SettlementSharingReportRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => UsersBillSummaryBloc(getUsers: sl(), getBillSummaryData: sl()),
  );
  sl.registerLazySingleton(() => bill_summary_users.GetUsers(sl()));
  sl.registerLazySingleton(() => GetBillSummaryData(sl()));
  sl.registerLazySingleton<UsersBillSummaryRepository>(
    () => UsersBillSummaryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UsersBillSummaryRemoteDataSource>(
    () => UsersBillSummaryRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => MarketTimingBloc(getMarketTiming: sl()));
  sl.registerLazySingleton(() => GetMarketTimingUseCase(sl()));
  sl.registerLazySingleton<MarketTimingRepository>(
    () => MarketTimingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MarketTimingRemoteDataSource>(
    () => MarketTimingRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => AnnouncementBloc(getAnnouncements: sl()));
  sl.registerLazySingleton(() => GetAnnouncementsUseCase(repository: sl()));
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => MessageBloc(getMessages: sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(repository: sl()));
  sl.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => RulesBloc(getRules: sl()));
  sl.registerLazySingleton(() => GetRulesUseCase(repository: sl()));
  sl.registerLazySingleton<RulesRepository>(
    () => RulesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RulesRemoteDataSource>(
    () => RulesRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => ShortcutsBloc(getShortcuts: sl()));
  sl.registerLazySingleton(() => GetShortcutsUseCase(sl()));
  sl.registerLazySingleton<ShortcutsRepository>(
    () => ShortcutsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ShortcutsRemoteDataSource>(
    () => ShortcutsRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => TotalVolumeBloc(
      getTotalVolume: sl(),
      getExchanges: sl<user_exchanges.GetExchanges>(),
    ),
  );
  sl.registerLazySingleton(() => GetTotalVolumeUseCase(sl()));
  sl.registerLazySingleton<TotalVolumeRepository>(
    () => TotalVolumeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TotalVolumeRemoteDataSource>(
    () => TotalVolumeRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => OperationsMessageBloc());
  sl.registerFactory(
    () => ExchangeSettingsBloc(
      getExchangeSettings: sl(),
      updateExchangeSettings: sl(),
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetExchangeSettings(sl()));
  sl.registerLazySingleton(() => UpdateExchangeSettings(sl()));
  sl.registerLazySingleton<ExchangeSettingsRepository>(
    () => ExchangeSettingsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ExchangeSettingsRemoteDataSource>(
    () => ExchangeSettingsRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => GroupBloc(getGroups: sl(), addGroup: sl()));
  sl.registerLazySingleton(() => GetGroups(sl()));
  sl.registerLazySingleton(() => AddGroup(sl()));
  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => TradeSettingsBloc(getTradeSettings: sl(), updateTradeSettings: sl()),
  );
  sl.registerLazySingleton(() => GetTradeSettings(sl()));
  sl.registerLazySingleton(() => UpdateTradeSettings(sl()));
  sl.registerLazySingleton<TradeSettingsRepository>(
    () => TradeSettingsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TradeSettingsRemoteDataSource>(
    () => TradeSettingsRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => SettlementProgressBloc(
      importBhavCopy: sl(),
      submitBhavCopy: sl(),
      getSettlementData: sl(),
    ),
  );
  sl.registerLazySingleton(() => ImportBhavCopyUseCase(sl()));
  sl.registerLazySingleton(() => SubmitBhavCopyUseCase(sl()));
  sl.registerLazySingleton(() => GetSettlementDataUseCase(sl()));
  sl.registerLazySingleton<SettlementProgressRepository>(
    () => SettlementProgressRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SettlementProgressRemoteDataSource>(
    () => SettlementProgressRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => DateSettingsBloc(getDateSettings: sl(), updateDateSettings: sl()),
  );
  sl.registerLazySingleton(() => GetDateSettings(sl()));
  sl.registerLazySingleton(() => UpdateDateSettings(sl()));
  sl.registerLazySingleton<DateSettingsRepository>(
    () => DateSettingsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DateSettingsRemoteDataSource>(
    () => DateSettingsRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () =>
        ScriptSettingsBloc(getScriptSettings: sl(), updateScriptSettings: sl()),
  );
  sl.registerLazySingleton(() => GetScriptSettings(sl()));
  sl.registerLazySingleton(() => UpdateScriptSettings(sl()));
  sl.registerLazySingleton<ScriptSettingsRepository>(
    () => ScriptSettingsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ScriptSettingsRemoteDataSource>(
    () => ScriptSettingsRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => SurveillanceBloc(
      getSurveillanceData: sl(),
      updateSurveillanceData: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetSurveillanceData(sl()));
  sl.registerLazySingleton(() => UpdateSurveillanceData(sl()));
  sl.registerLazySingleton<SurveillanceRepository>(
    () => SurveillanceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SurveillanceRemoteDataSource>(
    () => SurveillanceRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => ServerBloc(
      getServers: sl(),
      updateServerStatus: sl(),
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetServers(sl()));
  sl.registerLazySingleton(() => UpdateServerStatus(sl()));
  sl.registerLazySingleton<ServerRepository>(
    () => ServerRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ServerRemoteDataSource>(
    () => ServerRemoteDataSourceImpl(),
  );
  sl.registerFactory(() => BillComparisonBloc(getBillComparisonData: sl()));
  sl.registerLazySingleton(() => GetBillComparisonData(sl()));
  sl.registerLazySingleton<BillComparisonRepository>(
    () => BillComparisonRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BillComparisonRemoteDataSource>(
    () => BillComparisonRemoteDataSourceImpl(),
  );
  sl.registerFactory(
    () => SettlementMasterSharingBloc(getSettlementMasterSharing: sl()),
  );
  sl.registerLazySingleton(() => GetSettlementMasterSharing(sl()));
  sl.registerLazySingleton<SettlementMasterSharingRepository>(
    () => SettlementMasterSharingRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<SettlementMasterSharingDataSource>(
    () => SettlementMasterSharingDataSourceImpl(),
  );
}
