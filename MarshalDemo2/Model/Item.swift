import Foundation

/*
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
 */
extension Encodable {
	var dictionary: [String: Any]? {
		guard let data = try? JSONEncoder().encode(self) else { return nil }
		return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
	}
}

struct Item : Codable, Identifiable {
	var symbol: String
	var baseAsset: String
	var quoteAsset: String
	var openPrice: String
	var lowPrice: String
	var highPrice: String
	var lastPrice: String
	var volume: String
	var bidPrice: String
	var askPrice: String
	var at: Date
	
	var id = UUID()
	
	private enum CodingKeys : String, CodingKey { case symbol, baseAsset, quoteAsset, openPrice, lowPrice, highPrice, lastPrice, volume, bidPrice, askPrice, at }
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.id = UUID()
/*
		if let props = self.dictionary {
			for prop in props.keys {
				self.prop = try container.decode(String.self, forKey: prop)
			}
		}
*/
		self.symbol = (try? container.decode(String.self, forKey: .symbol)) ?? ""
		self.baseAsset = (try? container.decode(String.self, forKey: .baseAsset)) ?? ""
		self.quoteAsset = (try? container.decode(String.self, forKey: .quoteAsset)) ?? ""
		self.openPrice = (try? container.decode(String.self, forKey: .openPrice)) ?? ""
		self.lowPrice = (try? container.decode(String.self, forKey: .lowPrice)) ?? ""
		self.highPrice = (try? container.decode(String.self, forKey: .highPrice)) ?? ""
		self.lastPrice = (try? container.decode(String.self, forKey: .lastPrice)) ?? ""
		self.volume = (try? container.decode(String.self, forKey: .volume)) ?? ""
		self.bidPrice = (try? container.decode(String.self, forKey: .bidPrice)) ?? ""
		self.askPrice = (try? container.decode(String.self, forKey: .askPrice)) ?? ""
		if let at = try? container.decode(Int.self, forKey: .askPrice) {
			self.at = Date(timeIntervalSince1970: TimeInterval(at))
		}
		else {
			self.at = Date.now
		}
	}
}
