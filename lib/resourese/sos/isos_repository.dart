import 'package:latlong2/latlong.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class ISosRepository extends IBaseRepository {
  Future<String?> convertLocation(LatLng point);
}
