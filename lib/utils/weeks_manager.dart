abstract class CurrentPageManager{
  static int _pageNumber = 1;
  static int get pageNumber => _pageNumber;

  static List<PageChangeListener> _listeners = [];

  static set pageNumber(int value) {
    _pageNumber = value;
    _notify();
  }
  static void listenPageNumberChange(PageChangeListener listener){
    _listeners.add(listener);
  }

  static void _notify(){
    for (PageChangeListener l in _listeners)
      l.onPageNumberChangedListener();
  }
}

abstract class PageChangeListener {
  void onPageNumberChangedListener();
}