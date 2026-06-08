import 'package:app/data/services/clients/_clients.dart';
import 'package:app/data/services/clients/callback.dart';
import 'package:app/features/departments/models/department_model.dart';

part 'department_client.g.dart';

@riverpod
DepartmentClient departmentClient(Ref ref) => DepartmentClient(ref.dio);

@RestApi()
abstract class DepartmentClient {
  factory DepartmentClient(Dio dio, {String baseUrl}) = _DepartmentClient;

  @GET('/departments')
  FuturePaginatedResponse<DepartmentModel> getDepartments(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize, {
    @Query('name') String? name,
  });

  @GET('/departments/{id}')
  FutureApiResponse<DepartmentModel> getDepartmentById(@Path('id') int id);

  @POST('/departments')
  FutureApiResponse<DepartmentModel> createDepartment(
    @Body() Map<String, dynamic> body,
  );

  @PUT('/departments/{id}')
  FutureApiResponse<DepartmentModel> updateDepartment(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/departments/{id}')
  Future<void> deleteDepartment(@Path('id') int id);
}
