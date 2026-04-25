#if CLIENT
  import WebTypes

  extension CSSDisplay.Outside: CSSPropertyValue {
    public var rawValue: StaticString {
      switch self {
      case .block: return "block"
      case .inline: return "inline"
      }
    }
  }

  extension CSSDisplay.Box: CSSPropertyValue {
    public var rawValue: StaticString {
      switch self {
      case .contents: return "contents"
      }
    }
  }

  extension CSSDisplay.Inside: CSSPropertyValue {
    public var rawValue: StaticString {
      switch self {
      case .flow: return "flow"
      case .flowRoot: return "flow-root"
      case .table: return "table"
      case .flex: return "flex"
      case .grid: return "grid"
      case .ruby: return "ruby"
      }
    }
  }

  extension CSSDisplay.ListItem: CSSPropertyValue {
    public var rawValue: StaticString {
      switch self {
      case .listItem: return "list-item"
      }
    }
  }

  extension CSSDisplay.Legacy: CSSPropertyValue {
    public var rawValue: StaticString {
      switch self {
      case .inlineBlock: return "inline-block"
      case .inlineTable: return "inline-table"
      case .inlineFlex: return "inline-flex"
      case .inlineGrid: return "inline-grid"
      }
    }
  }
#endif
