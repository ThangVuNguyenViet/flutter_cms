// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'home_screen_config.dart';

class HomeScreenConfigMapper extends ClassMapperBase<HomeScreenConfig> {
  HomeScreenConfigMapper._();

  static HomeScreenConfigMapper? _instance;
  static HomeScreenConfigMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = HomeScreenConfigMapper._());
      MapperContainer.globals.useAll([ColorMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'HomeScreenConfig';

  static String _$heroTitle(HomeScreenConfig v) => v.heroTitle;
  static const Field<HomeScreenConfig, String> _f$heroTitle = Field(
    'heroTitle',
    _$heroTitle,
  );
  static String _$heroSubtitle(HomeScreenConfig v) => v.heroSubtitle;
  static const Field<HomeScreenConfig, String> _f$heroSubtitle = Field(
    'heroSubtitle',
    _$heroSubtitle,
  );
  static String _$backgroundImageUrl(HomeScreenConfig v) =>
      v.backgroundImageUrl;
  static const Field<HomeScreenConfig, String> _f$backgroundImageUrl = Field(
    'backgroundImageUrl',
    _$backgroundImageUrl,
  );
  static bool _$enableDarkOverlay(HomeScreenConfig v) => v.enableDarkOverlay;
  static const Field<HomeScreenConfig, bool> _f$enableDarkOverlay = Field(
    'enableDarkOverlay',
    _$enableDarkOverlay,
  );
  static Color _$primaryColor(HomeScreenConfig v) => v.primaryColor;
  static const Field<HomeScreenConfig, Color> _f$primaryColor = Field(
    'primaryColor',
    _$primaryColor,
  );
  static List<String> _$featuredItems(HomeScreenConfig v) => v.featuredItems;
  static const Field<HomeScreenConfig, List<String>> _f$featuredItems = Field(
    'featuredItems',
    _$featuredItems,
  );
  static int _$maxFeaturedItems(HomeScreenConfig v) => v.maxFeaturedItems;
  static const Field<HomeScreenConfig, int> _f$maxFeaturedItems = Field(
    'maxFeaturedItems',
    _$maxFeaturedItems,
  );
  static DateTime _$lastUpdated(HomeScreenConfig v) => v.lastUpdated;
  static const Field<HomeScreenConfig, DateTime> _f$lastUpdated = Field(
    'lastUpdated',
    _$lastUpdated,
  );
  static String? _$externalLink(HomeScreenConfig v) => v.externalLink;
  static const Field<HomeScreenConfig, String> _f$externalLink = Field(
    'externalLink',
    _$externalLink,
    opt: true,
  );
  static bool _$showPromotionalBanner(HomeScreenConfig v) =>
      v.showPromotionalBanner;
  static const Field<HomeScreenConfig, bool> _f$showPromotionalBanner = Field(
    'showPromotionalBanner',
    _$showPromotionalBanner,
  );
  static String _$primaryButtonLabel(HomeScreenConfig v) =>
      v.primaryButtonLabel;
  static const Field<HomeScreenConfig, String> _f$primaryButtonLabel = Field(
    'primaryButtonLabel',
    _$primaryButtonLabel,
  );
  static String _$secondaryButtonLabel(HomeScreenConfig v) =>
      v.secondaryButtonLabel;
  static const Field<HomeScreenConfig, String> _f$secondaryButtonLabel = Field(
    'secondaryButtonLabel',
    _$secondaryButtonLabel,
  );
  static String _$layoutStyle(HomeScreenConfig v) => v.layoutStyle;
  static const Field<HomeScreenConfig, String> _f$layoutStyle = Field(
    'layoutStyle',
    _$layoutStyle,
  );
  static double _$contentPadding(HomeScreenConfig v) => v.contentPadding;
  static const Field<HomeScreenConfig, double> _f$contentPadding = Field(
    'contentPadding',
    _$contentPadding,
  );

  @override
  final MappableFields<HomeScreenConfig> fields = const {
    #heroTitle: _f$heroTitle,
    #heroSubtitle: _f$heroSubtitle,
    #backgroundImageUrl: _f$backgroundImageUrl,
    #enableDarkOverlay: _f$enableDarkOverlay,
    #primaryColor: _f$primaryColor,
    #featuredItems: _f$featuredItems,
    #maxFeaturedItems: _f$maxFeaturedItems,
    #lastUpdated: _f$lastUpdated,
    #externalLink: _f$externalLink,
    #showPromotionalBanner: _f$showPromotionalBanner,
    #primaryButtonLabel: _f$primaryButtonLabel,
    #secondaryButtonLabel: _f$secondaryButtonLabel,
    #layoutStyle: _f$layoutStyle,
    #contentPadding: _f$contentPadding,
  };

  static HomeScreenConfig _instantiate(DecodingData data) {
    return HomeScreenConfig(
      heroTitle: data.dec(_f$heroTitle),
      heroSubtitle: data.dec(_f$heroSubtitle),
      backgroundImageUrl: data.dec(_f$backgroundImageUrl),
      enableDarkOverlay: data.dec(_f$enableDarkOverlay),
      primaryColor: data.dec(_f$primaryColor),
      featuredItems: data.dec(_f$featuredItems),
      maxFeaturedItems: data.dec(_f$maxFeaturedItems),
      lastUpdated: data.dec(_f$lastUpdated),
      externalLink: data.dec(_f$externalLink),
      showPromotionalBanner: data.dec(_f$showPromotionalBanner),
      primaryButtonLabel: data.dec(_f$primaryButtonLabel),
      secondaryButtonLabel: data.dec(_f$secondaryButtonLabel),
      layoutStyle: data.dec(_f$layoutStyle),
      contentPadding: data.dec(_f$contentPadding),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static HomeScreenConfig fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<HomeScreenConfig>(map);
  }

  static HomeScreenConfig fromJson(String json) {
    return ensureInitialized().decodeJson<HomeScreenConfig>(json);
  }
}

mixin HomeScreenConfigMappable {
  String toJson() {
    return HomeScreenConfigMapper.ensureInitialized()
        .encodeJson<HomeScreenConfig>(this as HomeScreenConfig);
  }

  Map<String, dynamic> toMap() {
    return HomeScreenConfigMapper.ensureInitialized()
        .encodeMap<HomeScreenConfig>(this as HomeScreenConfig);
  }

  HomeScreenConfigCopyWith<HomeScreenConfig, HomeScreenConfig, HomeScreenConfig>
  get copyWith =>
      _HomeScreenConfigCopyWithImpl<HomeScreenConfig, HomeScreenConfig>(
        this as HomeScreenConfig,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return HomeScreenConfigMapper.ensureInitialized().stringifyValue(
      this as HomeScreenConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    return HomeScreenConfigMapper.ensureInitialized().equalsValue(
      this as HomeScreenConfig,
      other,
    );
  }

  @override
  int get hashCode {
    return HomeScreenConfigMapper.ensureInitialized().hashValue(
      this as HomeScreenConfig,
    );
  }
}

extension HomeScreenConfigValueCopy<$R, $Out>
    on ObjectCopyWith<$R, HomeScreenConfig, $Out> {
  HomeScreenConfigCopyWith<$R, HomeScreenConfig, $Out>
  get $asHomeScreenConfig =>
      $base.as((v, t, t2) => _HomeScreenConfigCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class HomeScreenConfigCopyWith<$R, $In extends HomeScreenConfig, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get featuredItems;
  $R call({
    String? heroTitle,
    String? heroSubtitle,
    String? backgroundImageUrl,
    bool? enableDarkOverlay,
    Color? primaryColor,
    List<String>? featuredItems,
    int? maxFeaturedItems,
    DateTime? lastUpdated,
    String? externalLink,
    bool? showPromotionalBanner,
    String? primaryButtonLabel,
    String? secondaryButtonLabel,
    String? layoutStyle,
    double? contentPadding,
  });
  HomeScreenConfigCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _HomeScreenConfigCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, HomeScreenConfig, $Out>
    implements HomeScreenConfigCopyWith<$R, HomeScreenConfig, $Out> {
  _HomeScreenConfigCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<HomeScreenConfig> $mapper =
      HomeScreenConfigMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get featuredItems => ListCopyWith(
    $value.featuredItems,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(featuredItems: v),
  );
  @override
  $R call({
    String? heroTitle,
    String? heroSubtitle,
    String? backgroundImageUrl,
    bool? enableDarkOverlay,
    Color? primaryColor,
    List<String>? featuredItems,
    int? maxFeaturedItems,
    DateTime? lastUpdated,
    Object? externalLink = $none,
    bool? showPromotionalBanner,
    String? primaryButtonLabel,
    String? secondaryButtonLabel,
    String? layoutStyle,
    double? contentPadding,
  }) => $apply(
    FieldCopyWithData({
      if (heroTitle != null) #heroTitle: heroTitle,
      if (heroSubtitle != null) #heroSubtitle: heroSubtitle,
      if (backgroundImageUrl != null) #backgroundImageUrl: backgroundImageUrl,
      if (enableDarkOverlay != null) #enableDarkOverlay: enableDarkOverlay,
      if (primaryColor != null) #primaryColor: primaryColor,
      if (featuredItems != null) #featuredItems: featuredItems,
      if (maxFeaturedItems != null) #maxFeaturedItems: maxFeaturedItems,
      if (lastUpdated != null) #lastUpdated: lastUpdated,
      if (externalLink != $none) #externalLink: externalLink,
      if (showPromotionalBanner != null)
        #showPromotionalBanner: showPromotionalBanner,
      if (primaryButtonLabel != null) #primaryButtonLabel: primaryButtonLabel,
      if (secondaryButtonLabel != null)
        #secondaryButtonLabel: secondaryButtonLabel,
      if (layoutStyle != null) #layoutStyle: layoutStyle,
      if (contentPadding != null) #contentPadding: contentPadding,
    }),
  );
  @override
  HomeScreenConfig $make(CopyWithData data) => HomeScreenConfig(
    heroTitle: data.get(#heroTitle, or: $value.heroTitle),
    heroSubtitle: data.get(#heroSubtitle, or: $value.heroSubtitle),
    backgroundImageUrl: data.get(
      #backgroundImageUrl,
      or: $value.backgroundImageUrl,
    ),
    enableDarkOverlay: data.get(
      #enableDarkOverlay,
      or: $value.enableDarkOverlay,
    ),
    primaryColor: data.get(#primaryColor, or: $value.primaryColor),
    featuredItems: data.get(#featuredItems, or: $value.featuredItems),
    maxFeaturedItems: data.get(#maxFeaturedItems, or: $value.maxFeaturedItems),
    lastUpdated: data.get(#lastUpdated, or: $value.lastUpdated),
    externalLink: data.get(#externalLink, or: $value.externalLink),
    showPromotionalBanner: data.get(
      #showPromotionalBanner,
      or: $value.showPromotionalBanner,
    ),
    primaryButtonLabel: data.get(
      #primaryButtonLabel,
      or: $value.primaryButtonLabel,
    ),
    secondaryButtonLabel: data.get(
      #secondaryButtonLabel,
      or: $value.secondaryButtonLabel,
    ),
    layoutStyle: data.get(#layoutStyle, or: $value.layoutStyle),
    contentPadding: data.get(#contentPadding, or: $value.contentPadding),
  );

  @override
  HomeScreenConfigCopyWith<$R2, HomeScreenConfig, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _HomeScreenConfigCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

