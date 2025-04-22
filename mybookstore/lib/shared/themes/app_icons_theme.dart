enum AppIconsTheme {
  close('assets/icons/close.png'),
  time('assets/icons/Time.svg'),
  search('assets/icons/Search.svg'),
  profile('assets/icons/Profile.svg'),
  books('assets/icons/Scroll.svg'),
  notification('assets/icons/Notification.svg'),
  home('assets/icons/Home.svg'),
  hide('assets/icons/Hide.svg'),
  fire('assets/icons/Fire.svg'),
  bookmark('assets/icons/Bookmark.svg'),
  view('assets/icons/View.svg'),
  show('assets/icons/Show.svg'),
  heart('assets/icons/Heart.svg'),
  upload('assets/icons/Export.svg'),
  star('assets/icons/star.svg'),
  delete('assets/icons/Delete.svg'),
  startSolid('assets/icons/star-solid.svg'),
  edit('assets/icons/Edit.svg'),
  filter('assets/icons/Filter.svg'),
  configure('assets/icons/Configure.svg');

  const AppIconsTheme(this.path);

  final String path;

  /// Retorna verdadeiro se o ícone é um SVG
  bool get isSvg => path.toLowerCase().endsWith('.svg');
}
