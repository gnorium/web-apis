#if CLIENT
  import WebTypes

  extension CSS.ColorScheme: DatasetValue {
    public var rawValue: StaticString {
      staticRawValue
    }
  }
#endif
