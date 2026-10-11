#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities
  import WebTypes

  /// One of an element's animations as the Web Animations API reports it
  /// (`Element.getAnimations()`): read when asked, not kept live.
  public struct Animation: Sendable {
    /// `Animation.playState`: "idle", "running", "paused" or "finished".
    public let playState: String
    /// `CSSTransition.transitionProperty` ("transform"); "" for an
    /// animation that is not a CSS transition.
    public let transitionProperty: String
  }

  extension DOM.Element {
    /// The DOM's own `element.getAnimations()`: every animation now
    /// affecting the element (its CSS transitions and animations, and any
    /// script made), each as it stands.
    public func getAnimations() -> [Animation] {
      let bufferSize = 4096
      var buffer = [UInt8](repeating: 0, count: bufferSize)
      let length = element_getAnimations(id, &buffer, Int32(bufferSize))
      guard length > 0 else { return [] }
      // One line an animation: playState, a tab, transitionProperty.
      let text = String(decoding: buffer[0..<Int(length)], as: UTF8.self)
      var animations: [Animation] = []
      for line in stringSplit(text, separator: "\n") where !stringIsEmpty(line) {
        let fields = stringSplit(line, separator: "\t")
        animations.append(
          Animation(playState: fields.count > 0 ? fields[0] : "", transitionProperty: fields.count > 1 ? fields[1] : ""))
      }
      return animations
    }
  }

  @_extern(wasm, module: "env", name: "element_getAnimations")
  func element_getAnimations(_ elementID: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32) -> Int32
#endif
