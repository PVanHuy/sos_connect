import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/model/team/current_join_team_request_model.dart';
import 'package:sos_connect/model/team/join_team_request_model.dart';
import 'package:sos_connect/model/team/rescue_team_model.dart';
import 'package:sos_connect/model/team/team_member_model.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';

class TeamRepository extends ITeamRepository {
  @override
  Future<Response> registerTeam(Map<String, String> params, {PostMedia? document}) async {
    try {
      if (document != null && document.file != null) {
        final multipartBody = [MultipartBody('document', document.file)];
        final result = await clientPostMultipartData(AppConstants.teamRegisterInformationsUri, params, multipartBody);
        return result;
      }

      final result = await clientPostData(AppConstants.teamRegisterInformationsUri, params);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updateMyTeam(Map<String, String> params, {PostMedia? document}) async {
    try {
      if (document != null && document.file != null) {
        final multipartBody = [MultipartBody('document', document.file)];
        return await clientPatchMultipartData(AppConstants.teamMyTeamUri, params, multipartBody);
      }

      return await clientPatchData(AppConstants.teamMyTeamUri, params);
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getMyTeam() async {
    try {
      final result = await clientGetData(AppConstants.teamMyTeamUri);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<RescueTeamModel?> getTeamDetail(String teamId) async {
    try {
      final result = await clientGetData('${AppConstants.teamDetailUri}/$teamId');
      if (!result.isOk) return null;

      final body = result.body;
      final raw = body is Map && body['data'] != null ? body['data'] : body;
      if (raw is! Map) return null;
      return RescueTeamModel.fromJson(Map<String, dynamic>.from(raw));
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> joinTeamRequest({required String teamId, required String requestMessage}) async {
    try {
      final result = await clientPostData(AppConstants.teamJoinRequestUri, {
        'team_id': teamId,
        'request_message': requestMessage,
      });
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<PaginationModel<CurrentJoinTeamRequestModel>> getCurrentJoinRequests({int page = 1}) async {
    try {
      final query = <String, String>{'page': page.toString(), 'limit': AppConstants.LIMIT.toString()};
      final response = await clientGetData(
        '${AppConstants.teamJoinRequestCurrentUri}?${Uri(queryParameters: query).query}',
      );

      if (response.isOk) {
        return PaginationModel.fromApi(response.body, CurrentJoinTeamRequestModel.fromJson);
      }

      return PaginationModel();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<PaginationModel<JoinTeamRequestModel>> getPendingJoinRequests({int page = 1}) async {
    try {
      final query = <String, String>{'page': page.toString(), 'limit': AppConstants.LIMIT.toString()};
      final response = await clientGetData(
        '${AppConstants.teamJoinRequestsPendingUri}?${Uri(queryParameters: query).query}',
      );

      if (response.isOk) {
        return PaginationModel.fromApi(response.body, JoinTeamRequestModel.fromJson);
      }

      return PaginationModel();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> respondJoinRequest({
    required String requestId,
    required String status,
    String? responseMessage,
  }) async {
    try {
      final result = await clientPostData(AppConstants.teamJoinRequestRespondUri(requestId), {
        'status': status,
        if (responseMessage != null && responseMessage.isNotEmpty) 'response_message': responseMessage,
      });
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<PaginationModel<RescueTeamModel>> getTeams({
    int page = 1,
    String? province,
    String? name,
    String? sizeMember,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(),
        'limit': AppConstants.LIMIT.toString(),
        if (province != null && province.isNotEmpty) 'province': province,
        if (name != null && name.isNotEmpty) 'name': name,
        if (sizeMember != null && sizeMember.isNotEmpty) 'size_member': sizeMember,
      };
      final response = await clientGetData('${AppConstants.teamListUri}?${Uri(queryParameters: query).query}');

      if (response.isOk) {
        return PaginationModel.fromApi(response.body, RescueTeamModel.fromJson);
      }

      return PaginationModel();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<PaginationModel<TeamMemberModel>> getTeamMembers({int page = 1}) async {
    try {
      final query = <String, String>{'page': page.toString(), 'limit': AppConstants.LIMIT.toString()};
      final response = await clientGetData('${AppConstants.teamMembersUri}?${Uri(queryParameters: query).query}');

      if (response.isOk) {
        return PaginationModel.fromApi(response.body, TeamMemberModel.fromJson);
      }

      return PaginationModel();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> kickTeamMember({required String memberId, required String reasonKicked}) async {
    try {
      return await clientPostData(AppConstants.teamMemberKickUri(memberId), {'reason_kicked': reasonKicked});
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<UserModel?> getTeamUserInfo({String? userId}) async {
    try {
      final id = userId?.trim() ?? '';
      final query = id.isEmpty ? '' : '?${Uri(queryParameters: {'userId': id}).query}';
      final result = await clientGetData('${AppConstants.teamUserInfoUri}$query');
      if (!result.isOk) return null;

      final body = result.body;
      final raw = body is Map && body['data'] != null
          ? body['data']
          : body is Map && body['user'] != null
          ? body['user']
          : body;
      if (raw is! Map) return null;
      return UserModel.fromJson(Map<String, dynamic>.from(raw));
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
