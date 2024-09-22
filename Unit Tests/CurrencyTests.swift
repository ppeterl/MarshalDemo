import Testing
import XCTest
import Foundation

@testable import MarshalDemo2

struct CurrencyTests {

	let sampleJson = """
		{
			"date": "2024-09-22",
			"eur": {
				"sek": 11.36653266
				"usd": 1.11742139
			}
		}
		"""
	
	var model = Currencies(endpoint: "https://api.exchangeratesapi.io/latest?base=SEK")
	
	func setUp() async throws {
		await model.load()
	}

	@Test func parseCurrency() async throws {
	}
	
	@Test func testSekToUsd() async throws {
		
	}
}
