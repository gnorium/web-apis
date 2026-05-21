#if CLIENT
  import EmbeddedSwiftUtilities

  public final class Location: @unchecked Sendable {
    public var href: String {
      get {
        let bufferSize = 1024 * 4
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        let len = window_getLocationHref(buffer, Int32(bufferSize))
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
            window_setLocationHref(pointer, Int32(buffer.count - 1))
          }
        }
      }
    }

    public var pathname: String {
      let bufferSize = 1024
      let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
      defer { buffer.deallocate() }
      let len = window_getLocationPathname(buffer, Int32(bufferSize))
      if len > 0 {
        let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map {
          UInt8(bitPattern: $0)
        }
        return String(decoding: bytes, as: UTF8.self)
      }
      return ""
    }

    public var search: String {
      let bufferSize = 1024 * 4
      let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
      defer { buffer.deallocate() }
      let len = window_getLocationSearch(buffer, Int32(bufferSize))
      if len > 0 {
        let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map {
          UInt8(bitPattern: $0)
        }
        return String(decoding: bytes, as: UTF8.self)
      }
      return ""
    }

    public init() {}
  }

  public let location = Location()
#endif
