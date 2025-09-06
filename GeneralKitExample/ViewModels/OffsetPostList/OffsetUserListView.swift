//
//  OffsetUserListView.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import SwiftUI
import SalahUtility
struct OffsetUserListView: View {
    @StateObject var viewModel = OffsetUserListViewModel()
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

struct OffsetUserListView_Previews: PreviewProvider {
    static var previews: some View {
        PageUserListView()
    }
}
