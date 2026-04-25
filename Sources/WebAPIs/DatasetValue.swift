#if CLIENT
  public protocol DatasetValue {
    var rawValue: StaticString { get }
  }
#endif
