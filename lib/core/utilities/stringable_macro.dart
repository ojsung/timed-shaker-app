import 'package:macros/macros.dart';
import 'package:timed_shaker/core/utilities/data_macro_statics.dart';
import 'package:timed_shaker/core/utilities/macro_extension.dart';

macro class Stringable implements ClassDeclarationsMacro {
  const Stringable();
  @override
  Future<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
    final Iterable<FieldDeclaration> finalFields = (await builder.fieldsOf(clazz)).where((field) => field.hasFinal && !field.hasStatic);
    final Iterable<String> parameters = finalFields
      .map((field) => field.identifier.name);
    final declaration = await _buildToStringMethod(clazz, parameters, builder);
    builder.declareInType(declaration);
  }
  Future<DeclarationCode> _buildToStringMethod(ClassDeclaration clazz, Iterable<String> parameters, MemberDeclarationBuilder builder) async {
    final String name = clazz.identifier.name;
    final NamedTypeAnnotationCode stringCode = await builder.codeFrom(dartCore, 'String');
    final declaration = DeclarationCode.fromParts([
      stringCode, ' toString() => \'$name(',
      parameters.map((p) => '$p: \$$p').join(', '),
      ')\';',
    ]);
    return declaration;
  }  
}