#if CLIENT
  public protocol EventTargeting: Sendable {
    func addEventListener(
      _ event: StaticString,
      _ handler: @escaping @Sendable (Event) -> Void,
      capture: Bool
    ) -> Int32
    
    // Default implementation or overloaded version with capture = false
    @discardableResult
    func addEventListener(
      _ event: StaticString,
      _ handler: @escaping @Sendable (Event) -> Void
    ) -> Int32
    func removeEventListener(_ event: StaticString, _ callbackID: Int32)
    func dispatchEvent(_ event: StaticString)
    func dispatchEvent(_ event: CustomEvent)
  }
  public extension EventTargeting {
    @discardableResult
    func addEventListener(
      _ event: StaticString,
      _ handler: @escaping @Sendable (Event) -> Void
    ) -> Int32 {
      return addEventListener(event, handler, capture: false)
    }
    
    @discardableResult
    func addEventListener(
      _ type: Event.`Type`,
      _ handler: @escaping @Sendable (Event) -> Void
    ) -> Int32 {
      return addEventListener(type.staticString, handler, capture: false)
    }
    
    @discardableResult
    func addEventListener(
      _ type: Event.`Type`,
      _ handler: @escaping @Sendable (Event) -> Void,
      capture: Bool
    ) -> Int32 {
      return addEventListener(type.staticString, handler, capture: capture)
    }
  }
#endif
