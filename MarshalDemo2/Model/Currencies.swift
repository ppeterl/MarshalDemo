import Foundation


struct CurrencyResponse: Codable {
	var date: String
	var eur: [String: Double]
}

@MainActor
class Currencies : ObservableObject {
	@Published var currencies: [String: Double]
	
	private var endpoint: Endpoint
	
	init(endpoint: Endpoint) {
		self.endpoint = endpoint
		self.currencies = [:]
	}
	
	func rate(for from: String, to: String) -> Double? {
		if let v1 = currencies[from], let v2 = currencies[to] {
			return v2/v1
		}
		return nil
	}
	
	func load() async {
		do {
			let request = try endpoint.request(for: "currencies/eur.json")
			let response = try await request.send(type: CurrencyResponse.self)
			self.currencies = response.eur
		}
		catch {
			
		}
	}
}
