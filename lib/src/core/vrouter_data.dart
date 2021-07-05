abstract class VRouterData {
  /// Url currently synced with the state
  /// This url can differ from the once of the browser if
  /// the state has been yet been updated
  String? get url;

  /// Previous url that was synced with the state
  String? get previousUrl;

  /// Path of [url]
  ///
  /// This is the same as the url WITHOUT the queryParameters
  String? get path => url != null ? Uri.parse(url!).path : null;

  /// Path of [previousUrl]
  ///
  /// This is the same as the url WITHOUT the queryParameters
  String? get previousPath =>
      previousUrl != null ? Uri.parse(previousUrl!).path : null;

  /// This state is saved in the browser history. This means that if the user presses
  /// the back or forward button on the navigator, this historyState will be the same
  /// as the last one you saved.
  ///
  /// It can be changed by using
  /// [context.vRouter.to(context.vRouter.url!, historyState: newHistoryState, isReplacement: true)]
  Map<String, String> get historyState;

  /// Maps all route parameters (i.e. parameters of the path
  /// mentioned as ":someId")
  Map<String, String> get pathParameters;

  /// Contains all query parameters (i.e. parameters after
  /// the "?" in the url) of the current url
  Map<String, String> get queryParameters;

  /// A list of every names corresponding to the [VRouteElement]s in
  /// the current stack
  List<String> get names;
}

/// Describes a class which contains all the useful data
/// of VRouter
abstract class VRouterSailor implements VRouterNavigator, VRouterData {}

/// Same as [VRouterSailor] except that [VRouter] has been
/// initialized so we are sure to have a url
abstract class InitializedVRouterSailor implements VRouterSailor {
  @override
  String get url;

  @override
  String get path => Uri.parse(url).path;

  @override
  String? get previousPath =>
      previousUrl != null ? Uri.parse(previousUrl!).path : null;
}

/// Describes a class which contains all the useful navigation method of VRouter
abstract class VRouterNavigator {
  @Deprecated('Use to (vRouter.to) instead')
  void push(
    String newUrl, {
    Map<String, String> queryParameters = const {},
    Map<String, String> historyState = const {},
  });

  /// Pushes a new url based on url segments
  ///
  /// For example: pushSegments(['home', 'bob']) ~ push('/home/bob')
  ///
  /// The advantage of using this over push is that each segment gets encoded.
  /// For example: pushSegments(['home', 'bob marley']) ~ push('/home/bob%20marley')
  ///
  /// Also see:
  ///  - [push] to see want happens when you push a new url
  @Deprecated('Use toSegments instead')
  void pushSegments(
    List<String> segments, {
    Map<String, String> queryParameters = const {},
    Map<String, String> historyState = const {},
  });

  @Deprecated('Use toNamed instead')
  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Map<String, String> historyState = const {},
  });

  @Deprecated('Use vRouter.to(..., isReplacement: true) instead')
  void pushReplacement(
    String newUrl, {
    Map<String, String> queryParameters = const {},
    Map<String, String> historyState = const {},
  });

  @Deprecated('Use vRouter.toNamed(..., isReplacement: true) instead')
  void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Map<String, String> historyState = const {},
  });

  @Deprecated('Use toExternal instead')
  void pushExternal(String newUrl, {bool openNewTab = false});

  /// This replaces the current history state of [VRouter] with given one
  @Deprecated(
      'Use to(context.vRouter.url!, isReplacement: true, historyState: newHistoryState) instead')
  void replaceHistoryState(Map<String, String> historyState);

  /// The main method to navigate to a new path
  ///
  ///
  /// Note that the path should be a valid url. If you
  /// fear part of you url might need encoding, use [toSegments]
  /// instead
  ///
  ///
  /// [path] can be of one of two forms:
  ///   * stating with '/', in which case we just navigate
  ///     to the given path
  ///   * not starting with '/', in which case we append the
  ///     current path to the given one
  ///
  /// [queryParameters] to add query parameters (you can also
  ///  add them manually)
  ///
  /// [historyState] is used an the web to restore browser
  /// history entry specific state (like scroll amount)
  ///
  /// [isReplacement] determines whether to overwrite the current
  /// history entry or create a new one. The is mainly useful
  /// when using [back], [forward] or [vRouteInformationAt], or on the web to control
  /// the browser history entries
  ///
  ///
  /// Also see:
  ///   - [toSegments] if you need your path segments to be encoded
  ///   - [toNamed] if you want to navigate by name
  ///   - [toExternal] if you want to navigate to an external url
  void to(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, String> historyState = const {},
    isReplacement = false,
  });

  /// Navigates to a new url based on path segments
  ///
  /// For example: pushSegments(['home', 'bob']) ~ push('/home/bob')
  ///
  /// The advantage of using this over push is that each segment gets encoded.
  /// For example: pushSegments(['home', 'bob marley']) ~ push('/home/bob%20marley')
  ///
  ///
  /// [queryParameters] to add query parameters (you can also
  ///  add them manually)
  ///
  /// [historyState] is used an the web to restore browser
  /// history entry specific state (like scroll amount)
  ///
  /// [isReplacement] determines whether to overwrite the current
  /// history entry or create a new one. The is mainly useful
  /// when using [back], [forward] or [vRouteInformationAt], or on the web to control
  /// the browser history entries
  ///
  ///
  /// Also see:
  ///  - [to] if you don't need segment encoding
  ///  - [toNamed] if you want to navigate by name
  ///  - [toExternal] if you want to navigate to an external url
  void toSegments(
    List<String> segments, {
    Map<String, String> queryParameters = const {},
    Map<String, String> historyState = const {},
    isReplacement = false,
  });

  /// [pathParameters] needs to specify every path parameters
  /// contained in the path corresponding to [name]
  ///
  /// [queryParameters] to add query parameters (you can also
  ///  add them manually)
  ///
  /// [historyState] is used an the web to restore browser
  /// history entry specific state (like scroll amount)
  ///
  /// [isReplacement] determines whether to overwrite the current
  /// history entry or create a new one. The is mainly useful
  /// when using [back], [forward] or [vRouteInformationAt], or on the web to control
  /// the browser history entries
  ///
  ///
  /// Also see:
  ///  - [to] if you don't need segment encoding
  ///  - [toSegments] if you need your path segments to be encoded
  ///  - [toExternal] if you want to navigate to an external url
  void toNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Map<String, String> historyState = const {},
    bool isReplacement = false,
  });

  /// Goes to an url which is not in the app
  ///
  ///
  /// On the web, you can set [openNewTab] to true to open this url
  /// in a new tab
  ///
  ///
  /// Also see:
  ///  - [to] if you don't need segment encoding
  ///  - [toSegments] if you need your path segments to be encoded
  ///  - [toNamed] if you want to navigate by name
  void toExternal(String url, {bool openNewTab = false});

  /// Goes forward 1 in the url history
  ///
  ///
  /// Throws an exception if this is not possible
  /// Use [historyCanForward] to know if this is possible
  void historyForward();

  /// Goes back 1 in the url history
  ///
  ///
  /// Throws an exception if this is not possible
  /// Use [historyCanBack] to know if this is possible
  void historyBack();

  /// Goes jumps of [delta] in the url history
  ///
  ///
  /// Throws an exception if this is not possible
  /// Use [historyCanGo] to know if this is possible
  void historyGo(int delta);

  /// Check whether going forward 1 in the history url is possible
  bool historyCanForward();

  /// Check whether going back 1 in the history url is possible
  bool historyCanBack();

  /// Check whether jumping of [delta] in the history url is possible
  bool historyCanGo(int delta);

  /// Starts a pop cycle
  ///
  ///
  /// Pop cycle:
  ///   1. onPop is called in all [VWidgetGuard]s
  ///   2. onPop is called in the nested-most [VRouteElement] of the current route
  ///   3. onPop is called in [VRouter]
  ///   4. Default behaviour of pop is called: [VRouterState._defaultPop]
  ///
  /// In any of the above steps, we can use [vRedirector] if you want to redirect or
  /// stop the navigation
  void pop({
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Map<String, String> newHistoryState = const {},
  });

  /// Starts a systemPop cycle
  ///
  ///
  /// systemPop cycle:
  ///   1. onSystemPop is called in all VWidgetGuards
  ///   2. onSystemPop is called in the nested-most VRouteElement of the current route
  ///   3. onSystemPop is called in VRouter
  ///   4. [pop] is called
  ///
  /// In any of the above steps, we can use [vRedirector] if you want to redirect or
  /// stop the navigation
  Future<void> systemPop({
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Map<String, String> newHistoryState = const {},
  });
}
