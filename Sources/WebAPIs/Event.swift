#if SERVER
  import WebTypes

  public struct Event {
    /// Event type enum matching the Event.type DOM API
    public enum `Type`: String, Sendable {
      case click = "click"
      case change = "change"
      case input = "input"
      case submit = "submit"
      case focus = "focus"
      case blur = "blur"
      case keydown = "keydown"
      case keyup = "keyup"
      case keypress = "keypress"
      case mousedown = "mousedown"
      case mouseup = "mouseup"
      case mouseover = "mouseover"
      case mouseout = "mouseout"
      case mouseenter = "mouseenter"
      case mouseleave = "mouseleave"
      case mousemove = "mousemove"
      case scroll = "scroll"
      case resize = "resize"
      case load = "load"
      case unload = "unload"
      case transitionend = "transitionend"
      case toggle = "toggle"
      case touchstart = "touchstart"
      case touchend = "touchend"
      case touchmove = "touchmove"
      case touchcancel = "touchcancel"

      public var staticString: StaticString {
        switch self {
        case .click: return "click"
        case .change: return "change"
        case .input: return "input"
        case .submit: return "submit"
        case .focus: return "focus"
        case .blur: return "blur"
        case .keydown: return "keydown"
        case .keyup: return "keyup"
        case .keypress: return "keypress"
        case .mousedown: return "mousedown"
        case .mouseup: return "mouseup"
        case .mouseover: return "mouseover"
        case .mouseout: return "mouseout"
        case .mouseenter: return "mouseenter"
        case .mouseleave: return "mouseleave"
        case .mousemove: return "mousemove"
        case .scroll: return "scroll"
        case .resize: return "resize"
        case .load: return "load"
        case .unload: return "unload"
        case .transitionend: return "transitionend"
        case .toggle: return "toggle"
        case .touchstart: return "touchstart"
        case .touchend: return "touchend"
        case .touchmove: return "touchmove"
        case .touchcancel: return "touchcancel"
        }
      }
    }

    // Static members for shorthand access
    public static let click: StaticString = "click"
    public static let change: StaticString = "change"
    public static let input: StaticString = "input"
    public static let submit: StaticString = "submit"
    public static let focus: StaticString = "focus"
    public static let blur: StaticString = "blur"
    public static let keydown: StaticString = "keydown"
    public static let keyup: StaticString = "keyup"
    public static let keypress: StaticString = "keypress"
    public static let mousedown: StaticString = "mousedown"
    public static let mouseup: StaticString = "mouseup"
    public static let mouseover: StaticString = "mouseover"
    public static let mouseout: StaticString = "mouseout"
    public static let mouseenter: StaticString = "mouseenter"
    public static let mouseleave: StaticString = "mouseleave"
    public static let mousemove: StaticString = "mousemove"
    public static let scroll: StaticString = "scroll"
    public static let resize: StaticString = "resize"
    public static let load: StaticString = "load"
    public static let unload: StaticString = "unload"
    public static let transitionend: StaticString = "transitionend"
    public static let toggle: StaticString = "toggle"
    public static let touchstart: StaticString = "touchstart"
    public static let touchend: StaticString = "touchend"
    public static let touchmove: StaticString = "touchmove"
    public static let touchcancel: StaticString = "touchcancel"

    // Event instance properties (Placeholder for server-side event objects if needed)
    public let detail: String
    public let targetID: Int32

    public init(detail: String = "", targetID: Int32 = -1) {
      self.detail = detail
      self.targetID = targetID
    }
  }
#endif

#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities
  import WebTypes

  public struct Event {
    /// Event type enum matching the Event.type DOM API
    public enum `Type`: Sendable, RawRepresentable {
      case click
      case change
      case input
      case submit
      case focus
      case blur
      case keydown
      case keyup
      case keypress
      case mousedown
      case mouseup
      case mouseover
      case mouseout
      case mouseenter
      case mouseleave
      case mousemove
      case scroll
      case resize
      case load
      case unload
      case transitionend
      case toggle
      case touchstart
      case touchend
      case touchmove
      case touchcancel

      public var rawValue: String {
        switch self {
        case .click: return "click"
        case .change: return "change"
        case .input: return "input"
        case .submit: return "submit"
        case .focus: return "focus"
        case .blur: return "blur"
        case .keydown: return "keydown"
        case .keyup: return "keyup"
        case .keypress: return "keypress"
        case .mousedown: return "mousedown"
        case .mouseup: return "mouseup"
        case .mouseover: return "mouseover"
        case .mouseout: return "mouseout"
        case .mouseenter: return "mouseenter"
        case .mouseleave: return "mouseleave"
        case .mousemove: return "mousemove"
        case .scroll: return "scroll"
        case .resize: return "resize"
        case .load: return "load"
        case .unload: return "unload"
        case .transitionend: return "transitionend"
        case .toggle: return "toggle"
        case .touchstart: return "touchstart"
        case .touchend: return "touchend"
        case .touchmove: return "touchmove"
        case .touchcancel: return "touchcancel"
        }
      }

      public init?(rawValue: String) {
        if stringEquals(rawValue, "click") {
          self = .click
        } else if stringEquals(rawValue, "change") {
          self = .change
        } else if stringEquals(rawValue, "input") {
          self = .input
        } else if stringEquals(rawValue, "submit") {
          self = .submit
        } else if stringEquals(rawValue, "focus") {
          self = .focus
        } else if stringEquals(rawValue, "blur") {
          self = .blur
        } else if stringEquals(rawValue, "keydown") {
          self = .keydown
        } else if stringEquals(rawValue, "keyup") {
          self = .keyup
        } else if stringEquals(rawValue, "keypress") {
          self = .keypress
        } else if stringEquals(rawValue, "mousedown") {
          self = .mousedown
        } else if stringEquals(rawValue, "mouseup") {
          self = .mouseup
        } else if stringEquals(rawValue, "mouseover") {
          self = .mouseover
        } else if stringEquals(rawValue, "mouseout") {
          self = .mouseout
        } else if stringEquals(rawValue, "mouseenter") {
          self = .mouseenter
        } else if stringEquals(rawValue, "mouseleave") {
          self = .mouseleave
        } else if stringEquals(rawValue, "mousemove") {
          self = .mousemove
        } else if stringEquals(rawValue, "scroll") {
          self = .scroll
        } else if stringEquals(rawValue, "resize") {
          self = .resize
        } else if stringEquals(rawValue, "load") {
          self = .load
        } else if stringEquals(rawValue, "unload") {
          self = .unload
        } else if stringEquals(rawValue, "transitionend") {
          self = .transitionend
        } else if stringEquals(rawValue, "toggle") {
          self = .toggle
        } else if stringEquals(rawValue, "touchstart") {
          self = .touchstart
        } else if stringEquals(rawValue, "touchend") {
          self = .touchend
        } else if stringEquals(rawValue, "touchmove") {
          self = .touchmove
        } else if stringEquals(rawValue, "touchcancel") {
          self = .touchcancel
        } else {
          return nil
        }
      }

      public var staticString: StaticString {
        switch self {
        case .click: return "click"
        case .change: return "change"
        case .input: return "input"
        case .submit: return "submit"
        case .focus: return "focus"
        case .blur: return "blur"
        case .keydown: return "keydown"
        case .keyup: return "keyup"
        case .keypress: return "keypress"
        case .mousedown: return "mousedown"
        case .mouseup: return "mouseup"
        case .mouseover: return "mouseover"
        case .mouseout: return "mouseout"
        case .mouseenter: return "mouseenter"
        case .mouseleave: return "mouseleave"
        case .mousemove: return "mousemove"
        case .scroll: return "scroll"
        case .resize: return "resize"
        case .load: return "load"
        case .unload: return "unload"
        case .transitionend: return "transitionend"
        case .toggle: return "toggle"
        case .touchstart: return "touchstart"
        case .touchend: return "touchend"
        case .touchmove: return "touchmove"
        case .touchcancel: return "touchcancel"
        }
      }
    }

    // Static members for shorthand access
    public static let click: StaticString = "click"
    public static let change: StaticString = "change"
    public static let input: StaticString = "input"
    public static let submit: StaticString = "submit"
    public static let focus: StaticString = "focus"
    public static let blur: StaticString = "blur"
    public static let keydown: StaticString = "keydown"
    public static let keyup: StaticString = "keyup"
    public static let keypress: StaticString = "keypress"
    public static let mousedown: StaticString = "mousedown"
    public static let mouseup: StaticString = "mouseup"
    public static let mouseover: StaticString = "mouseover"
    public static let mouseout: StaticString = "mouseout"
    public static let mouseenter: StaticString = "mouseenter"
    public static let mouseleave: StaticString = "mouseleave"
    public static let mousemove: StaticString = "mousemove"
    public static let scroll: StaticString = "scroll"
    public static let resize: StaticString = "resize"
    public static let load: StaticString = "load"
    public static let unload: StaticString = "unload"
    public static let transitionend: StaticString = "transitionend"
    public static let toggle: StaticString = "toggle"
    public static let touchstart: StaticString = "touchstart"
    public static let touchend: StaticString = "touchend"
    public static let touchmove: StaticString = "touchmove"
    public static let touchcancel: StaticString = "touchcancel"

    // Event instance properties
    public let detail: String
    private let targetID: Int32
    public let payload: CallbackString

    public init(detail: String = "", targetID: Int32 = -1) {
      self.detail = detail
      self.targetID = targetID
      self.payload = CallbackString(ptr: UnsafePointer<CChar>.init(bitPattern: 0)!, len: 0)
    }

    public init(payload: CallbackString) {
      self.payload = payload
      let stringValue = payload.toString()
      // JS bridge passes "targetID:detail" for standard events
      if let colonIndex = stringIndexOfChar(stringValue, 58), colonIndex > 0 {  // 58 is ':'
        let idStr = stringSubstring(stringValue, from: 0, to: colonIndex)
        self.targetID = Int32(safeParseInt(idStr) ?? -1)
        self.detail = stringSubstring(stringValue, from: colonIndex + 1)
      } else {
        self.targetID = -1
        self.detail = stringValue
      }
    }

    public func preventDefault() {
      event_preventDefault()
    }

    public func stopPropagation() {
      event_stopPropagation()
    }

    public var key: String {
      var buffer = [UInt8](repeating: 0, count: 64)
      let len = event_getKey(&buffer, 64)
      if len > 0 {
        return String(decoding: buffer[0..<Int(len)], as: UTF8.self)
      }
      return ""
    }

    public var target: Element? {
      return targetID >= 0 ? ElementFactory.create(id: targetID) : nil
    }
  }

  @_extern(wasm, module: "env", name: "event_preventDefault")
  func event_preventDefault()

  @_extern(wasm, module: "env", name: "event_stopPropagation")
  func event_stopPropagation()

  @_extern(wasm, module: "env", name: "event_getKey")
  func event_getKey(_ buffer: UnsafeMutablePointer<UInt8>, _ maxLen: Int32) -> Int32
#endif
