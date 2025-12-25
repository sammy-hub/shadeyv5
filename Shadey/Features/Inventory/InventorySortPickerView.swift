import SwiftUI

struct InventorySortPickerView: View {
    @Binding var sortOption: ProductSortOption

    var body: some View {
        Picker("Sort", selection: $sortOption) {
            ForEach(ProductSortOption.allCases) { option in
                Text(option.displayName)
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
    }
}
