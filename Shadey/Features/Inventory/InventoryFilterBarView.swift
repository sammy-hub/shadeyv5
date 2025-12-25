import SwiftUI

struct InventoryFilterBarView: View {
    @Bindable var viewModel: InventoryViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                    SectionHeaderView(title: "Browse", subtitle: "Filter by brand or type.")
                    Spacer()
                    InventorySortMenuView(sortOption: $viewModel.sortOption)
                }

                if viewModel.availableBrands.isEmpty {
                    Text("Brands appear here once you add products.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("Brand")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                        ScrollView(.horizontal) {
                            HStack(spacing: DesignSystem.Spacing.small) {
                                FilterChipView(title: "All", isSelected: viewModel.selectedBrand == nil) {
                                    viewModel.selectedBrand = nil
                                }
                                ForEach(viewModel.availableBrands, id: \.self) { brand in
                                    FilterChipView(title: brand, isSelected: viewModel.selectedBrand == brand) {
                                        viewModel.toggleBrandFilter(brand)
                                    }
                                }
                            }
                            .padding(.vertical, DesignSystem.Spacing.xSmall)
                        }
                        .scrollIndicators(.hidden)
                    }
                }

                if viewModel.availableTypes.isEmpty {
                    Text("Product types appear after your first entry.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("Type")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                        ScrollView(.horizontal) {
                            HStack(spacing: DesignSystem.Spacing.small) {
                                FilterChipView(title: "All", isSelected: viewModel.selectedTypeId == nil) {
                                    viewModel.selectedTypeId = nil
                                }
                                ForEach(viewModel.availableTypes) { type in
                                    FilterChipView(title: type.name, isSelected: viewModel.selectedTypeId == type.id) {
                                        viewModel.toggleTypeFilter(type)
                                    }
                                }
                            }
                            .padding(.vertical, DesignSystem.Spacing.xSmall)
                        }
                        .scrollIndicators(.hidden)
                    }
                }

                if viewModel.hasActiveFilters {
                    Button("Clear Filters", systemImage: "xmark.circle") {
                        viewModel.clearFilters()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
