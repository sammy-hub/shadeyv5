import SwiftUI

struct ClientRowView: View {
    let client: Client

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ClientAvatarView(initials: client.initials)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(client.name)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                if !subtitleText.isEmpty {
                    Text(subtitleText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer(minLength: 8)
            
            if !client.sortedServices.isEmpty {
                Text("\(client.sortedServices.count)")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var subtitleText: String {
        var parts: [String] = []
        
        if let lastDate = client.sortedServices.first?.date {
            parts.append(lastDate.formatted(AppFormatters.dateAbbreviated))
        } else {
            parts.append("No visits yet")
        }
        
        if !client.sortedServices.isEmpty {
            parts.append("\(client.sortedServices.count) services")
        }
        
        return parts.joined(separator: " • ")
    }
}
