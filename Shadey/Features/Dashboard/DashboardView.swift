import Charts
import SwiftUI

struct DashboardView: View {
    @State private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List {
            if viewModel.shouldShowEmptyState {
                ContentUnavailableView {
                    Label("Welcome to Shadey", systemImage: "sparkles")
                } description: {
                    Text("Add your first products and clients to start tracking inventory and formulas.")
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                Section("Overview") {
                    LabeledContent("Inventory Value") {
                        Text(viewModel.totalInventoryValue, format: CurrencyFormat.inventory)
                    }
                    LabeledContent("Clients", value: "\(viewModel.totalClients)")
                    if viewModel.lowStockCount > 0 {
                        LabeledContent("Low Stock") {
                            Text("\(viewModel.lowStockCount)")
                                .foregroundStyle(DesignSystem.warning)
                        }
                    }
                    if viewModel.overstockCount > 0 {
                        LabeledContent("Overstock") {
                            Text("\(viewModel.overstockCount)")
                                .foregroundStyle(DesignSystem.positive)
                        }
                    }
                }

                if !viewModel.stockByType.isEmpty || !viewModel.valueByBrand.isEmpty || !viewModel.usageTrends.isEmpty {
                    Section("Insights") {
                        if !viewModel.stockByType.isEmpty {
                            StockByTypeChartView(data: viewModel.stockByType)
                                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                        }

                        if !viewModel.valueByBrand.isEmpty {
                            ValueByBrandChartView(data: viewModel.valueByBrand)
                                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                        }

                        if !viewModel.usageTrends.isEmpty {
                            UsageTrendChartView(data: viewModel.usageTrends)
                                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                        }
                    }
                }

                if !viewModel.recentServices.isEmpty {
                    Section("Recent Services") {
                        ForEach(Array(viewModel.recentServices.prefix(5)), id: \.id) { service in
                            NavigationLink(value: ClientRoute.service(service.id)) {
                                RecentServiceRowView(service: service)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Dashboard")
        .navigationDestination(for: ClientRoute.self) { route in
            switch route {
            case .detail:
                EmptyView()
            case .service(let id):
                if let service = viewModel.recentServices.first(where: { $0.id == id }) {
                    ServiceDetailView(service: service)
                }
            }
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}
