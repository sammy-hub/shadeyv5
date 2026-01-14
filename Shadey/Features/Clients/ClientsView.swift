import SwiftUI

struct ClientsView: View {
    @State private var viewModel: ClientsViewModel
    let inventoryStore: InventoryStore

    @State private var showingAddClient = false

    init(viewModel: ClientsViewModel, inventoryStore: InventoryStore) {
        _viewModel = State(initialValue: viewModel)
        self.inventoryStore = inventoryStore
    }

    var body: some View {
        List {
            if viewModel.clients.isEmpty {
                if viewModel.searchText.isEmpty {
                    ContentUnavailableView {
                        Label("No Clients Yet", systemImage: "person.crop.circle")
                    } description: {
                        Text("Add clients to track services, formulas, and photos.")
                    } actions: {
                        Button("Add Client", systemImage: "plus") {
                            showingAddClient = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                } else {
                    ContentUnavailableView {
                        Label("No Matches", systemImage: "magnifyingglass")
                    } description: {
                        Text("Try a different name or clear the search.")
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            } else {
                ForEach(viewModel.clients, id: \.id) { client in
                    NavigationLink(value: ClientRoute.detail(client.id)) {
                        ClientRowView(client: client)
                    }
                }
            }
        }
        .navigationTitle("Clients")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    ForEach(ClientsViewModel.SortOption.allCases) { option in
                        Button {
                            viewModel.sortOption = option
                        } label: {
                            if viewModel.sortOption == option {
                                Label(option.displayName, systemImage: "checkmark")
                            } else {
                                Text(option.displayName)
                            }
                        }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
                .accessibilityIdentifier("clientsSortMenu")

                Button("Add", systemImage: "plus") {
                    showingAddClient = true
                }
                .accessibilityIdentifier("clientsAddButton")
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search clients")
        .navigationDestination(for: ClientRoute.self) { route in
            switch route {
            case .detail(let id):
                if let client = viewModel.client(for: id) {
                    ClientDetailView(
                        viewModel: ClientDetailViewModel(client: client, store: viewModel.store),
                        inventoryStore: inventoryStore
                    )
                }
            case .service(let id):
                if let service = viewModel.service(for: id) {
                    ServiceDetailView(service: service)
                }
            }
        }
        .sheet(isPresented: $showingAddClient) {
            ClientEditorView(store: viewModel.store)
        }
    }
}
