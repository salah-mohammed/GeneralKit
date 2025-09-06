//
//  PageUserListView.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import SwiftUI
import SalahUtility
struct PageUserListView: View {
    @StateObject var viewModel = PageUserListViewModel()
    @State var headerSize: CGSize = .zero

    var body: some View {
        ZStack{
            List{
                ForEach(viewModel.list, id: \.self) { item in
                        Text("\(item.id.stringValue) \(item.username ?? "")")
                }
                if self.viewModel.paginationManager.hasNextPage {
                    LoadMoreView.init(action: self.viewModel.loadMore())
                }
            }.refreshable(action:self.viewModel.refresh())
            .listStyle(InsetListStyle.init())
        }.navigationTitle("List With Pagination Request (Data From Network)")
                
        }
      
    }

struct PageUserListView_Previews: PreviewProvider {
    static var previews: some View {
        PageUserListView()
    }
}
struct LoadMoreView: View {
    var action:() -> Void
    var body: some View {
        ZStack{
            VStack{
                ActivityIndicator.init(style:.medium, isAnimating: .constant(true))
            }.frame(maxWidth: .infinity, alignment: .center)
        }.frame(alignment:.center)
        .padding()
        .onAppear(perform:action)
        .listRowSeparator(.hidden)
    }
}
