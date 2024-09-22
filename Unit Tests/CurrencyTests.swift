import Testing
import XCTest
import Foundation

@testable import MarshalDemo2

@MainActor
struct CurrencyTests {

	static let sampleJson = """
		{
			"date": "2024-09-22",
			"eur": {
				"sek": 11.36653266,
				"usd": 1.11742139
			}
		}
	"""
	
	var model = Currencies(endpoint: JSONEndpoint(json: CurrencyTests.sampleJson))
	
	func setUp() async throws {
		await model.load()
	}

	@Test func testSekToUsd() async throws {
		await model.load()
		let rate = model.rate(for: "sek", to: "usd")
		#expect(abs(rate! - 0.09) < 0.01)
	}
}
