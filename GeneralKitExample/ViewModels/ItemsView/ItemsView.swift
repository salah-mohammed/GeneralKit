//
//  ItemsView.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import SwiftUI
import SalahUtility
struct ItemsView: View {
    @StateObject var viewModel = ItemsViewModel()

    var body: some View {
        ZStack{
            List(viewModel.list, id: \.self.id) {item in
            Text("\(item.id?.stringValue ?? "") \(item.username ?? "")")
            }.listStyle(InsetListStyle.init()).refreshable(action:self.viewModel.refresh()).onPreferenceChange(ViewOffsetKey.self) { _ in
                self.viewModel.moreAction()
            }
        }
      
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
