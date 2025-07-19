import 'package:flutter_cms/models/fields.dart';
import 'package:flutter_cms/models/fields/array_field.dart';
import 'package:flutter_cms/models/fields/block_field.dart';
import 'package:flutter_cms/models/fields/boolean_field.dart';
import 'package:flutter_cms/models/fields/cross_dataset_reference_field.dart';
import 'package:flutter_cms/models/fields/date_field.dart';
import 'package:flutter_cms/models/fields/datetime_field.dart';
import 'package:flutter_cms/models/fields/file_field.dart';
import 'package:flutter_cms/models/fields/geopoint_field.dart';
import 'package:flutter_cms/models/fields/image_field.dart';
import 'package:flutter_cms/models/fields/number_field.dart';
import 'package:flutter_cms/models/fields/object_field.dart';
import 'package:flutter_cms/models/fields/reference_field.dart';
import 'package:flutter_cms/models/fields/slug_field.dart';
import 'package:flutter_cms/models/fields/string_field.dart';
import 'package:flutter_cms/models/fields/text_field.dart';
import 'package:flutter_cms/models/fields/url_field.dart';

class CmsFields {
  static CmsFieldConfig fromJson(Map<String, dynamic> json) {
    final String name = json['name'];
    final String title = json['title'];
    final String type = json['type'];
    final Map<String, dynamic>? options = json['options'];
    final String? description = json['description'];
    final List<dynamic>? of = json['of'];
    final dynamic to = json['to'];
    final String? validation = json['validation'];
    final int? rows = json['rows'];
    final String? dataset = json['dataset'];
    final List<dynamic>? fields = json['fields'];

    switch (type) {
      case 'string':
        return CmsStringFieldConfig(
          name: name,
          title: title,
          option: CmsStringOption(),
        );
      case 'slug':
        return CmsSlugFieldConfig(
          name: name,
          title: title,
          option: CmsSlugOption(
            source: options!['source'],
            maxLength: options['maxLength'],
          ),
        );
      case 'reference':
        return CmsReferenceFieldConfig(
          name: name,
          title: title,
          option: CmsReferenceOption(to: CmsReferenceTo(type: to['type'])),
        );
      case 'image':
        return CmsImageFieldConfig(
          name: name,
          title: title,
          option: CmsImageOption(hotspot: options!['hotspot']),
        );
      case 'array':
        return CmsArrayFieldConfig(
          name: name,
          title: title,
          option: CmsArrayOption(
            of:
                (of as List<dynamic>)
                    .map((item) => CmsArrayOf(type: item['type']))
                    .toList(),
          ),
        );
      case 'datetime':
        return CmsDateTimeFieldConfig(
          name: name,
          title: title,
          option: CmsDateTimeOption(),
        );
      case 'date':
        return CmsDateFieldConfig(name: name, title: title, option: CmsDateOption());
      case 'block':
        return CmsBlockFieldConfig(
          name: name,
          title: title,
          option: CmsBlockOption(),
        );
      case 'boolean':
        return CmsBooleanFieldConfig(
          name: name,
          title: title,
          option: CmsBooleanOption(),
        );
      case 'text':
        return CmsTextFieldConfig(
          name: name,
          title: title,
          option: CmsTextOption(rows: rows!),
        );
      case 'number':
        return CmsNumberFieldConfig(
          name: name,
          title: title,
          option: CmsNumberOption(validation: validation!),
        );
      case 'geopoint':
        return CmsGeopointFieldConfig(
          name: name,
          title: title,
          option: CmsGeopointOption(),
        );
      case 'file':
        return CmsFileFieldConfig(name: name, title: title, option: CmsFileOption());
      case 'object':
        return CmsObjectFieldConfig(
          name: name,
          title: title,
          option: CmsObjectOption(
            fields:
                (fields as List<dynamic>)
                    .map(
                      (field) => CmsObjectFieldDefinition(
                        name: field['name'],
                        title: field['title'],
                        type: field['type'],
                      ),
                    )
                    .toList(),
          ),
        );
      case 'crossDatasetReference':
        return CmsCrossDatasetReferenceFieldConfig(
          name: name,
          title: title,
          option: CmsCrossDatasetReferenceOption(
            dataset: dataset!,
            to:
                (to as List<dynamic>)
                    .map(
                      (item) => CmsCrossDatasetReferenceTo(
                        type: item['type'],
                        preview:
                            item['preview'] != null
                                ? CmsCrossDatasetReferencePreviewSelect(
                                  title: item['preview']['select']['title'],
                                  subtitle:
                                      item['preview']['select']['subtitle'],
                                  media: item['preview']['select']['media'],
                                )
                                : null,
                      ),
                    )
                    .toList(),
          ),
        );
      case 'url':
        return CmsUrlFieldConfig(name: name, title: title, option: CmsUrlOption());
      default:
        throw Exception('Unknown CMS field type: \$type');
    }
  }
}