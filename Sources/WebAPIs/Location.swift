#if CLIENT
  import EmbeddedSwiftUtilities

  public final class Location: Sendable {
    public var href: String {
      get {
        let bufferSize = 1024 * 4
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        let len = location_getHref(buffer, Int32(bufferSize))
        if len > 0 {
          let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map {
            UInt8(bitPattern: $0)
          }
          return String(decoding: bytes, as: UTF8.self)
        }
        return ""
      }
      set {
        var buffer = Array(newValue.utf8)
        buffer.append(0)

        buffer.withUnsafeBufferPointer { ptr in
          ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
            location_setHref(pointer, Int32(buffer.count - 1))
          }
        }
      }
    }

    public var pathname: String {
      let bufferSize = 1024
      let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
      defer { buffer.deallocate() }
      let len = location_getPathname(buffer, Int32(bufferSize))
      if len > 0 {
        let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map {
          UInt8(bitPattern: $0)
        }
        return String(decoding: bytes, as: UTF8.self)
      }
      return ""
    }
  }

  public let location = Location()

  @_extern(wasm, module: "env", name: "getLocationHref")
  func location_getHref(_ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "setLocationHref")
  func location_setHref(_ hrefPointer: UnsafePointer<CChar>, _ hrefLen: Int32)

  @_extern(wasm, module: "env", name: "getLocationPathname")
  func location_getPathname(_ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32
#endif
