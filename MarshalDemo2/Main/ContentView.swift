import SwiftUI

enum Page {
	case wallet
	case history
	case store
}

struct ContentView: View {
	
	@EnvironmentObject var model: Model
	@EnvironmentObject var currencies: Currencies
	
	@State var page = Page.history

	var body: some View {
		VStack {
			Picker(selection: $page) {
				Text("Wallet")
				Text("Store")
				Text("History")
			} label: {
				EmptyView()
			}
			.pickerStyle(.segmented)
			switch page {
			case .history:
				TransactionsView()
			case .wallet:
				TransactionsView()
			case .store:
				TransactionsView()
			}
		}
			.environmentObject(model)
			.alert("", isPresented: Binding { model.errorState != nil } set: { _ in model.errorState = nil }) {
				Button("ok") {
					model.errorState = nil
				}
			} message: {
				Text("Error")
			}
	}
}

#Preview {
    ContentView()
}
