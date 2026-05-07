// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);


import '/core/extensions/list_extensions.dart';
import '/core/helpers/json_validators.dart';
import '/core/helpers/nullable.dart';

class BasicInfoModel {
  final int id;
  final String displayName;
  final String displayNameEn;

  BasicInfoModel({
    required this.id,
    required this.displayName,
    required this.displayNameEn,
  });

  BasicInfoModel copyWith({
    int? id,
    String? displayName,
    String? displayNameEn,
  }) => BasicInfoModel(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    displayNameEn: displayNameEn ?? this.displayNameEn,
  );

  factory BasicInfoModel.fromJson(Map<String, dynamic> json) => BasicInfoModel(
    id: expectInt(json, "Id"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "DisplayName": displayName,
    "DisplayNameEn": displayNameEn,
  };

  @override
  String toString() => displayName;
}



class Bootstrap {
  final AppConfig appConfig;
  final BootstrapData data;

  Bootstrap({
    required this.appConfig,
    required this.data,
  });

  Bootstrap copyWith({
    AppConfig? appConfig,
    BootstrapData? data,
  }) =>
      Bootstrap(
        appConfig: appConfig ?? this.appConfig,
        data: data ?? this.data,
      );

  factory Bootstrap.fromJson(Map<String, dynamic> json) => Bootstrap(
    appConfig: AppConfig.fromJson(expectMap(json, "AppConfig")),
    data: BootstrapData.fromJson(expectMap(json, "Data")),
  );

  Map<String, dynamic> toJson() => {
    "AppConfig": appConfig.toJson(),
    "Data": data.toJson(),
  };
}

class AppConfig {
  final int bootstrapVersion;
  final String minimumSupportedAppVersion;
  final String latestAppVersion;
  final bool forceUpdate;
  final String? forceUpdateMessage;
  final String? forceUpdateUrl;
  final bool isMaintenanceMode;
  final String? maintenanceMessage;

  AppConfig({
    required this.bootstrapVersion,
    required this.minimumSupportedAppVersion,
    required this.latestAppVersion,
    required this.forceUpdate,
    required this.forceUpdateMessage,
    required this.forceUpdateUrl,
    required this.isMaintenanceMode,
    required this.maintenanceMessage,
  });

  AppConfig copyWith({
    int? bootstrapVersion,
    String? minimumSupportedAppVersion,
    String? latestAppVersion,
    bool? forceUpdate,
    Nullable<String?>? forceUpdateMessage,
    Nullable<String?>? forceUpdateUrl,
    bool? isMaintenanceMode,
    Nullable<String?>? maintenanceMessage,
  }) =>
      AppConfig(
        bootstrapVersion: bootstrapVersion ?? this.bootstrapVersion,
        minimumSupportedAppVersion: minimumSupportedAppVersion ?? this.minimumSupportedAppVersion,
        latestAppVersion: latestAppVersion ?? this.latestAppVersion,
        forceUpdate: forceUpdate ?? this.forceUpdate,
        forceUpdateMessage: forceUpdateMessage != null ? forceUpdateMessage.value : this.forceUpdateMessage,
        forceUpdateUrl: forceUpdateUrl != null ? forceUpdateUrl.value : this.forceUpdateUrl,
        isMaintenanceMode: isMaintenanceMode ?? this.isMaintenanceMode,
        maintenanceMessage: maintenanceMessage != null ? maintenanceMessage.value : this.maintenanceMessage,
      );

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    bootstrapVersion: expectInt(json, "BootstrapVersion"),
    minimumSupportedAppVersion: expectString(json, "MinimumSupportedAppVersion"),
    latestAppVersion: expectString(json, "LatestAppVersion"),
    forceUpdate: expectBool(json, "ForceUpdate"),
    forceUpdateMessage: expectNullableString(json, "ForceUpdateMessage"),
    forceUpdateUrl: expectNullableString(json, "ForceUpdateUrl"),
    isMaintenanceMode: expectBool(json, "IsMaintenanceMode"),
    maintenanceMessage: expectNullableString(json, "MaintenanceMessage"),
  );

  Map<String, dynamic> toJson() => {
    "BootstrapVersion": bootstrapVersion,
    "MinimumSupportedAppVersion": minimumSupportedAppVersion,
    "LatestAppVersion": latestAppVersion,
    "ForceUpdate": forceUpdate,
    "ForceUpdateMessage": forceUpdateMessage,
    "ForceUpdateUrl": forceUpdateUrl,
    "IsMaintenanceMode": isMaintenanceMode,
    "MaintenanceMessage": maintenanceMessage,
  };
}

class BrewMethod extends BasicInfoModel {
  BrewMethod({required super.id, required super.displayName, required super.displayNameEn});

  factory BrewMethod.fromJson(Map<String, dynamic> json) => BrewMethod(
    id: expectInt(json, "Id"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
  );
}

class ProcessMethod extends BasicInfoModel  {
  ProcessMethod({required super.id, required super.displayName, required super.displayNameEn});

  factory ProcessMethod.fromJson(Map<String, dynamic> json) => ProcessMethod(
    id: expectInt(json, "Id"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
  );

}

class GrindSize extends BasicInfoModel  {
  GrindSize({required super.id, required super.displayName, required super.displayNameEn});

  factory GrindSize.fromJson(Map<String, dynamic> json) => GrindSize(
    id: expectInt(json, "Id"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
  );

}

class EquipmentType extends BasicInfoModel  {
  EquipmentType({required super.id, required super.displayName, required super.displayNameEn});

  factory EquipmentType.fromJson(Map<String, dynamic> json) => EquipmentType(
    id: expectInt(json, "Id"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
  );

}

class RoastLevel extends BasicInfoModel {
  RoastLevel({required super.id, required super.displayName, required super.displayNameEn});

  factory RoastLevel.fromJson(Map<String, dynamic> json) => RoastLevel(
    id: expectInt(json, "Id"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
  );



}

class Profession extends BasicInfoModel {
  Profession({required super.id, required super.displayName, required super.displayNameEn});

  factory Profession.fromJson(Map<String, dynamic> json) => Profession(
    id: expectInt(json, "Id"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
  );


}

class BootstrapData {
  final List<BrewMethod> brewMethods;
  final List<Country> countries;
  final List<ProcessMethod> processMethods;
  final List<RoastLevel> roastLevels;
  final List<GrindSize> grindSizes;
  final List<EquipmentType> equipmentTypes;
  final Settings settings;
  final List<BrewMethodStepTemplate> brewMethodStepTemplates;
  final List<Profession> professions;
  final List<CoffeeFlavorCategory> flavors;

  BootstrapData({
    required this.brewMethods,
    required this.countries,
    required this.processMethods,
    required this.roastLevels,
    required this.settings,
    required this.brewMethodStepTemplates,
    required this.professions,
    required this.flavors,
    required this.grindSizes,
    required this.equipmentTypes,
  });

  BootstrapData copyWith({
    List<BrewMethod>? brewMethods,
    List<Country>? countries,
    List<ProcessMethod>? processMethods,
    List<RoastLevel>? roastLevels,
    Settings? settings,
    List<BrewMethodStepTemplate>? brewMethodStepTemplates,
    List<Profession>? professions,
    List<CoffeeFlavorCategory>? flavors,
    List<GrindSize>? grindSizes,
    List<EquipmentType>? equipmentTypes,
  }) =>
      BootstrapData(
        brewMethods: brewMethods ?? this.brewMethods,
        countries: countries ?? this.countries,
        processMethods: processMethods ?? this.processMethods,
        roastLevels: roastLevels ?? this.roastLevels,
        settings: settings ?? this.settings,
        brewMethodStepTemplates: brewMethodStepTemplates ?? this.brewMethodStepTemplates,
        professions: professions ?? this.professions,
        flavors: flavors ?? this.flavors,
        grindSizes: grindSizes ?? this.grindSizes,
        equipmentTypes: equipmentTypes ?? this.equipmentTypes,
      );

  factory BootstrapData.fromJson(Map<String, dynamic> json) => BootstrapData(
    brewMethods: expectListOf<BrewMethod>(
      json,
      "BrewMethods",
      (x) => BrewMethod.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <BrewMethod>[],
    ),
    countries: expectListOf<Country>(
      json,
      "Countries",
      (x) => Country.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <Country>[],
    ),
    processMethods: expectListOf<ProcessMethod>(
      json,
      "ProcessMethods",
      (x) => ProcessMethod.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <ProcessMethod>[],
    ),
    roastLevels: expectListOf<RoastLevel>(
      json,
      "RoastLevels",
      (x) => RoastLevel.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <RoastLevel>[],
    ),
    settings: Settings.fromJson(expectMap(json, "Settings")),
    brewMethodStepTemplates: expectListOf<BrewMethodStepTemplate>(
      json,
      "BrewMethodStepTemplates",
      (x) => BrewMethodStepTemplate.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <BrewMethodStepTemplate>[],
    ),
    professions: expectListOf<Profession>(
      json,
      "Professions",
      (x) => Profession.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <Profession>[],
    ),
    flavors: expectListOf<CoffeeFlavorCategory>(
      json,
      "Flavors",
      (x) => CoffeeFlavorCategory.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <CoffeeFlavorCategory>[],
    ),
    grindSizes: expectListOf<GrindSize>(
      json,
      "GrindSizes",
      (x) => GrindSize.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <GrindSize>[],
    ),
    equipmentTypes: expectListOf<EquipmentType>(
      json,
      "EquipmentTypes",
      (x) => EquipmentType.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <EquipmentType>[],
    ),
  );

  Map<String, dynamic> toJson() => {
    "BrewMethods": List<dynamic>.from(brewMethods.map((x) => x.toJson())),
    "Countries": List<dynamic>.from(countries.map((x) => x.toJson())),
    "ProcessMethods": List<dynamic>.from(processMethods.map((x) => x.toJson())),
    "RoastLevels": List<dynamic>.from(roastLevels.map((x) => x.toJson())),
    "Settings": settings.toJson(),
    "BrewMethodStepTemplates": List<dynamic>.from(brewMethodStepTemplates.map((x) => x.toJson())),
    "Professions": List<dynamic>.from(professions.map((x) => x.toJson())),
    "Flavors": List<dynamic>.from(flavors.map((x) => x.toJson())),
    "GrindSizes": List<dynamic>.from(grindSizes.map((x) => x.toJson())),
    "EquipmentTypes": List<dynamic>.from(equipmentTypes.map((x) => x.toJson())),
  };

  List<CoffeeFlavor> get getAllFlavors => flavors.map((a)=>a.items).reduce((a,b)=>[...a,...b]);

  RoastLevel? getRoastLevelById(int roastLevelId) => roastLevels.firstWhereOrNull((a)=>a.id == roastLevelId);
  Country? getCountryById(int id) => countries.firstWhereOrNull((a)=>a.id == id);
  ProcessMethod? getProcessMethodById(int id) =>  processMethods.firstWhereOrNull((a)=>a.id == id);
  BrewMethod? getBrewMethodById(int id) => brewMethods.firstWhereOrNull((a)=>a.id == id);
  CoffeeFlavor? getCoffeeFlavorById(int id) => getAllFlavors.firstWhereOrNull((a)=>a.id == id);
  EquipmentType? getEquipmentTypeById(int id) => equipmentTypes.firstWhereOrNull((a)=>a.id == id);
  GrindSize? getGrindSizeById(int id) => grindSizes.firstWhereOrNull((a)=>a.id == id);
  BrewMethodStepTemplate? getStepTemplateById(int id) => brewMethodStepTemplates.firstWhereOrNull((a)=>a.id == id);
}

class CoffeeFlavorCategory {
  final int id;
  final String displayName;
  final String displayNameEn;
  final int displayOrder;
  final List<CoffeeFlavor> items;

  CoffeeFlavorCategory({
    required this.id,
    required this.displayName,
    required this.displayNameEn,
    required this.displayOrder,
    required this.items,
  });

  CoffeeFlavorCategory copyWith({
    int? id,
    String? displayName,
    String? displayNameEn,
    int? displayOrder,
    List<CoffeeFlavor>? items,
  }) =>
      CoffeeFlavorCategory(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        displayNameEn: displayNameEn ?? this.displayNameEn,
        displayOrder: displayOrder ?? this.displayOrder,
        items: items ?? this.items,
      );

  factory CoffeeFlavorCategory.fromJson(Map<String, dynamic> json) => CoffeeFlavorCategory(
    id: expectInt(json, "Id"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
    displayOrder: expectInt(json, "DisplayOrder"),
    items: expectListOf<CoffeeFlavor>(
      json,
      "Items",
      (x) => CoffeeFlavor.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <CoffeeFlavor>[],
    ),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "DisplayName": displayName,
    "DisplayNameEn": displayNameEn,
    "DisplayOrder": displayOrder,
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class CoffeeFlavor {
  final int id;
  final int categoryId;
  final String displayName;
  final String displayNameEn;
  final int displayOrder;

  CoffeeFlavor({
    required this.id,
    required this.categoryId,
    required this.displayName,
    required this.displayNameEn,
    required this.displayOrder,
  });

  CoffeeFlavor copyWith({
    int? id,
    int? categoryId,
    String? displayName,
    String? displayNameEn,
    int? displayOrder,
  }) =>
      CoffeeFlavor(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        displayName: displayName ?? this.displayName,
        displayNameEn: displayNameEn ?? this.displayNameEn,
        displayOrder: displayOrder ?? this.displayOrder,
      );

  factory CoffeeFlavor.fromJson(Map<String, dynamic> json) => CoffeeFlavor(
    id: expectInt(json, "Id"),
    categoryId: expectInt(json, "CategoryId"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
    displayOrder: expectInt(json, "DisplayOrder"),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "CategoryId": categoryId,
    "DisplayName": displayName,
    "DisplayNameEn": displayNameEn,
    "DisplayOrder": displayOrder,
  };

  @override
  String toString() => displayName;
}

class BrewMethodStepTemplate {
  final int id;
  final int brewMethodId;
  final int stepDefinitionId;
  final String code;
  final String name;
  final String nameEn;
  final String icon;
  final int displayOrder;
  final bool isOptional;
  final List<StepField> fields;

  BrewMethodStepTemplate({
    required this.id,
    required this.brewMethodId,
    required this.stepDefinitionId,
    required this.code,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.displayOrder,
    required this.isOptional,
    required this.fields,
  });

  BrewMethodStepTemplate copyWith({
    int? id,
    int? brewMethodId,
    int? stepDefinitionId,
    String? code,
    String? name,
    String? nameEn,
    String? icon,
    int? displayOrder,
    bool? isOptional,
    List<StepField>? fields,
  }) =>
      BrewMethodStepTemplate(
        id: id ?? this.id,
        brewMethodId: brewMethodId ?? this.brewMethodId,
        stepDefinitionId: stepDefinitionId ?? this.stepDefinitionId,
        code: code ?? this.code,
        name: name ?? this.name,
        nameEn: nameEn ?? this.nameEn,
        icon: icon ?? this.icon,
        displayOrder: displayOrder ?? this.displayOrder,
        isOptional: isOptional ?? this.isOptional,
        fields: fields ?? this.fields,
      );

  factory BrewMethodStepTemplate.fromJson(Map<String, dynamic> json) => BrewMethodStepTemplate(
    id: expectInt(json, "Id"),
    brewMethodId: expectInt(json, "BrewMethodId"),
    stepDefinitionId: expectInt(json, "StepDefinitionId"),
    code: expectString(json, "Code"),
    name: expectString(json, "Name"),
    nameEn: expectString(json, "NameEn", defaultValue: ''),
    icon: expectString(json, "Icon", defaultValue: ''),
    displayOrder: expectInt(json, "DisplayOrder"),
    isOptional: expectBool(json, "IsOptional", defaultValue: false),
    fields: expectListOf<StepField>(
      json,
      "Fields",
      (x) => StepField.fromJson(Map<String, dynamic>.from(x as Map)),
      defaultValue: const <StepField>[],
    ),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "BrewMethodId": brewMethodId,
    "StepDefinitionId": stepDefinitionId,
    "Code": code,
    "Name": name,
    "NameEn": nameEn,
    "Icon": icon,
    "DisplayOrder": displayOrder,
    "IsOptional": isOptional,
    "Fields": List<dynamic>.from(fields.map((x) => x.toJson())),
  };
}

class StepField {
  final int id;
  final int fieldDefinitionId;
  final String code;
  final String name;
  final String nameEn;
  final String type;
  final String icon;
  final String? unit;
  final String placeholder;
  final String defaultValue;
  final bool isRequired;
  final bool isVisible;

  StepField({
    required this.id,
    required this.fieldDefinitionId,
    required this.code,
    required this.name,
    required this.nameEn,
    required this.type,
    required this.icon,
    required this.unit,
    required this.placeholder,
    required this.defaultValue,
    required this.isRequired,
    required this.isVisible,
  });

  StepField copyWith({
    int? id,
    int? fieldDefinitionId,
    String? code,
    String? name,
    String? nameEn,
    String? type,
    String? icon,
    Nullable<String?>? unit,
    String? placeholder,
    String? defaultValue,
    bool? isRequired,
    bool? isVisible,
  }) =>
      StepField(
        id: id ?? this.id,
        fieldDefinitionId: fieldDefinitionId ?? this.fieldDefinitionId,
        code: code ?? this.code,
        name: name ?? this.name,
        nameEn: nameEn ?? this.nameEn,
        type: type ?? this.type,
        icon: icon ?? this.icon,
        unit: unit != null ? unit.value : this.unit,
        placeholder: placeholder ?? this.placeholder,
        defaultValue: defaultValue ?? this.defaultValue,
        isRequired: isRequired ?? this.isRequired,
        isVisible: isVisible ?? this.isVisible,
      );

  factory StepField.fromJson(Map<String, dynamic> json) => StepField(
    id: expectInt(json, "Id"),
    fieldDefinitionId: expectInt(json, "FieldDefinitionId"),
    code: expectString(json, "Code"),
    name: expectString(json, "Name"),
    nameEn: expectString(json, "NameEn", defaultValue: ''),
    type: expectString(json, "Type"),
    icon: expectString(json, "Icon", defaultValue: ''),
    unit: expectNullableString(json, "Unit"),
    placeholder: expectString(json, "Placeholder", defaultValue: ''),
    defaultValue: expectString(json, "DefaultValue", defaultValue: ''),
    isRequired: expectBool(json, "IsRequired", defaultValue: false),
    isVisible: expectBool(json, "IsVisible", defaultValue: true),
  );

  dynamic get getDefault => type =="number"?int.tryParse(defaultValue):defaultValue;

  Map<String, dynamic> toJson() => {
    "Id": id,
    "FieldDefinitionId": fieldDefinitionId,
    "Code": code,
    "Name": name,
    "NameEn": nameEn,
    "Type": type,
    "Icon": icon,
    "Unit": unit,
    "Placeholder": placeholder,
    "DefaultValue": defaultValue,
    "IsRequired": isRequired,
    "IsVisible": isVisible,
  };
}


class Country {
  final int id;
  final String code;
  final String displayName;
  final String displayNameEn;

  Country({
    required this.id,
    required this.code,
    required this.displayName,
    required this.displayNameEn,
  });

  Country copyWith({
    int? id,
    String? code,
    String? displayName,
    String? displayNameEn,
  }) =>
      Country(
        id: id ?? this.id,
        code: code ?? this.code,
        displayName: displayName ?? this.displayName,
        displayNameEn: displayNameEn ?? this.displayNameEn,
      );

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: expectInt(json, "Id"),
    code: expectString(json, "Code"),
    displayName: expectString(json, "DisplayName"),
    displayNameEn: expectString(json, "DisplayNameEn", defaultValue: ''),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Code": code,
    "DisplayName": displayName,
    "DisplayNameEn": displayNameEn,
  };

  @override
  String toString() =>displayName;
}

class Settings {
  final String language;
  final String temperatureUnit;
  final String weightUnit;
  final String volumeUnit;

  Settings({
    required this.language,
    required this.temperatureUnit,
    required this.weightUnit,
    required this.volumeUnit,
  });

  Settings copyWith({
    String? language,
    String? temperatureUnit,
    String? weightUnit,
    String? volumeUnit,
  }) =>
      Settings(
        language: language ?? this.language,
        temperatureUnit: temperatureUnit ?? this.temperatureUnit,
        weightUnit: weightUnit ?? this.weightUnit,
        volumeUnit: volumeUnit ?? this.volumeUnit,
      );

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    language: expectString(json, "Language", defaultValue: 'en'),
    temperatureUnit: expectString(json, "TemperatureUnit", defaultValue: 'C'),
    weightUnit: expectString(json, "WeightUnit", defaultValue: 'g'),
    volumeUnit: expectString(json, "VolumeUnit", defaultValue: 'ml'),
  );

  Map<String, dynamic> toJson() => {
    "Language": language,
    "TemperatureUnit": temperatureUnit,
    "WeightUnit": weightUnit,
    "VolumeUnit": volumeUnit,
  };
}
