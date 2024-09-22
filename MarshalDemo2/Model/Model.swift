import SwiftUI


@MainActor
class Model : ObservableObject {
	
	@Published var errorState: Error?
	@Published var items: [Item]

	var backend: Endpoint
	
	init(endpoint: Endpoint) {
		self.backend = endpoint
		self.items = []
	}
	
	func load() async {
		do {
			let request = try backend.request(for: "tickers/24hr")
			let items = try await request.send(type: [Item].self)

			self.items = items
		}
		catch let error as URLEndpoint.BackendError {
			self.errorState = error
		}
		catch {
			self.errorState = URLEndpoint.BackendError.generalError(message: "Unknown error")
		}
	}
}
