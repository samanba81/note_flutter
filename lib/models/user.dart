class User {
  int id = 0;
  String userName;
  String userPass = "ERROR";

  User(this.id, this.userName, this.userPass);

  static fromJson(Map<String, dynamic> json) => User(
        json['userId'],
        json['userName'],
        json['userPass'],
      );

  static fromAdminJson(Map<String, dynamic> json) => User(
        json['userId'],
        json['userName'],
        "ERROR",
      );

  static List<User> usersFromJson(List<dynamic> usersJson) {
    List<User> users = [];
    for (Map<String, dynamic> userJson in usersJson) {
      users.add(User.fromAdminJson(userJson));
    }
    return users;
  }

  @override
  String toString() {
    return 'User{id: $id, userName: $userName, userPass: $userPass}';
  }
}
