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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
