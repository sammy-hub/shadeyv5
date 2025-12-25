import SwiftUI

struct ClientDetailView: View {
    @State private var viewModel: ClientDetailViewModel
    let inventoryStore: InventoryStore

    @Environment(\.dismiss) private var dismiss
    @State private var showingAddService = false
    @State private var showingEditClient = false
    @State private var showingDeleteClient = false

    init(viewModel: ClientDetailViewModel, inventoryStore: InventoryStore) {
        _viewModel = State(initialValue: viewModel)
        self.inventoryStore = inventoryStore
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ClientDetailHeaderView(client: viewModel.client)
                ClientStatsCardView(totalVisits: viewModel.totalVisits, totalSpend: viewModel.totalSpend)
                SectionHeaderView(title: "Service Timeline", subtitle: "Tap a service to view formula details")
                VStack(alignment: .leading) {
                    if viewModel.services.isEmpty {
                        Text("No services recorded yet.")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    } else {
                        ForEach(viewModel.services, id: \.id) { service in
                            NavigationLink(value: ClientRoute.service(service.id)) {
                                ClientServiceRowView(service: service)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(DesignSystem.background)
        .navigationTitle(viewModel.client.name)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Add Service", systemImage: "plus") {
                    showingAddService = true
                }
                Button("Edit", systemImage: "square.and.pencil") {
                    showingEditClient = true
                }
                Button("Delete", systemImage: "trash", role: .destructive) {
                    showingDeleteClient = true
                }
            }
        }
        .confirmationDialog("Delete Client", isPresented: $showingDeleteClient) {
            Button("Delete", role: .destructive) {
                viewModel.deleteClient()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Delete \(viewModel.client.name)? This can't be undone.")
        }
        .sheet(isPresented: $showingAddService) {
            ServiceEditorView(inventoryStore: inventoryStore) { draft in
                viewModel.addService(draft: draft)
            }
        }
        .sheet(isPresented: $showingEditClient) {
            ClientEditorView(store: viewModel.store, client: viewModel.client)
        }
    }
}
