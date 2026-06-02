#if CLIENT
  import WebTypes

  extension CSS.Keyword.None: CSSPropertyValue {
    public var rawValue: StaticString {
      switch self {
      case .none: return "none"
      }
    }
  }

  extension CSS.Keyword.Auto: CSSPropertyValue {
    public var rawValue: StaticString {
      switch self {
      case .auto: return "auto"
      }
    }
  }

  extension CSS.Keyword.Global: CSSPropertyValue {
    public var rawValue: StaticString {
      switch self {
      case .inherit: return "inherit"
      case .initial: return "initial"
      case .revert: return "revert"
      case .revertLayer: return "revert-layer"
      case .unset: return "unset"
      }
    }
  }
#endif
