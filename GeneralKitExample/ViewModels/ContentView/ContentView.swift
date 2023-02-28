//
//  ContentView.swift
//  GeneralKitExample
//
//  Created by Salah on 9/24/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State var listFromNetworkWithPagination:Int? = 0
    @State var loginScreen:Int? = 0

    var body: some View {
        VStack {
            NavigationLink(destination: ItemsView(), tag: 1, selection: $listFromNetworkWithPagination) {
               EmptyView()
             }
            NavigationLink(destination: NormalNetworkExampleView(), tag: 1, selection: $loginScreen) {
               EmptyView()
             }
            List{

            Button.init {
                loginScreen=1;
            } label: {
                HStack{
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Normal Request Examples(Data From Network)")
                }
            }.padding([.bottom],16.0)
            
            Button.init {
                listFromNetworkWithPagination=1;
            } label: {
                HStack{
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("List With Pagination Request Example(Data From Network)")
                }
            }
            }.listStyle(InsetListStyle.init()).navigationTitle("How Use GeneralKit")

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
