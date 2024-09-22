import SwiftUI

struct TransactionsView: View {
	@EnvironmentObject var model: Model
	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(model.items) { item in
					TransactionRowView(item: item)
				}
			}
		}
		.task {
			if NSClassFromString("XCTest") == nil {
				await model.load()
			}
		}
	}
}
