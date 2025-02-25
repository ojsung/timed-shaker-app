import 'package:collection/collection.dart';
import 'package:macros/macros.dart';
import 'package:timed_shaker/core/utilities/macro_extension.dart';

macro class DefaultConstructorMacro implements ClassDeclarationsMacro {
  const DefaultConstructorMacro({Map<String?, Object?>? constructorDefaults, Map<String?, Object?>? superDefaults})
    : constructorDefaults = constructorDefaults ?? const {}, superDefaults = superDefaults ?? const {};
  final Map<String?, Object?> constructorDefaults;
  final Map<String?, Object?> superDefaults;
  @override
  Future<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
    final Iterable<FieldDeclaration> finalFields = (await builder.fieldsOf(clazz)).where((field) => field.hasFinal && !field.hasStatic);
    final Iterable<String> parameters = finalFields
      .map((field) => field.identifier.name);
    final defaultConstructor = await _buildConstructorDeclaration(clazz, parameters, builder);
    if (defaultConstructor != null) builder.declareInType(defaultConstructor);
  }
  Future<DeclarationCode?> _buildConstructorDeclaration(ClassDeclaration clazz, Iterable<String> parameters, MemberDeclarationBuilder builder) async {
    final String name = clazz.identifier.name;
    final ClassDeclaration? superClass = await builder.superClassOf(clazz);
    final Iterable<FieldDeclaration> fields = (await builder.fieldsOf(clazz)).whereNot((FieldDeclaration declaration) => declaration.hasStatic);
    if (fields.any((declaration) => declaration.type.checkNamed(builder) == null)) return null;

    ConstructorParams superConstructorParams = (positional: [], named: []);
    if (superClass != null) {
    final defaultSuperConstructor = await builder.defaultConstructorOf(superClass);
    if (defaultSuperConstructor == null) {
      builder.report(Diagnostic(DiagnosticMessage('Super class must have a default constructor', target: clazz.asDiagnosticTarget), Severity.error));
      return null;
    }
      superConstructorParams = await builder.constructorParamsOf(defaultSuperConstructor, superClass);
    }
    final List<({bool isRequired, String name, TypeAnnotation? type})> superParamList = [...superConstructorParams.positional, ...superConstructorParams.named];
    if (superParamList.any((param) => param.type?.checkNamed(builder) == null)) return null;
    final DeclarationCode declaration;
    if (fields.isEmpty && superParamList.isEmpty) {
      declaration = DeclarationCode.fromString('const $name();');
    } else {
    declaration = DeclarationCode.fromParts([
      'const $name({',
      for (final param in superParamList)
        ...[if (param.isRequired && !superDefaults.containsKey(param.name)) 'required ', param.type!.code, ' ', param.name, if(superDefaults.containsKey(param.name)) ' = ${superDefaults[param.name]}', ',\n'],
      for (final field in fields)
      ...[if (!field.type.isNullable && !constructorDefaults.containsKey(field.identifier.name)) 'required ', 'this.', field.identifier.name, if (constructorDefaults.containsKey(field.identifier.name)) ' = ${constructorDefaults[field.identifier.name]}' ,','],
      '})',
      if (superClass != null)
      ...[
        ' : super(',
        for (final param in superConstructorParams.positional)
        ...[param.name, ', '],
        for (final param in superConstructorParams.named)
        ...[param.name, ': ', param.name, ', '],
        ')',
      ],
      ';'
    ]);
    }
    return declaration;
  }
}