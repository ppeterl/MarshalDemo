import Foundation

extension Data {
	var prettyPrintedJSONString: String {
		guard let object = try? JSONSerialization.jsonObject(with: self, options: []) else {
			return "Invalid JSON: \(String(data: self, encoding: .utf8) ?? "nil")"
		}
		guard let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
			  let prettyPrintedString = String(data: data, encoding: .utf8) else {
			return ""
		}
		return prettyPrintedString
	}
}
