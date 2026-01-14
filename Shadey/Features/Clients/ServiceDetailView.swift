import SwiftUI

struct ServiceDetailView: View {
    let service: Service

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ServiceSummaryCardView(service: service)
                ServicePhotosCardView(beforeData: service.beforePhoto, afterData: service.afterPhoto)
                ServiceFormulaCardView(service: service)
            }
            .padding()
        }
        .background(DesignSystem.background)
        .navigationTitle(service.date.formatted(AppFormatters.dateAbbreviated))
    }
}
