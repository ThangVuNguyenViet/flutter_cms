import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/cms_data_generator.dart';
import 'src/cms_field_generator.dart';

/// Creates a builder for generating CMS data and field configurations
Builder cmsBuilder(BuilderOptions options) =>
    PartBuilder([CmsFieldGenerator(), CmsConfigGenerator()], '.cms.g.dart');
