#if CLIENT
  import WebTypes

  extension CSSColorScheme: DatasetValue {
    public var rawValue: StaticString {
      staticRawValue
    }
  }
#endif
