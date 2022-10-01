//
//  ContentView.swift
//  GeneralKitExample
//
//  Created by Salah on 9/24/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State var showItems:Int? = 0

    var body: some View {
        VStack {
            NavigationLink(destination: ItemsView(), tag: 1, selection: $showItems) {
               EmptyView()
             }
            Button.init {
                showItems=1;
            } label: {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }


        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
