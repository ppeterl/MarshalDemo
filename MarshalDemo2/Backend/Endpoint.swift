import Foundation

enum HttpMethod: String {
	case get
	case post
	case put
	case delete
}

protocol Endpoint {
	func request(for endpoint: String, method: HttpMethod?, withPayload payload: Data?) throws -> Request
}

extension Endpoint {
	func request(for endpoint: String) throws -> Request {
		try self.request(for: endpoint, method: .get, withPayload: nil)
	}
	func request(for endpoint: String, method: HttpMethod) throws -> Request {
		try self.request(for: endpoint, method: method, withPayload: nil)
	}
}

protocol Request {
	func send<T: Decodable>(type: T.Type) async throws -> T
}

struct JSONRequest : Request {
	var returnedJson: Data
	
	init(json: String) {
		self.returnedJson = json.data(using: .utf8)!
	}
	
	func send<T>(type: T.Type) async throws -> T where T : Decodable {
		do {
			let decoder = JSONDecoder()
			return try decoder.decode(T.self, from: returnedJson)
		}
		catch let DecodingError.dataCorrupted(context) {
			print(context)
		}
		throw URLEndpoint.BackendError.generalError(message: "Failed to parse JSON")
	}
}

class JSONEndpoint: Endpoint {
	var returnValue: String

	init(json: String) {
		self.returnValue = json
	}

	func request(for endpoint: String, method: HttpMethod?, withPayload payload: Data?) throws -> Request {
		return JSONRequest(json: returnValue)
	}
}

class URLEndpoint : Endpoint {

	fileprivate enum HttpStatusCode: Int {
		case ok = 200
		case unauthorized = 401
		case forbidden = 403
	}
	
	enum BackendError: Error {
		case generalError(message: String)
		case httpError(statusCode: Int, endpoint: String)
	}
	
	
	private let baseUrl: String
	
	init(baseURL: String) {
		self.baseUrl = baseURL
	}
	
	func request(for endpoint: String, method: HttpMethod?, withPayload payload: Data?) throws -> any Request {
		
		let url = URL(string: "\(baseUrl)/\(endpoint)")!
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpMethod = method!.rawValue
		if let payload {
			assert(method == .post)
			request.httpBody = payload
		}
		else {
			assert(method != .post)
		}
		print("[Network] Request: \(method!.rawValue) \(url.absoluteString)")
		if let payload {
			print("[Network] Request payload: \(payload.prettyPrintedJSONString)")
		}
		if let headers = request.allHTTPHeaderFields, headers.count > 0 {
			print("[Network] Request headers:")
			headers.forEach { key, value in
				print("[Network]     \(key): \(value)")
			}
		}
		return RealRequest(request: request)
	}
}

struct RealRequest: Request {
	var request: URLRequest
	
	init(request: URLRequest) {
		self.request = request
	}
	func send<T: Decodable>(type: T.Type) async throws -> T {
		
		let (data, response) = try await URLSession.shared.data(for: request)
		guard let httpResponse = response as? HTTPURLResponse else {
			print("[Network] Response: Invalid response type \(String(describing: response))")
			throw URLEndpoint.BackendError.generalError(message: "Invalid response")
		}
		print("[Network] Response: Status code \(httpResponse.statusCode)")
		if httpResponse.statusCode != URLEndpoint.HttpStatusCode.ok.rawValue {
			throw URLEndpoint.BackendError.httpError(statusCode: httpResponse.statusCode, endpoint: request.url?.absoluteString ?? "Unknown")
		}
		do {
			let decoder = JSONDecoder()
			return try decoder.decode(T.self, from: data)
		}
		catch let DecodingError.dataCorrupted(context) {
			print(context)
		}
		catch let DecodingError.keyNotFound(key, context) {
			print("Key '\(key)' not found:", context.debugDescription)
			print("codingPath:", context.codingPath)
		}
		catch let DecodingError.valueNotFound(value, context) {
			print("Value '\(value)' not found:", context.debugDescription)
			print("codingPath:", context.codingPath)
		}
		catch let DecodingError.typeMismatch(type, context)  {
			print("Type '\(type)' mismatch:", context.debugDescription)
			print("codingPath:", context.codingPath)
		}
		catch {
			print("error: ", error)
		}
		throw URLEndpoint.BackendError.generalError(message: "Failed to parse response from endpoint \(request.url?.absoluteString ?? "Unknown")")
	}
}
