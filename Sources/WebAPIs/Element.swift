#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

public struct Element: Sendable {
	public let id: Int32

	public var idString: String? {
		getAttribute("id")
	}

	// Static tag name members for createElement shorthand
	public static let span: StaticString = "span"
	public static let li: StaticString = "li"
	public static let ul: StaticString = "ul"
	public static let div: StaticString = "div"
	public static let a: StaticString = "a"
	public static let button: StaticString = "button"
	public static let input: StaticString = "input"
	public static let form: StaticString = "form"
	public static let h1: StaticString = "h1"
	public static let h2: StaticString = "h2"
	public static let h3: StaticString = "h3"
	public static let h4: StaticString = "h4"
	public static let h5: StaticString = "h5"
	public static let h6: StaticString = "h6"
	public static let p: StaticString = "p"
	public static let img: StaticString = "img"
	public static let section: StaticString = "section"
	public static let article: StaticString = "article"
	public static let nav: StaticString = "nav"
	public static let header: StaticString = "header"
	public static let footer: StaticString = "footer"
	public static let main: StaticString = "main"
	public static let aside: StaticString = "aside"

	public static func create(_ tagName: String) -> Element {
        var buffer = Array(tagName.utf8)
        buffer.append(0)
        return buffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                Element(id: document_createElement(pointer, Int32(buffer.count - 1)))
            }
        }
	}

	public func querySelector(_ selector: StaticString) -> Element? {
		return selector.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				let newId = element_querySelector(id, pointer, Int32(buffer.count))
				return newId >= 0 ? Element(id: newId) : nil
			}
		}
	}

	public func querySelector(_ selector: String) -> Element? {
        var buffer = Array(selector.utf8)
        buffer.append(0)
        return buffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                let newId = element_querySelector(id, pointer, Int32(buffer.count - 1))
                return newId >= 0 ? Element(id: newId) : nil
            }
        }
	}

	public func querySelectorAll(_ selector: String) -> [Element] {
        var buffer = Array(selector.utf8)
        buffer.append(0)
        return buffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                let maxElements: Int32 = 256
                let resultBuffer = UnsafeMutablePointer<Int32>.allocate(capacity: Int(maxElements))
                defer { resultBuffer.deallocate() }
                let count = element_querySelectorAll(id, pointer, Int32(buffer.count - 1), resultBuffer, maxElements)
                return (0..<count).map { Element(id: resultBuffer[Int($0)]) }
            }
        }
	}

	public var innerHTML: String {
		get {
			let bufferSize = 1024 * 16
			let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
			defer { buffer.deallocate() }
			let len = element_getInnerHTML(id, buffer, Int32(bufferSize))
			if len > 0 {
				let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
				return String(decoding: bytes, as: UTF8.self)
			}
			return ""
		}
		nonmutating set {
            var buffer = Array(newValue.utf8)
            buffer.append(0)
            buffer.withUnsafeBufferPointer { bufferPtr in
                bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                    element_setInnerHTML(id, pointer, Int32(buffer.count - 1))
                }
            }
		}
	}

	public func setAttribute(_ name: StaticString, _ value: StaticString) {
		name.withUTF8Buffer { nameBuffer in
			value.withUTF8Buffer { valueBuffer in
				nameBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuffer.count) { namePointer in
					valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
						element_setAttribute(id, namePointer, Int32(nameBuffer.count), valuePointer, Int32(valueBuffer.count))
					}
				}
			}
		}
	}

	public func setAttribute(_ name: String, _ value: String) {
        var nameBuffer = Array(name.utf8)
        nameBuffer.append(0)
        
        nameBuffer.withUnsafeBufferPointer { nameBufPtr in
            nameBufPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuffer.count) { namePointer in
                var buffer = Array(value.utf8)
                buffer.append(0)
                buffer.withUnsafeBufferPointer { bufferPtr in
                    bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { valuePointer in
                        element_setAttribute(id, namePointer, Int32(nameBuffer.count - 1), valuePointer, Int32(buffer.count - 1))
                    }
                }
            }
		}
	}

	public func setAttribute(_ name: String, _ value: StaticString) {
		var nameBuffer = Array(name.utf8)
		nameBuffer.append(0)

		nameBuffer.withUnsafeBufferPointer { namePtr in
			namePtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuffer.count) { namePointer in
				value.withUTF8Buffer { valueBuffer in
					valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
						element_setAttribute(id, namePointer, Int32(nameBuffer.count - 1), valuePointer, Int32(valueBuffer.count))
					}
				}
			}
		}
	}

	public func setAttribute(_ name: HTMLAttributeName.ARIASelected, _ value: Bool) {
		setAttribute("aria-selected", value ? "true" : "false")
	}
	
	public func setAttribute(_ name: HTMLAttributeName.ARIAHidden, _ value: Bool) {
		setAttribute("aria-hidden", value ? "true" : "false")
	}

	public func setAttribute(_ name: HTMLAttributeName.Tabindex, _ value: Int) {
		let valueStr = intToString(value)
		setAttribute("tabindex", valueStr)
	}

	public func setAttribute(_ name: HTMLAttributeName.`Type`, _ value: HTMLButton.`Type`) {
		setAttribute("type", value.rawValue)
	}

	public func setAttribute(_ name: HTMLAttributeName.Role, _ value: ARIARole) {
		setAttribute("role", value.rawValue)
	}

	public func setAttribute(_ name: HTMLAttributeName.ARIALive, _ value: ARIALive) {
		setAttribute("aria-live", value.rawValue)
	}
	
	public func setAttribute(_ name: HTMLAttributeName.ARIALabel, _ value: String) {
		setAttribute("aria-label", value)
	}

	public func setProperty(_ name: String, _ value: String) {
        var nameBuffer = Array(name.utf8)
        nameBuffer.append(0)
        
        nameBuffer.withUnsafeBufferPointer { nameBufPtr in
            nameBufPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuffer.count) { namePointer in
                var buffer = Array(value.utf8)
                buffer.append(0)
                buffer.withUnsafeBufferPointer { bufferPtr in
                    bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { valuePointer in
                        element_setProperty(id, namePointer, Int32(nameBuffer.count - 1), valuePointer, Int32(buffer.count - 1))
                    }
                }
            }
		}
	}

	public var href: String {
		get { "" }
		nonmutating set { setProperty("href", newValue) }
	}

	public var download: String {
		get { "" }
		nonmutating set { setProperty("download", newValue) }
	}

	public func removeAttribute(_ name: String) {
        var buffer = Array(name.utf8)
        buffer.append(0)
        buffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                element_removeAttribute(id, pointer, Int32(buffer.count - 1))
            }
        }
	}

	public func appendChild(_ child: Element) {
		element_appendChild(id, child.id)
	}

	public func removeChild(_ child: Element) {
		child.remove()
	}

	public func contains(_ child: Element) -> Bool {
		return element_contains(id, child.id) != 0
	}

	public func cloneNode(deep: Bool = true) -> Element {
		return Element(id: element_cloneNode(id, deep ? 1 : 0))
	}


	public func remove() {
		element_remove(id)
	}

	public var parentElement: Element? {
		let parentId = element_parentElement(id)
		return parentId >= 0 ? Element(id: parentId) : nil
	}

	public func click() {
		element_click(id)
	}

	public func focus() {
		element_focus(id)
	}

	public func blur() {
		element_blur(id)
	}

	/// Begins an SVG animation element (like <animate>)
	public func beginElement() {
		element_beginElement(id)
	}

	/// Ends an SVG animation element
	public func endElement() {
		element_endElement(id)
	}

	public func closest(_ selector: String) -> Element? {
        var buffer = Array(selector.utf8)
        buffer.append(0)
        return buffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                let newId = element_closest(id, pointer, Int32(buffer.count - 1))
                return newId >= 0 ? Element(id: newId) : nil
            }
        }
	}

	public var value: String {
		get {
			return getValue()
		}
		nonmutating set {
			setValue(newValue)
		}
	}

	public func getValue() -> String {
		let bufferSize = 1024 * 4
		let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
		defer { buffer.deallocate() }
		let len = element_getValue(id, buffer, Int32(bufferSize))
		if len > 0 {
			let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
			return String(decoding: bytes, as: UTF8.self)
		}
		return ""
	}

	public func setValue(_ value: String) {
		var valueBuffer = Array(value.utf8)
		valueBuffer.append(0)

		valueBuffer.withUnsafeBufferPointer { ptr in
			ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { cCharPtr in
				element_setValue(id, cCharPtr, Int32(valueBuffer.count - 1))
			}
		}
	}

	public var checked: Bool {
		get {
			return element_getChecked(id) != 0
		}
		nonmutating set {
			element_setChecked(id, newValue ? 1 : 0)
		}
	}

	public var disabled: Bool {
		get {
			return element_getDisabled(id) != 0
		}
		nonmutating set {
			setDisabled(newValue)
		}
	}

	public func setDisabled(_ disabled: Bool) {
		element_setDisabled(id, disabled ? 1 : 0)
	}

	public var className: String {
		get { getAttribute("class") ?? "" }
		nonmutating set { setAttribute("class", newValue) }
	}

	public var classList: DOMTokenList { DOMTokenList(elementId: id) }

	public var dataset: DOMStringMap {
		get { DOMStringMap(elementId: id) }
		nonmutating set { /* Setter required for assignment syntax through optional chaining */ }
	}

	public var offsetWidth: Int32 {
		element_getOffsetWidth(id)
	}

	public var scrollTop: Double {
		get { element_getScrollTop(id) }
		nonmutating set { element_setScrollTop(id, newValue) }
	}

	public var scrollHeight: Double {
		element_getScrollHeight(id)
	}

	public var clientHeight: Double {
		element_getClientHeight(id)
	}

	public var clientWidth: Double {
		element_getClientWidth(id)
	}

	public var scrollWidth: Double {
		element_getScrollWidth(id)
	}

	public var scrollLeft: Double {
		get { element_getScrollLeft(id) }
		nonmutating set { element_setScrollLeft(id, newValue) }
	}

	public var textContent: String? {
		get {
			var buffer = [CChar](repeating: 0, count: 4096)
			let bufferCount = buffer.count
			return buffer.withUnsafeMutableBufferPointer { bufferPtr in
				guard let baseAddress = bufferPtr.baseAddress else { return nil }
				let length = element_getTextContent(id, baseAddress, Int32(bufferCount))
				guard length > 0 else { return nil }
				return String(cString: baseAddress)
			}
		}
		nonmutating set {
			guard let value = newValue else { return }
			var valueBuffer = Array(value.utf8)
			valueBuffer.append(0)

			valueBuffer.withUnsafeBufferPointer { ptr in
				ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { cCharPtr in
					element_setTextContent(id, cCharPtr, Int32(valueBuffer.count - 1))
				}
			}
		}
	}

	public var indeterminate: Bool {
		get { 
			if let val = getAttribute("indeterminate") {
				return stringEquals(val, "true")
			}
			return false
		}
		nonmutating set { setAttribute("indeterminate", newValue ? "true" : "false") }
	}

	public func getBoundingClientRect() -> DOMRect? {
		var x: Double = 0
		var y: Double = 0
		var width: Double = 0
		var height: Double = 0
		var top: Double = 0
		var right: Double = 0
		var bottom: Double = 0
		var left: Double = 0
		let success = element_getBoundingClientRect(id, &x, &y, &width, &height, &top, &right, &bottom, &left)
		return success ? DOMRect(x: x, y: y, width: width, height: height, top: top, right: right, bottom: bottom, left: left) : nil
	}

	public func getBBox() -> (width: Double, height: Double)? {
		var width: Double = 0
		var height: Double = 0
		let success = element_getBBox(id, &width, &height)
		return success ? (width, height) : nil
	}

	public var style: CSSStyleDeclaration {
		CSSStyleDeclaration(elementId: id)
	}

	public func getAttribute(_ name: String) -> String? {
		let bufferSize = 1024 * 4
		let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
		defer { buffer.deallocate() }
        
        var nameBuffer = Array(name.utf8)
        nameBuffer.append(0)
        
        return nameBuffer.withUnsafeBufferPointer { nameBufPtr in
            nameBufPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuffer.count) { pointer in
                let len = element_getAttribute(id, pointer, Int32(nameBuffer.count - 1), buffer, Int32(bufferSize))
                if len > 0 {
                    let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
                    return String(decoding: bytes, as: UTF8.self)
                }
                return nil
            }
        }
	}

	public func getAttribute(_ name: HTMLAttributeName) -> String? {
		return getAttribute(name.rawValue)
	}

	public func hasAttribute(_ name: HTMLAttributeName) -> Bool {
		return getAttribute(name.rawValue) != nil
	}
	
	public func hasAttribute(_ name: String) -> Bool {
		return getAttribute(name) != nil
	}

	public func scrollIntoView(_ options: ScrollIntoViewOptions) {
		// For now, just call scrollIntoView - options handling would need JS impl
		element_scrollIntoView(id)
	}

	public func scrollBy(x: Double, y: Double) {
		element_scrollBy(id, x, y)
	}

	public func fetch(_ url: String, _ callback: @escaping @Sendable (CallbackString?) -> Void) {
		let callbackId = CallbackRegistry.register { response in
			callback(response.isEmpty ? nil : response)
		}
		var urlBuffer = Array(url.utf8)
		urlBuffer.append(0)

		urlBuffer.withUnsafeBufferPointer { ptr in
			ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: urlBuffer.count) { cCharPointer in
				element_fetch(id, cCharPointer, Int32(urlBuffer.count - 1), Int32(callbackId))
			}
		}
	}
}

extension Element: EventTarget {
	@discardableResult
	public func addEventListener(_ event: StaticString, _ handler: @escaping @Sendable (CallbackString) -> Void) -> Element {
		let callbackId = CallbackRegistry.register(handler)
		event.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				element_addEventListener(id, pointer, Int32(buffer.count), Int32(callbackId))
			}
		}
		return self
	}

	@discardableResult
	public func addEventListener(_ event: Event.`Type`, _ handler: @escaping @Sendable (CallbackString) -> Void) -> Element {
		return addEventListener(event.staticString, handler)
	}

	public func removeEventListener(_ event: StaticString) {
		event.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				element_removeEventListener(id, pointer, Int32(buffer.count))
			}
		}
	}

	public func dispatchEvent(_ event: StaticString) {
		event.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				element_dispatchEvent(id, pointer, Int32(buffer.count))
			}
		}
	}

	public func dispatchEvent(_ type: Event.`Type`) {
		self.dispatchEvent(type.staticString)
	}
	
	public func dispatchEvent(_ event: CustomEvent) {
		element_dispatchCustomEvent(id, event.pointer)
	}

}

@_extern(wasm, module: "env", name: "element_addEventListener")
func element_addEventListener(_ elementId: Int32, _ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackId: Int32)

@_extern(wasm, module: "env", name: "element_removeEventListener")
func element_removeEventListener(_ elementId: Int32, _ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32)

@_extern(wasm, module: "env", name: "element_dispatchEvent")
func element_dispatchEvent(_ elementId: Int32, _ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32)

@_extern(wasm, module: "env", name: "element_dispatchCustomEvent")
func element_dispatchCustomEvent(_ elementId: Int32, _ eventPointer: Int32)

@_extern(wasm, module: "env", name: "element_querySelector")
func element_querySelector(_ elementId: Int32, _ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_getInnerHTML")
func element_getInnerHTML(_ elementId: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_setInnerHTML")
func element_setInnerHTML(_ elementId: Int32, _ pointer: UnsafePointer<CChar>, _ len: Int32)

@_extern(wasm, module: "env", name: "element_getTextContent")
func element_getTextContent(_ elementId: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_setTextContent")
func element_setTextContent(_ elementId: Int32, _ pointer: UnsafePointer<CChar>, _ len: Int32)

@_extern(wasm, module: "env", name: "element_setAttribute")
func element_setAttribute(_ elementId: Int32, _ namePointer: UnsafePointer<CChar>, _ nameLen: Int32, _ valuePointer: UnsafePointer<CChar>, _ valueLen: Int32)

@_extern(wasm, module: "env", name: "element_setProperty")
func element_setProperty(_ elementId: Int32, _ namePointer: UnsafePointer<CChar>, _ nameLen: Int32, _ valuePointer: UnsafePointer<CChar>, _ valueLen: Int32)

@_extern(wasm, module: "env", name: "element_removeAttribute")
func element_removeAttribute(_ elementId: Int32, _ namePointer: UnsafePointer<CChar>, _ nameLen: Int32)

@_extern(wasm, module: "env", name: "element_addClass")
func element_addClass(_ elementId: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)

@_extern(wasm, module: "env", name: "element_removeClass")
func element_removeClass(_ elementId: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)

@_extern(wasm, module: "env", name: "element_toggleClass")
func element_toggleClass(_ elementId: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)

@_extern(wasm, module: "env", name: "element_appendChild")
func element_appendChild(_ parentId: Int32, _ childId: Int32)

@_extern(wasm, module: "env", name: "element_contains")
func element_contains(_ parentId: Int32, _ childId: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_getValue")
func element_getValue(_ elementId: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_setValue")
func element_setValue(_ elementId: Int32, _ valuePointer: UnsafePointer<CChar>, _ valueLen: Int32)

@_extern(wasm, module: "env", name: "element_getChecked")
func element_getChecked(_ elementId: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_setChecked")
func element_setChecked(_ elementId: Int32, _ checked: Int32)

@_extern(wasm, module: "env", name: "element_getDisabled")
func element_getDisabled(_ elementId: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_setDisabled")
func element_setDisabled(_ elementId: Int32, _ disabled: Int32)

@_extern(wasm, module: "env", name: "element_getAttribute")
func element_getAttribute(_ elementId: Int32, _ namePointer: UnsafePointer<CChar>, _ nameLen: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_setStyleProperty")
func element_setStyleProperty(_ elementId: Int32, _ propertyPointer: UnsafePointer<CChar>, _ propertyLen: Int32, _ valuePointer: UnsafePointer<CChar>, _ valueLen: Int32)

@_extern(wasm, module: "env", name: "element_cloneNode")
func element_cloneNode(_ elementId: Int32, _ deep: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_querySelectorAll")
func element_querySelectorAll(_ elementId: Int32, _ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32, _ buffer: UnsafeMutablePointer<Int32>, _ maxElements: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_remove")
func element_remove(_ elementId: Int32)

@_extern(wasm, module: "env", name: "element_parentElement")
func element_parentElement(_ elementId: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_click")
func element_click(_ elementId: Int32)

@_extern(wasm, module: "env", name: "element_focus")
func element_focus(_ elementId: Int32)

@_extern(wasm, module: "env", name: "element_blur")
func element_blur(_ elementId: Int32)

@_extern(wasm, module: "env", name: "element_closest")
func element_closest(_ elementId: Int32, _ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_getOffsetWidth")
func element_getOffsetWidth(_ elementId: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_getScrollWidth")
func element_getScrollWidth(_ elementId: Int32) -> Int32

@_extern(wasm, module: "env", name: "element_getScrollTop")
func element_getScrollTop(_ elementId: Int32) -> Double

@_extern(wasm, module: "env", name: "element_setScrollTop")
func element_setScrollTop(_ elementId: Int32, _ value: Double)

@_extern(wasm, module: "env", name: "element_getScrollHeight")
func element_getScrollHeight(_ elementId: Int32) -> Double

@_extern(wasm, module: "env", name: "element_getClientHeight")
func element_getClientHeight(_ elementId: Int32) -> Double

@_extern(wasm, module: "env", name: "element_getClientWidth")
func element_getClientWidth(_ elementId: Int32) -> Double

@_extern(wasm, module: "env", name: "element_getScrollWidth")
func element_getScrollWidth(_ elementId: Int32) -> Double

@_extern(wasm, module: "env", name: "element_getScrollLeft")
func element_getScrollLeft(_ elementId: Int32) -> Double

@_extern(wasm, module: "env", name: "element_setScrollLeft")
func element_setScrollLeft(_ elementId: Int32, _ value: Double)

@_extern(wasm, module: "env", name: "element_scrollBy")
func element_scrollBy(_ elementId: Int32, _ x: Double, _ y: Double)

@_extern(wasm, module: "env", name: "element_getBoundingClientRect")
func element_getBoundingClientRect(_ elementId: Int32, _ xPointer: UnsafeMutablePointer<Double>, _ yPointer: UnsafeMutablePointer<Double>, _ widthPointer: UnsafeMutablePointer<Double>, _ heightPointer: UnsafeMutablePointer<Double>, _ topPointer: UnsafeMutablePointer<Double>, _ rightPointer: UnsafeMutablePointer<Double>, _ bottomPointer: UnsafeMutablePointer<Double>, _ leftPointer: UnsafeMutablePointer<Double>) -> Bool

@_extern(wasm, module: "env", name: "element_getBBox")
func element_getBBox(_ elementId: Int32, _ widthPointer: UnsafeMutablePointer<Double>, _ heightPointer: UnsafeMutablePointer<Double>) -> Bool

@_extern(wasm, module: "env", name: "element_fetch")
func element_fetch(_ elementId: Int32, _ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32, _ callbackId: Int32)

@_extern(wasm, module: "env", name: "element_scrollIntoView")
func element_scrollIntoView(_ elementId: Int32)

@_extern(wasm, module: "env", name: "element_beginElement")
func element_beginElement(_ elementId: Int32)

@_extern(wasm, module: "env", name: "element_endElement")
func element_endElement(_ elementId: Int32)

#endif
