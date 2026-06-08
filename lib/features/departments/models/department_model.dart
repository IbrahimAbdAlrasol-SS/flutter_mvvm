import 'package:app/data/models/_models.dart';

part 'department_model.freezed.dart';
part 'department_model.g.dart';

@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const DepartmentModel._();

  @jsonSerializable
  const factory DepartmentModel({
    required int id,
    required String name,
    String? description,
    String? code,
    int? managerId,
    String? managerName,
    int? parentDepartmentId,
    String? parentDepartmentName,
    double? budget,
    String? location,
    String? contactEmail,
    String? contactPhone,
  }) = _DepartmentModel;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
}
