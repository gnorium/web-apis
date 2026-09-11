#if CLIENT
  import DOMBuilder
  import WebTypes

  public struct TouchEvent: @unchecked Sendable {
    public let event: CallbackString

    public init(_ event: CallbackString) {
      self.event = event
    }

    public init(_ event: Event) {
      self.event = event.payload
    }

    public var target: DOM.Element? {
      event.target
    }

    // Coordinates of the first touch point (touches[0] / changedTouches[0]).
    // The JS bridge already resolves these from the touch list — see loader.js event_clientX.
    public var clientX: Double {
      event.clientX
    }

    public var clientY: Double {
      event.clientY
    }

    /// Active touch points on the target (`touches.length`).
    public var touchCount: Int {
      Int(event_touchCount(event.ptr, Int32(event.len)))
    }

    public func touchClientX(_ index: Int) -> Double {
      event_touchClientX(event.ptr, Int32(event.len), Int32(index))
    }

    public func touchClientY(_ index: Int) -> Double {
      event_touchClientY(event.ptr, Int32(event.len), Int32(index))
    }

    public func preventDefault() {
      event.preventDefault()
    }

    public func stopPropagation() {
      event.stopPropagation()
    }
  }
#endif
