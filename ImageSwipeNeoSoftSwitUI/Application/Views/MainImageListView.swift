//
//  ContentView.swift
//  ImageSwipeNeoSoftSwitUI
//
//  Created by RudreshUppin on 25/04/25.
//

import SwiftUI



import SwiftUI

struct MainImageListView: View {
    
    private let cardHeight: CGFloat = 40
    @StateObject private var viewModel = ContentViewModel()
    @State private var isShowingBottomSheet = false

    var searchBar: some View {
        HStack {
            Image(systemName: NeoSoftStrings.Magnifyingglass.rawValue).foregroundColor(NeoSoftAppColors.grayColor)
            TextField(NeoSoftStrings.SearchAuthors.rawValue, text: $viewModel.searchText)
                .foregroundColor(NeoSoftAppColors.primary)
                .frame(maxWidth: .infinity)
            if !viewModel.searchText.isEmpty {
                Button { viewModel.searchText = "" } label: {
                    Image(systemName: NeoSoftStrings.XmarkCircleFill.rawValue).foregroundColor(NeoSoftAppColors.grayColor)
                }
                .padding(.trailing, 5)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(NeoSoftAppColors.textFieldColor)
        .cornerRadius(12)
        .padding(.bottom, 5)
    }

    var carouselView: some View {
        VStack(spacing: 5) {
            TabView(selection: $viewModel.selectedCarouselIndex) {
                ForEach(viewModel.carouselItems.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: viewModel.carouselItems[index].download_url)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            Image(systemName: NeoSoftStrings.PhotoFill.rawValue)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(NeoSoftAppColors.grayColor)
                        default:
                            ProgressView()
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                    .tag(index)
                }
            }
            .frame(height: 200)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .cornerRadius(15)

            // Carousel Indicators
            HStack(spacing: 8) {
                ForEach(0..<viewModel.carouselItems.count, id: \.self) { index in
                    Circle()
                        .fill(index == viewModel.selectedCarouselIndex ? NeoSoftAppColors.blueColor : NeoSoftAppColors.grayColorWithOpacity)
                        .frame(width: 8, height: 8)
                }
            }
         
        }
      
    }

    @ViewBuilder
    func listItemRow(item: CarouselItems) -> some View {
         HStack(spacing: 15) {
             AsyncImage(url: URL(string: item.download_url)) { phase in
                 switch phase {
                 case .empty: ProgressView().frame(width: 50, height: 50)
                 case .success(let image): image.resizable().scaledToFill()
                 case .failure: Image(systemName: NeoSoftStrings.PhotoFill.rawValue)
                         .resizable()
                         .scaledToFit()
                         .foregroundColor(NeoSoftAppColors.grayColor)
                 @unknown default: EmptyView()
                 }
             }
             .frame(width: 50, height: 50)
             .background(Color.gray.opacity(0.1))
             .cornerRadius(8)
             .clipped()

             VStack(alignment: .leading) {
                 Text(item.author).font(.headline)
                 Text("List Item Subtitle").font(.subheadline).foregroundColor(.gray)
             }
             Spacer()
         }
         .padding(10)
         .background(NeoSoftAppColors.cellColor)
         .cornerRadius(12)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section {
                        carouselView
                            .padding(.vertical, 10)

                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    Section {
                        ForEach(viewModel.filteredItems) { item in
                            listItemRow(item: item)

                        }
                    } header: {
                        searchBar

                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
                .navigationTitle(NeoSoftStrings.ContentFeed.rawValue)
                .navigationBarTitleDisplayMode(.inline)
                .padding(.horizontal, 20)
                .scrollIndicators(.hidden)

                Button {
                    isShowingBottomSheet = true
                } label: {
                    Image(NeoSoftStrings.MoreMenuIcon.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(10)
                        .background(NeoSoftAppColors.moreBtnBlueColor)
                        .foregroundColor(NeoSoftAppColors.whiteColor)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                .sheet(isPresented: $isShowingBottomSheet) {
                    //  items: ["apple", "banana", "orange", "blueberry", "raspberry", "grape", "Pineapple"],

                    ActionSheetContentView(
                            items: ["apple", "banana", "orange", "blueberry"],
                            listTitle: "List 1"
                        )
                    
//                    ActionSheetContentView(
//                        items: viewModel.filteredItems.map { $0.author },
//                        listTitle: "Authors List"
//                    )
                }
            }
           
        }
        .background(NeoSoftAppColors.bgColor)
    }
}
