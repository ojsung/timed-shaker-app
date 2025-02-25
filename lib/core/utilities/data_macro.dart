import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:macros/macros.dart';
import 'package:timed_shaker/core/utilities/copy_with_macro.dart';
import 'package:timed_shaker/core/utilities/default_constructor_macro.dart';
import 'package:timed_shaker/core/utilities/stringable_macro.dart';

macro class Data implements ClassDeclarationsMacro, ClassDefinitionMacro {
  const Data({Map<String?, Object?>? constructorDefaults, Map<String?, Object?>? superDefaults})
    : constructorDefaults = constructorDefaults ?? const {}, superDefaults = superDefaults ?? const {};
  final Map<String?, Object?> constructorDefaults;
  final Map<String?, Object?> superDefaults;
  
  @override
  void buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
    await const Equatable().buildDeclarationsForClass(clazz, builder);
    await DefaultConstructorMacro(constructorDefaults: constructorDefaults, superDefaults: superDefaults).buildDeclarationsForClass(clazz, builder);
    await const Stringable().buildDeclarationsForClass(clazz, builder);
    await const Copyable().buildDeclarationsForClass(clazz, builder);
  }
  @override
  void buildDefinitionForClass(ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
    await const Equatable().buildDefinitionForClass(clazz, builder);
    await const Copyable().buildDefinitionForClass(clazz, builder);
  }
}
