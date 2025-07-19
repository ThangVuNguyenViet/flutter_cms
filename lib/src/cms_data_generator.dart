import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_cms/models/cms_annotations.dart';
import 'package:source_gen/source_gen.dart';
import 'package:pub_semver/pub_semver.dart';

class CmsConfigGenerator extends GeneratorForAnnotation<CmsConfig> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@CmsConfig` can only be used on classes.',
        element: element,
      );
    }

    final className = element.name;
    final generatedClassName = '${className}CmsConfig';

    final fields = element.fields.where((field) => !field.isStatic).map((field) {
      final fieldType = field.type.getDisplayString(withNullability: false);
      final typeChecker = TypeChecker.fromRuntime(CmsConfig);
      final fieldElement = field.type.element;
      String cmsDataType;
      if (fieldElement is ClassElement && typeChecker.hasAnnotationOfExact(fieldElement)) {
        cmsDataType = 'CmsData<${fieldType}CmsConfig>';
      } else {
        cmsDataType = 'CmsData<$fieldType>';
      }

      return Field((b) => b
        ..name = field.name
        ..modifier = FieldModifier.final$
        ..type = refer(cmsDataType));
    });

    final constructor = Constructor((b) => b
      ..optionalParameters.addAll(element.fields.where((field) => !field.isStatic).map((field) => Parameter((b) => b
        ..name = field.name
        ..toThis = true
        ..named = true
        ..required = true))));

    final generatedClass = Class((b) => b
      ..name = generatedClassName
      ..fields.addAll(fields)
      ..constructors.add(constructor));

    final emitter = DartEmitter();
    return DartFormatter(languageVersion: Version(3, 7, 0)).format('${generatedClass.accept(emitter)}');
  }
}