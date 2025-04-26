//
//  ActionSheetContentView.swift
//  ImageSwipeNeoSoftSwitUI
//
//  Created by RudreshUppin on 26/04/25.
//

import SwiftUI


import SwiftUI

struct ActionSheetContentView: View {
    @Environment(\.dismiss) var dismiss
    let items: [String]
    let listTitle: String?

    init(items: [String], listTitle: String? = nil) {
        self.items = items
        self.listTitle = listTitle
    }

    private var itemCount: Int {
        items.count
    }

    private var topCharacters: [(Character, Int)] {
        var frequencies: [Character: Int] = [:]
        for item in items {
            for character in item.lowercased() where character.isLetter {
                frequencies[character, default: 0] += 1
            }
        }
        let sortedFrequencies = frequencies.sorted { $0.value > $1.value }
        let top3 = sortedFrequencies.prefix(3)
        return Array(top3)
    }

    private var formattedListTitle: String {
        let baseTitle = listTitle ?? "Current List"
        return "\(baseTitle) (\(itemCount) item\(itemCount == 1 ? "" : "s"))"
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            VStack(alignment: .leading, spacing: 8) {
                Text(formattedListTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)

                if !topCharacters.isEmpty {
                    Text("Top Characters:")
                        .font(.body)
                        .fontWeight(.medium)
                        .padding(.top, 5)

                    ForEach(topCharacters, id: \.0) { character, count in
                        HStack {
                            Text("\(String(character)) = \(count)")
                            Spacer()
                        }
                        .font(.subheadline)
                        .foregroundColor(NeoSoftAppColors.secondaryColor)
                    }
                } else if !items.isEmpty {
                     Text("No alphabetic characters found.")
                        .font(.subheadline)
                        .foregroundColor(NeoSoftAppColors.secondaryColor)
                }
            }
            .padding()
            .background(NeoSoftAppColors.systemBackground)
            .cornerRadius(10)

            Spacer()

            // --- Cancel Button ---
            HStack {
                 Spacer()
                 Button("Cancel", role: .cancel) {
                     dismiss()
                 }
                 .buttonStyle(.bordered)
                 .controlSize(.large)
                 Spacer()
             }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

