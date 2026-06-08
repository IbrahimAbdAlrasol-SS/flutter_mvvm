// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentState {

 List<DepartmentModel> get items; bool get isLoading; int get page; int get pageSize; int get totalCount; bool get isCreateOpen; bool get isEditOpen; DepartmentModel? get selected; String get nameFilter;
/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentStateCopyWith<DepartmentState> get copyWith => _$DepartmentStateCopyWithImpl<DepartmentState>(this as DepartmentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.isCreateOpen, isCreateOpen) || other.isCreateOpen == isCreateOpen)&&(identical(other.isEditOpen, isEditOpen) || other.isEditOpen == isEditOpen)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.nameFilter, nameFilter) || other.nameFilter == nameFilter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),isLoading,page,pageSize,totalCount,isCreateOpen,isEditOpen,selected,nameFilter);

@override
String toString() {
  return 'DepartmentState(items: $items, isLoading: $isLoading, page: $page, pageSize: $pageSize, totalCount: $totalCount, isCreateOpen: $isCreateOpen, isEditOpen: $isEditOpen, selected: $selected, nameFilter: $nameFilter)';
}


}

/// @nodoc
abstract mixin class $DepartmentStateCopyWith<$Res>  {
  factory $DepartmentStateCopyWith(DepartmentState value, $Res Function(DepartmentState) _then) = _$DepartmentStateCopyWithImpl;
@useResult
$Res call({
 List<DepartmentModel> items, bool isLoading, int page, int pageSize, int totalCount, bool isCreateOpen, bool isEditOpen, DepartmentModel? selected, String nameFilter
});




}
/// @nodoc
class _$DepartmentStateCopyWithImpl<$Res>
    implements $DepartmentStateCopyWith<$Res> {
  _$DepartmentStateCopyWithImpl(this._self, this._then);

  final DepartmentState _self;
  final $Res Function(DepartmentState) _then;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? isLoading = null,Object? page = null,Object? pageSize = null,Object? totalCount = null,Object? isCreateOpen = null,Object? isEditOpen = null,Object? selected = freezed,Object? nameFilter = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DepartmentModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,isCreateOpen: null == isCreateOpen ? _self.isCreateOpen : isCreateOpen // ignore: cast_nullable_to_non_nullable
as bool,isEditOpen: null == isEditOpen ? _self.isEditOpen : isEditOpen // ignore: cast_nullable_to_non_nullable
as bool,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as DepartmentModel?,nameFilter: null == nameFilter ? _self.nameFilter : nameFilter // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentState].
extension DepartmentStatePatterns on DepartmentState {
@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentState value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentState value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentState() when $default != null:
return $default(_that);case _:
  return null;

}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DepartmentModel> items,  bool isLoading,  int page,  int pageSize,  int totalCount,  bool isCreateOpen,  bool isEditOpen,  DepartmentModel? selected,  String nameFilter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentState() when $default != null:
return $default(_that.items,_that.isLoading,_that.page,_that.pageSize,_that.totalCount,_that.isCreateOpen,_that.isEditOpen,_that.selected,_that.nameFilter);case _:
  return orElse();

}
}

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DepartmentModel> items,  bool isLoading,  int page,  int pageSize,  int totalCount,  bool isCreateOpen,  bool isEditOpen,  DepartmentModel? selected,  String nameFilter)  $default,) {final _that = this;
switch (_that) {
case _DepartmentState():
return $default(_that.items,_that.isLoading,_that.page,_that.pageSize,_that.totalCount,_that.isCreateOpen,_that.isEditOpen,_that.selected,_that.nameFilter);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DepartmentModel> items,  bool isLoading,  int page,  int pageSize,  int totalCount,  bool isCreateOpen,  bool isEditOpen,  DepartmentModel? selected,  String nameFilter)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentState() when $default != null:
return $default(_that.items,_that.isLoading,_that.page,_that.pageSize,_that.totalCount,_that.isCreateOpen,_that.isEditOpen,_that.selected,_that.nameFilter);case _:
  return null;

}
}

}

/// @nodoc

class _DepartmentState extends DepartmentState {
  const _DepartmentState({final  List<DepartmentModel> items = const [], this.isLoading = false, this.page = 1, this.pageSize = 10, this.totalCount = 0, this.isCreateOpen = false, this.isEditOpen = false, this.selected, this.nameFilter = ''}): _items = items, super._();

@override final  List<DepartmentModel> _items;
 @override List<DepartmentModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int totalCount;
@override@JsonKey() final  bool isCreateOpen;
@override@JsonKey() final  bool isEditOpen;
@override final  DepartmentModel? selected;
@override@JsonKey() final  String nameFilter;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentStateCopyWith<_DepartmentState> get copyWith => __$DepartmentStateCopyWithImpl<_DepartmentState>(this, _$identity);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.isCreateOpen, isCreateOpen) || other.isCreateOpen == isCreateOpen)&&(identical(other.isEditOpen, isEditOpen) || other.isEditOpen == isEditOpen)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.nameFilter, nameFilter) || other.nameFilter == nameFilter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isLoading,page,pageSize,totalCount,isCreateOpen,isEditOpen,selected,nameFilter);

@override
String toString() {
  return 'DepartmentState(items: $items, isLoading: $isLoading, page: $page, pageSize: $pageSize, totalCount: $totalCount, isCreateOpen: $isCreateOpen, isEditOpen: $isEditOpen, selected: $selected, nameFilter: $nameFilter)';
}


}

/// @nodoc
abstract mixin class _$DepartmentStateCopyWith<$Res> implements $DepartmentStateCopyWith<$Res> {
  factory _$DepartmentStateCopyWith(_DepartmentState value, $Res Function(_DepartmentState) _then) = __$DepartmentStateCopyWithImpl;
@override @useResult
$Res call({
 List<DepartmentModel> items, bool isLoading, int page, int pageSize, int totalCount, bool isCreateOpen, bool isEditOpen, DepartmentModel? selected, String nameFilter
});




}
/// @nodoc
class __$DepartmentStateCopyWithImpl<$Res>
    implements _$DepartmentStateCopyWith<$Res> {
  __$DepartmentStateCopyWithImpl(this._self, this._then);

  final _DepartmentState _self;
  final $Res Function(_DepartmentState) _then;

/// Create a copy of DepartmentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isLoading = null,Object? page = null,Object? pageSize = null,Object? totalCount = null,Object? isCreateOpen = null,Object? isEditOpen = null,Object? selected = freezed,Object? nameFilter = null,}) {
  return _then(_DepartmentState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DepartmentModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,isCreateOpen: null == isCreateOpen ? _self.isCreateOpen : isCreateOpen // ignore: cast_nullable_to_non_nullable
as bool,isEditOpen: null == isEditOpen ? _self.isEditOpen : isEditOpen // ignore: cast_nullable_to_non_nullable
as bool,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as DepartmentModel?,nameFilter: null == nameFilter ? _self.nameFilter : nameFilter // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
