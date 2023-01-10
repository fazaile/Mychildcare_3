class API {
  //local hostb tak static kene tukar
  static const hostConnect = 'http://10.0.2.2/child_care';
  static const hostConnectUser = '$hostConnect/user';
  static const hostConnectAdmin = '$hostConnect/admin';
  static const hostConnectTeacher = '$hostConnect/teacher';

  static const hostUploadChildren = '$hostConnect/children';
  static const hostUploadClassroom = '$hostConnect/classroom';
  static const hostUploadMenu = '$hostConnect/menu';

  //signUp-login user
  static const signUp = '$hostConnectUser/signup.php';
  static const validateEmail = '$hostConnectUser/validate_email.php';
  static const login = '$hostConnectUser/login.php';

  //Login admin
  static const adminLogin = '$hostConnectAdmin/login.php';

  //Login Teacher
  static const teacherLogin = '$hostConnectTeacher/login.php';
  static const teacherSignUp = '$hostConnectTeacher/signup.php';
  static const teacherValidateEmail = '$hostConnectTeacher/validate_email.php';
  static const teacherClassroom = '$hostConnectTeacher/selectid.php';

  //upload-save new item
  static const uploadNewChildren = '$hostUploadChildren/upload.php';

  //Get children
  static const getAllChildren = '$hostUploadChildren/all_children.php';

  static const deleteChildren = '$hostUploadChildren/delete_children.php';

  static const updateChildren = '$hostUploadChildren/update_children.php';

  //Classroom
  static const getAllClassroom = '$hostUploadClassroom/all_classroom.php';
  static const deleteClassroom = '$hostUploadClassroom/delete_classroom.php';
  static const uploadClassroom = '$hostUploadClassroom/upload_classroom.php';

  //activity
  static const uploadNewActivity = '$hostUploadClassroom/upload_activity.php';
  static const getAllActivity = '$hostUploadClassroom/all_activity.php';
  static const deleteActivity = '$hostUploadClassroom/delete_activity.php';

  //Food Menu
  static const uploadNewMenu = '$hostUploadMenu/upload_menu.php';
  static const getAllMenu = '$hostUploadMenu/all_menu.php';
  static const deleteMenu = '$hostUploadMenu/delete_menu.php';
}
