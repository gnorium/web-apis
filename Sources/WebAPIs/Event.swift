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
      case wheel = "wheel"
      case transitionend = "transitionend"
      case toggle = "toggle"
      case touchstart = "touchstart"
      case touchend = "touchend"
      case touchmove = "touchmove"
      case touchcancel = "touchcancel"
      case dblclick = "dblclick"
      case dragstart = "dragstart"

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
        case .wheel: return "wheel"
        case .transitionend: return "transitionend"
        case .toggle: return "toggle"
        case .touchstart: return "touchstart"
        case .touchend: return "touchend"
        case .touchmove: return "touchmove"
        case .touchcancel: return "touchcancel"
        case .dblclick: return "dblclick"
        case .dragstart: return "dragstart"
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
    public static let dblclick: StaticString = "dblclick"
    public static let dragstart: StaticString = "dragstart"

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
      case wheel
      case transitionend
      case toggle
      case touchstart
      case touchend
      case touchmove
      case touchcancel
      case dblclick
      case dragstart
      case error

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
        case .wheel: return "wheel"
        case .transitionend: return "transitionend"
        case .toggle: return "toggle"
        case .touchstart: return "touchstart"
        case .touchend: return "touchend"
        case .touchmove: return "touchmove"
        case .touchcancel: return "touchcancel"
        case .dblclick: return "dblclick"
        case .dragstart: return "dragstart"
        case .error: return "error"
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
        } else if stringEquals(rawValue, "dragstart") {
          self = .dragstart
        } else if stringEquals(rawValue, "dblclick") {
          self = .dblclick
        } else if stringEquals(rawValue, "error") {
          self = .error
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
        case .wheel: return "wheel"
        case .transitionend: return "transitionend"
        case .toggle: return "toggle"
        case .touchstart: return "touchstart"
        case .touchend: return "touchend"
        case .touchmove: return "touchmove"
        case .touchcancel: return "touchcancel"
        case .dblclick: return "dblclick"
        case .dragstart: return "dragstart"
        case .error: return "error"
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
    public static let dblclick: StaticString = "dblclick"
    public static let dragstart: StaticString = "dragstart"
    public static let error: StaticString = "error"

    // Event instance properties
    private let parsedDetail: String
    private let targetID: Int32
    public let payload: CallbackString

    /// Returns the event detail. For CustomEvents dispatched via the JS bridge,
    /// this calls event_detail() to retrieve the real .detail from the JS events map.
    /// Falls back to the parsed payload string for non-CustomEvent callbacks.
    public var detail: String {
      // First try the JS bridge — works for CustomEvents stored in the events map
      let bridgeDetail = payload.detail
      if !bridgeDetail.isEmpty {
        return bridgeDetail
      }
      return parsedDetail
    }

    public init(detail: String = "", targetID: Int32 = -1) {
      self.parsedDetail = detail
      self.targetID = targetID
      self.payload = CallbackString(ptr: UnsafePointer<CChar>.init(bitPattern: 0)!, len: 0)
    }

    public init(payload: CallbackString) {
      self.payload = payload
      let stringValue = payload.toString()
      // JS bridge passes "targetID:detail" for standard events
      if let colonIndex = stringIndexOfChar(stringValue, 58), colonIndex > 0 {  // 58 is ':'
        let idStr = stringSubstring(stringValue, from: 0, to: colonIndex)
        self.targetID = Int32(parseInt(idStr) ?? -1)
        self.parsedDetail = stringSubstring(stringValue, from: colonIndex + 1)
      } else {
        self.targetID = -1
        self.parsedDetail = stringValue
      }
    }

    public func preventDefault() {
      event_preventDefault(payload.ptr, Int32(payload.len))
    }

    public func stopPropagation() {
      event_stopPropagation(payload.ptr, Int32(payload.len))
    }

    public var key: String {
      var buffer = [UInt8](repeating: 0, count: 64)
      let len = event_getKey(payload.ptr, Int32(payload.len), &buffer, 64)
      if len > 0 {
        return String(decoding: buffer[0..<Int(len)], as: UTF8.self)
      }
      return ""
    }

    public var target: DOM.Element? {
      let id = event_target(payload.ptr, Int32(payload.len))
      return id >= 0 ? ElementFactory.create(id: id) : nil
    }

    public var clientX: Double {
      event_clientX(payload.ptr, Int32(payload.len))
    }

    public var clientY: Double {
      event_clientY(payload.ptr, Int32(payload.len))
    }

    public var deltaY: Double {
      event_deltaY(payload.ptr, Int32(payload.len))
    }

    public var button: Int {
      Int(event_button(payload.ptr, Int32(payload.len)))
    }
  }

  // MARK: - Event Externs

  @_extern(wasm, module: "env", name: "event_key")
  func event_key(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<CChar>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "event_getKey")
  func event_getKey(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<UInt8>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "event_preventDefault")
  func event_preventDefault(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32)

  @_extern(wasm, module: "env", name: "event_stopPropagation")
  func event_stopPropagation(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32)

  @_extern(wasm, module: "env", name: "event_target")
  func event_target(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "event_relatedTarget")
  func event_relatedTarget(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "event_detail")
  func event_detail(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<CChar>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "event_clientX")
  func event_clientX(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Double

  @_extern(wasm, module: "env", name: "event_clientY")
  func event_clientY(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Double

  @_extern(wasm, module: "env", name: "event_button")
  func event_button(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "event_deltaY")
  func event_deltaY(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Double
#endif
