import SwiftUI

struct TransactionRowView: View {
	var item: Item

	var body: some View {
		HStack {
			Text(verbatim: "\(item.symbol) \(item.volume)")
			Text(verbatim: "\(item.bidPrice)")
		}
	}
}
