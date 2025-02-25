import 'package:collection/collection.dart';
import 'package:macros/macros.dart';
import 'package:timed_shaker/core/utilities/data_macro_statics.dart';
import 'package:timed_shaker/core/utilities/macro_extension.dart';

macro class Copyable implements ClassDeclarationsMacro, ClassDefinitionMacro {
  const Copyable();
  @override
  Future<void> buildDefinitionForClass(ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
    return await _buildCopyWithBody(clazz, builder);
    
  }
  @override
  Future<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
      await _buildCopyWithDeclaration(clazz, builder);
  }
}

Future<DeclarationCode?> _buildCopyWithDeclaration(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
    final String name = clazz.identifier.name;
    final Iterable<FieldDeclaration> allFields = await builder.fieldsOf(clazz);
      
    if (allFields.any((field) => field.identifier.name == 'copyWith')) return null;
      final typedParameters = allFields.map((FieldDeclaration field) {
        final type = field.type.cast<NamedTypeAnnotation>().identifier.name;
        return [
        type, field.identifier.name,
      ];
    });
    final DeclarationCode declaration;
    final DeclarationCode emptySignature = DeclarationCode.fromString('external $name Function() get copyWith;');
    if (allFields.isEmpty) {
      declaration = emptySignature;
    } else {
    final String signatureString = '(${typedParameters.map((paramPair) => '${paramPair[0]}? ${paramPair[1]}').join(', ')})';
    declaration = DeclarationCode.fromString('external $name Function$signatureString get copyWith;');
    }
    builder.declareInType(declaration);
    return declaration;
  }
  
  Future<void> _buildCopyWithBody(ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
    if (clazz.hasAbstract || clazz.hasSealed) return;
    final String name = clazz.identifier.name;
    final methods = await builder.methodsOf(clazz);
    final copyWithDeclaration = methods.firstWhereOrNull((MethodDeclaration declaration) => declaration.identifier.name == 'copyWith');
    if (copyWithDeclaration == null) {
      builder.report(Diagnostic(DiagnosticMessage('Class $name missing declaration for copyWith', target: clazz.asDiagnosticTarget), Severity.error));
      return; 
    }
    final FunctionDefinitionBuilder copyWithMethod = await builder.buildMethod(copyWithDeclaration.identifier);
    final String className = clazz.identifier.name;
    final CommentCode docComments = CommentCode.fromString('/// Create a copy of [$className] and replace zero or more fields');
    final ConstructorDeclaration? defaultConstructor = await builder.defaultConstructorOf(clazz);
    if (defaultConstructor == null) {
      builder.report(Diagnostic(DiagnosticMessage('Class $className must have a default constructor', target: clazz.asDiagnosticTarget), Severity.error));
      return;  
    }
    final positionalParams = defaultConstructor.positionalParameters;
    final namedParams = defaultConstructor.namedParameters;
    if (positionalParams.isEmpty && namedParams.isEmpty) {
      copyWithMethod.augment(FunctionBodyCode.fromParts(['=> ', className, '.new']), docComments: docComments);
      return;
    }
    List<FormalParameterDeclaration> params = [...positionalParams, ...namedParams];
    if (params.any((FormalParameterDeclaration param) => param.type.checkNamed(builder) == null)) {
      // We can skip a diagnostic message here as `checkNamed` will throw one for us
      return;
    }
    final (object, undefined) = await (
      builder.codeFrom(dartCore, 'Object'),
      builder.codeFrom(dataClassMacro, 'undefined'),
    ).wait;
    final body = FunctionBodyCode.fromParts([
      '=> ',
      '({\n',
      for (final param in params) ... [object, '? ', param.name, ' = ', undefined, ',\n'],
      '}) {',
      'return ', className, '(\n',
      for (final param in params)
      ...[param.name, ': ', param.name, ' == ', undefined, ' ? this.', param.name, ' : ', param.name, ' as ', param.type.code, ',\n'],
      ');',
      '};'
    ]);
    
    return copyWithMethod.augment(body, docComments: docComments);
  }