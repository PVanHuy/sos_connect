import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/model/team/current_join_team_request_model.dart';
import 'package:sos_connect/model/team/join_team_request_model.dart';
import 'package:sos_connect/model/team/rescue_team_model.dart';
import 'package:sos_connect/model/team/team_member_model.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class ITeamRepository extends IBaseRepository {
  Future<Response> registerTeam(Map<String, String> params, {PostMedia? document});

  Future<Response> updateMyTeam(Map<String, String> params, {PostMedia? document});

  Future<Response> getMyTeam();

  Future<RescueTeamModel?> getTeamDetail(String teamId);

  Future<Response> joinTeamRequest({required String teamId, required String requestMessage});

  Future<PaginationModel<CurrentJoinTeamRequestModel>> getCurrentJoinRequests({int page = 1});

  Future<PaginationModel<JoinTeamRequestModel>> getPendingJoinRequests({int page = 1});

  Future<Response> respondJoinRequest({required String requestId, required String status, String? responseMessage});

  Future<PaginationModel<RescueTeamModel>> getTeams({int page = 1, String? province, String? name, String? sizeMember});

  Future<PaginationModel<TeamMemberModel>> getTeamMembers({int page = 1});

  Future<Response> kickTeamMember({required String memberId, required String reasonKicked});

  Future<UserModel?> getTeamUserInfo({String? userId});

  Future<Response> acceptSupport(String sosId);

  Future<PaginationModel<SosEventModel>> getAllSupport({String? status});
}
