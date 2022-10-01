//
//  ItemsView.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import SwiftUI

struct ItemsView: View {
    @StateObject var viewModel = ItemsViewModel()

    var body: some View {
        List(1..<100) { row in
                    Text("Row \(row)")
        }.refreshable(action:self.viewModel.refresh())
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
