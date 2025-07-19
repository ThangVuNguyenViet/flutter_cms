import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/cms_data_generator.dart';

Builder cmsDataBuilder(BuilderOptions options) =>
    PartBuilder([CmsConfigGenerator()], '.cms.g.dart');
