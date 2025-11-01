enum AppIcons {
  profile('profile');


  const AppIcons(this.path);
  final String path;

  String get icon => 'assets/icons/$path.svg';
}