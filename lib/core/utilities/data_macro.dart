import 'package:equatable/equatable.dart';
import 'package:macros/macros.dart';
import 'package:timed_shaker/core/utilities/macro_extension.dart';

macro class Data implements ClassDeclarationsMacro, ClassDefinitionMacro {
  const Data();
  
  @override
  void buildDefinitionForClass(ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
    await Equatable().buildDefinitionForClass(clazz, builder);
  }
  
  @override
  void buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
    await Equatable().buildDeclarationsForClass(clazz, builder);
    final Iterable<FieldDeclaration> finalFields = (await builder.fieldsOf(clazz)).where((field) => field.hasFinal && !field.hasStatic);
    final Iterable<FieldDeclaration> allFields = await builder.allFieldsOf(clazz);
    final Iterable<String> parameters = finalFields
      .map((field) => field.identifier.name);
    final DeclarationCode constructorDeclaration = await _buildConstructorDeclaration(clazz, parameters);
    final DeclarationCode toStringMethodDeclaration = await _buildToStringMethod(clazz, parameters);
    final DeclarationCode? copyWithMethodDeclaration = await _buildCopyWithMethod(clazz, allFields);
    builder.declareInType(constructorDeclaration);
    builder.declareInType(toStringMethodDeclaration);
    if (copyWithMethodDeclaration != null) {
    builder.declareInType(copyWithMethodDeclaration);
    }
  }
  Future<DeclarationCode> _buildConstructorDeclaration(ClassDeclaration clazz, Iterable<String> parameters) async {
        final String name = clazz.identifier.name;
        final declaration = DeclarationCode.fromParts([
      'const $name({',
      for (final parameter in parameters)
        'required this.$parameter,',
      '});',
    ]);
    return declaration;
  }
  Future<DeclarationCode> _buildToStringMethod(ClassDeclaration clazz, Iterable<String> parameters) async {
    final String name = clazz.identifier.name;
    final declaration = DeclarationCode.fromParts([
      'String toString() => \'$name(',
      parameters.map((p) => '$p: \$$p').join(', '),
      ')\';',
    ]);
    return declaration;
  }
  Future<DeclarationCode?> _buildCopyWithMethod(ClassDeclaration clazz, Iterable<FieldDeclaration> allFields) async {
    final String name = clazz.identifier.name;
    if (allFields.any((field) => field.identifier.name == 'copyWith')) return null;
        final typedParameters = allFields.map((FieldDeclaration field) {
      final type = field.type.cast<NamedTypeAnnotation>().identifier.name;
      return [
      type, field.identifier.name,
    ];
    });
    if (allFields.isEmpty) return DeclarationCode.fromString('external ${clazz.identifier.name} Function() get copyWith;');
    
    final declaration = DeclarationCode.fromParts([
      'external $name Function${typedParameters.map((p) => '${p[0]}? ${p[1]}').join(', ')}}) {',
      'return $name(${typedParameters.map((typedPair) => '${typedPair[1]}: ${typedPair[1]} ?? this.${typedPair[1]}').join(', ')});'
       '}) get copyWith;'
    ]);
    return declaration;
  }
}