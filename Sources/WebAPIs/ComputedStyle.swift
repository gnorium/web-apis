#if CLIENT
  import DOMBuilder
  import WebTypes
  import EmbeddedSwiftUtilities

  /// The read-only `CSSStyleDeclaration` `getComputedStyle` answers: every
  /// property as the element is drawn, custom properties as declared.
  public struct ComputedStyle: Sendable {
    let elementID: Int32

    /// The value of `property` ("font-size", "direction", "--size-edge-fade"),
    /// or "" when it has none.
    public func getPropertyValue(_ property: String) -> String {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)
      let bufferSize = 1024
      var resultBuffer = [UInt8](repeating: 0, count: bufferSize)
      let length = propertyBuffer.withUnsafeBufferPointer { propertyPointer in
        propertyPointer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          pointer in
          window_getComputedStyleProperty(
            elementID, pointer, Int32(propertyBuffer.count - 1), &resultBuffer, Int32(bufferSize))
        }
      }
      guard length > 0 else { return "" }
      return String(decoding: resultBuffer[0..<Int(length)], as: UTF8.self)
    }
  }

  extension Window {
    /// The DOM's own `window.getComputedStyle(element)`.
    public func getComputedStyle(_ element: DOM.Element) -> ComputedStyle {
      ComputedStyle(elementID: element.id)
    }
  }

  @_extern(wasm, module: "env", name: "window_getComputedStyleProperty")
  func window_getComputedStyleProperty(
    _ elementID: Int32, _ propertyPointer: UnsafePointer<CChar>, _ propertyLen: Int32,
    _ resultBuffer: UnsafeMutablePointer<UInt8>, _ resultLen: Int32
  ) -> Int32
#endif
