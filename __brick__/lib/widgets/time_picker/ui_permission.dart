
enum UiPermissionGroup {
  user,
  report,
}



abstract class UiPermission {
  String getLabel();
}


class UserUiPermission extends UiPermission {
  final int flag;
  final String label;
  final UiPermissionGroup group;
  UserUiPermission(this.group,this.flag,this.label);

  factory UserUiPermission.add() => UserUiPermission(UiPermissionGroup.user,1,"Add");
  factory UserUiPermission.edit() => UserUiPermission(UiPermissionGroup.user,2,"Edit");
  factory UserUiPermission.activeDeactive() => UserUiPermission(UiPermissionGroup.user,4,"Active / De Active");
  factory UserUiPermission.delete() => UserUiPermission(UiPermissionGroup.user,8,"Delete");
  factory UserUiPermission.addWithExcel() => UserUiPermission(UiPermissionGroup.user,128,"Delete");

  @override
  String getLabel() => label;
}

class LogUiPermission extends UiPermission {
  final int flag;
  final String label;
  final UiPermissionGroup group;
  LogUiPermission(this.group,this.flag,this.label);

  factory LogUiPermission.read() => LogUiPermission(UiPermissionGroup.user,1,"Read");
  factory LogUiPermission.execute() => LogUiPermission(UiPermissionGroup.user,2,"Execute");

  @override
  String getLabel() => label;
}

class ReportUiPermission extends UiPermission {
  final int flag;
  final String label;
  final UiPermissionGroup group;
  ReportUiPermission(this.group,this.flag,this.label);

  factory ReportUiPermission.read() => ReportUiPermission(UiPermissionGroup.report,1,"Read");

  @override
  String getLabel() => label;
}

class TimaticUiPermission extends UiPermission {
  final int flag;
  final String label;
  final UiPermissionGroup group;
  TimaticUiPermission(this.group,this.flag,this.label);

  factory TimaticUiPermission.read() => TimaticUiPermission(UiPermissionGroup.report,1,"Read");

  @override
  String getLabel() => label;
}

class ConnectionUiPermission extends UiPermission {
  final int flag;
  final String label;
  final UiPermissionGroup group;
  ConnectionUiPermission(this.group,this.flag,this.label);

  factory ConnectionUiPermission.connect() => ConnectionUiPermission(UiPermissionGroup.report,1,"Connection");

  @override
  String getLabel() => label;
}

class SuperAdminUiPermission extends UiPermission {
  final int flag;
  final String label;
  final UiPermissionGroup group;
  SuperAdminUiPermission(this.group,this.flag,this.label);

  factory SuperAdminUiPermission.read() => SuperAdminUiPermission(UiPermissionGroup.report,1,"Superadmin");

  @override
  String getLabel() => label;
}



