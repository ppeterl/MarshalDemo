import Testing
import XCTest
import Foundation

@testable import MarshalDemo2

struct ItemTests {

	let sampleJson = """
		{
			"symbol": "btcinr",
			"baseAsset": "btc",
			"quoteAsset": "inr",
			"openPrice": "5656600",
			"lowPrice": "5656600.0",
			"highPrice": "5656600.0",
			"lastPrice": "5656600.0",
			"volume": "0",
			"bidPrice": "0.0",
			"askPrice": "0.0",
			"at": 1726936759000
		}
		"""

	@Test func parseItem() async throws {
		let decoder = JSONDecoder()
		let item = try decoder.decode(Item.self, from: sampleJson.data(using: .utf8)!)
		XCTAssertEqual(item.symbol, "btcinr")
	}
}
