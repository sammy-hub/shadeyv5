import Charts
import SwiftUI

struct DashboardView: View {
    @State private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                DashboardOverviewGridView(
                    totalValue: viewModel.totalInventoryValue,
                    clientCount: viewModel.totalClients,
                    lowStockCount: viewModel.lowStockCount,
                    overstockCount: viewModel.overstockCount
                )
                StockByTypeChartView(data: viewModel.stockByType)
                ValueByBrandChartView(data: viewModel.valueByBrand)
                UsageTrendChartView(data: viewModel.usageTrends)
                RecentServicesListView(services: Array(viewModel.recentServices.prefix(5)))
            }
            .padding(.horizontal, DesignSystem.Spacing.pagePadding)
            .padding(.vertical, DesignSystem.Spacing.large)
        }
        .background(DesignSystem.background)
        .scrollIndicators(.hidden)
        .navigationTitle("Dashboard")
        .refreshable {
            viewModel.refresh()
        }
    }
}

