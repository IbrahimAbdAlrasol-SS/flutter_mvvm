// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    _DepartmentModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      code: json['code'] as String?,
      managerId: (json['managerId'] as num?)?.toInt(),
      managerName: json['managerName'] as String?,
      parentDepartmentId: (json['parentDepartmentId'] as num?)?.toInt(),
      parentDepartmentName: json['parentDepartmentName'] as String?,
      budget: (json['budget'] as num?)?.toDouble(),
      location: json['location'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
    );

Map<String, dynamic> _$DepartmentModelToJson(_DepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'code': instance.code,
      'managerId': instance.managerId,
      'managerName': instance.managerName,
      'parentDepartmentId': instance.parentDepartmentId,
      'parentDepartmentName': instance.parentDepartmentName,
      'budget': instance.budget,
      'location': instance.location,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
    };
