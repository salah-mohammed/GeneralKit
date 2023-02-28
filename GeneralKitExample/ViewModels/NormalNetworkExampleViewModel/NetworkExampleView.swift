//
//  NetworkExampleView.swift
//  GeneralKitExample
//
//  Created by Salah on 9/24/22.
//

import SwiftUI

struct NetworkExampleView: View {
    @StateObject var viewModel = NetworkExampleViewModel()
    @State var showItems:Int? = 0

    var body: some View {
        VStack(spacing:8) {
            NavigationLink(destination: ItemsView(), tag: 1, selection: $showItems) {
               EmptyView()
             }
            Text("How Use Normal Request:")
                Button.init {
                    self.viewModel.requestExample1()
                } label: {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Request Example_1")
                }
                Button.init {
                    self.viewModel.requestExample2()
                } label: {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Request Example_2")
                }
            Button.init {
                self.viewModel.requestMultipart()
            } label: {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Multipart Request")
            }

        }.navigationTitle("Normal Request(Data From Network)")
        .padding()
    }
}

struct NetworkExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkExampleView()
    }
}
