#if CLIENT
  public protocol CSSPropertyValue {
    var rawValue: StaticString { get }
  }
#endif
