// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DepartmentNotifier)
final departmentNotifierProvider = DepartmentNotifierProvider._();

final class DepartmentNotifierProvider
    extends $NotifierProvider<DepartmentNotifier, DepartmentState> {
  DepartmentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentNotifierHash();

  @$internal
  @override
  DepartmentNotifier create() => DepartmentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DepartmentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DepartmentState>(value),
    );
  }
}

String _$departmentNotifierHash() => r'b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1';

abstract class _$DepartmentNotifier extends $Notifier<DepartmentState> {
  DepartmentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DepartmentState, DepartmentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DepartmentState, DepartmentState>,
              DepartmentState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
