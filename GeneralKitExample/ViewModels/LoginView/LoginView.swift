//
//  ContentView.swift
//  GeneralKitExample
//
//  Created by Salah on 9/24/22.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State var showItems:Int? = 0

    var body: some View {
        VStack {
            NavigationLink(destination: ItemsView(), tag: 1, selection: $showItems) {
               EmptyView()
             }
            Button.init {
                self.viewModel.loginRequest()
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
