import SwiftUI

@main
struct MarshalDemo2App: App {
	
	@StateObject var model = Model(endpoint: URLEndpoint(baseURL: "https://api.wazirx.com/sapi/v1"))
	@StateObject var currency = Currencies(endpoint: URLEndpoint(baseURL: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/"))

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(model)
				.environmentObject(currency)
        }
    }
}
