enum AppImages {
  splash('splash');


  const AppImages(this.path);
  final String path;

  String get image => 'assets/icons/$path.svg';
}

enum AppPngImages {
  shape('shapes');


  const AppPngImages(this.path);
  final String path;

  String get image => 'assets/images/png/$path.png';
}