// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentModel {

 int get id; String get name; String? get description; String? get code; int? get managerId; String? get managerName; int? get parentDepartmentId; String? get parentDepartmentName; double? get budget; String? get location; String? get contactEmail; String? get contactPhone;
/// Create a copy of DepartmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentModelCopyWith<DepartmentModel> get copyWith => _$DepartmentModelCopyWithImpl<DepartmentModel>(this as DepartmentModel, _$identity);

  /// Serializes this DepartmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.code, code) || other.code == code)&&(identical(other.managerId, managerId) || other.managerId == managerId)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.parentDepartmentId, parentDepartmentId) || other.parentDepartmentId == parentDepartmentId)&&(identical(other.parentDepartmentName, parentDepartmentName) || other.parentDepartmentName == parentDepartmentName)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.location, location) || other.location == location)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,code,managerId,managerName,parentDepartmentId,parentDepartmentName,budget,location,contactEmail,contactPhone);

@override
String toString() {
  return 'DepartmentModel(id: $id, name: $name, description: $description, code: $code, managerId: $managerId, managerName: $managerName, parentDepartmentId: $parentDepartmentId, parentDepartmentName: $parentDepartmentName, budget: $budget, location: $location, contactEmail: $contactEmail, contactPhone: $contactPhone)';
}


}

/// @nodoc
abstract mixin class $DepartmentModelCopyWith<$Res>  {
  factory $DepartmentModelCopyWith(DepartmentModel value, $Res Function(DepartmentModel) _then) = _$DepartmentModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, String? code, int? managerId, String? managerName, int? parentDepartmentId, String? parentDepartmentName, double? budget, String? location, String? contactEmail, String? contactPhone
});




}
/// @nodoc
class _$DepartmentModelCopyWithImpl<$Res>
    implements $DepartmentModelCopyWith<$Res> {
  _$DepartmentModelCopyWithImpl(this._self, this._then);

  final DepartmentModel _self;
  final $Res Function(DepartmentModel) _then;

/// Create a copy of DepartmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? code = freezed,Object? managerId = freezed,Object? managerName = freezed,Object? parentDepartmentId = freezed,Object? parentDepartmentName = freezed,Object? budget = freezed,Object? location = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,managerId: freezed == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as int?,managerName: freezed == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String?,parentDepartmentId: freezed == parentDepartmentId ? _self.parentDepartmentId : parentDepartmentId // ignore: cast_nullable_to_non_nullable
as int?,parentDepartmentName: freezed == parentDepartmentName ? _self.parentDepartmentName : parentDepartmentName // ignore: cast_nullable_to_non_nullable
as String?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentModel].
extension DepartmentModelPatterns on DepartmentModel {
@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentModel value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? code,  int? managerId,  String? managerName,  int? parentDepartmentId,  String? parentDepartmentName,  double? budget,  String? location,  String? contactEmail,  String? contactPhone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.code,_that.managerId,_that.managerName,_that.parentDepartmentId,_that.parentDepartmentName,_that.budget,_that.location,_that.contactEmail,_that.contactPhone);case _:
  return orElse();

}
}

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? code,  int? managerId,  String? managerName,  int? parentDepartmentId,  String? parentDepartmentName,  double? budget,  String? location,  String? contactEmail,  String? contactPhone)  $default,) {final _that = this;
switch (_that) {
case _DepartmentModel():
return $default(_that.id,_that.name,_that.description,_that.code,_that.managerId,_that.managerName,_that.parentDepartmentId,_that.parentDepartmentName,_that.budget,_that.location,_that.contactEmail,_that.contactPhone);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  String? code,  int? managerId,  String? managerName,  int? parentDepartmentId,  String? parentDepartmentName,  double? budget,  String? location,  String? contactEmail,  String? contactPhone)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.code,_that.managerId,_that.managerName,_that.parentDepartmentId,_that.parentDepartmentName,_that.budget,_that.location,_that.contactEmail,_that.contactPhone);case _:
  return null;

}
}

}

/// @nodoc

@jsonSerializable
class _DepartmentModel extends DepartmentModel {
  const _DepartmentModel({required this.id, required this.name, this.description, this.code, this.managerId, this.managerName, this.parentDepartmentId, this.parentDepartmentName, this.budget, this.location, this.contactEmail, this.contactPhone}): super._();
  factory _DepartmentModel.fromJson(Map<String, dynamic> json) => _$DepartmentModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  String? code;
@override final  int? managerId;
@override final  String? managerName;
@override final  int? parentDepartmentId;
@override final  String? parentDepartmentName;
@override final  double? budget;
@override final  String? location;
@override final  String? contactEmail;
@override final  String? contactPhone;

/// Create a copy of DepartmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentModelCopyWith<_DepartmentModel> get copyWith => __$DepartmentModelCopyWithImpl<_DepartmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.code, code) || other.code == code)&&(identical(other.managerId, managerId) || other.managerId == managerId)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.parentDepartmentId, parentDepartmentId) || other.parentDepartmentId == parentDepartmentId)&&(identical(other.parentDepartmentName, parentDepartmentName) || other.parentDepartmentName == parentDepartmentName)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.location, location) || other.location == location)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,code,managerId,managerName,parentDepartmentId,parentDepartmentName,budget,location,contactEmail,contactPhone);

@override
String toString() {
  return 'DepartmentModel(id: $id, name: $name, description: $description, code: $code, managerId: $managerId, managerName: $managerName, parentDepartmentId: $parentDepartmentId, parentDepartmentName: $parentDepartmentName, budget: $budget, location: $location, contactEmail: $contactEmail, contactPhone: $contactPhone)';
}


}

/// @nodoc
abstract mixin class _$DepartmentModelCopyWith<$Res> implements $DepartmentModelCopyWith<$Res> {
  factory _$DepartmentModelCopyWith(_DepartmentModel value, $Res Function(_DepartmentModel) _then) = __$DepartmentModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, String? code, int? managerId, String? managerName, int? parentDepartmentId, String? parentDepartmentName, double? budget, String? location, String? contactEmail, String? contactPhone
});




}
/// @nodoc
class __$DepartmentModelCopyWithImpl<$Res>
    implements _$DepartmentModelCopyWith<$Res> {
  __$DepartmentModelCopyWithImpl(this._self, this._then);

  final _DepartmentModel _self;
  final $Res Function(_DepartmentModel) _then;

/// Create a copy of DepartmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? code = freezed,Object? managerId = freezed,Object? managerName = freezed,Object? parentDepartmentId = freezed,Object? parentDepartmentName = freezed,Object? budget = freezed,Object? location = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,}) {
  return _then(_DepartmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,managerId: freezed == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as int?,managerName: freezed == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String?,parentDepartmentId: freezed == parentDepartmentId ? _self.parentDepartmentId : parentDepartmentId // ignore: cast_nullable_to_non_nullable
as int?,parentDepartmentName: freezed == parentDepartmentName ? _self.parentDepartmentName : parentDepartmentName // ignore: cast_nullable_to_non_nullable
as String?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
