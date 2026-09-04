import 'enums.dart';

class EnumConverters {

  //-----------------USER ROLE CONVERTERS -------------------///
  static UserRole stringToUserRole(String roleString) {
    switch(roleString){
      case 'parent':
        return UserRole.parent;
      case 'teacher':
        return UserRole.teacher;
      case 'student':
        return UserRole.student;
      default:
        return UserRole.unknown;
    }
  }

  
}