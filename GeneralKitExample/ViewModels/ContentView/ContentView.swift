//
//  ContentView.swift
//  GeneralKitExample
//
//  Created by Salah on 9/24/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State var userListFromNetworkWithPagination:Int? = 0
    @State var postListFromNetworkWithPagination:Int? = 0
    @State var loginScreen:Int? = 0
    @State var simulateRemoteResponse:Int? = 0

    var body: some View {
        VStack {
            HStack{
                Text("SwiftUI Example:").font(Font.system(size:21,weight:.bold))
                Spacer()
            }
            NavigationLink(destination: PageUserListView(), tag: 1, selection: $userListFromNetworkWithPagination) {
               EmptyView()
             }
            NavigationLink(destination:OffsetUserListView(), tag: 1, selection:$postListFromNetworkWithPagination) {
               EmptyView()
             }
            NavigationLink(destination: NormalNetworkExampleView(), tag: 1, selection: $loginScreen) {
               EmptyView()
             }
            NavigationLink(destination: SimulateRemoteResponseView(), tag: 1, selection: $simulateRemoteResponse) {
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
                    Text("Normal Request Examples(Data From Network)").font(.system(size: 16,weight:.semibold))
                }
            }.padding([.bottom],16.0)
            
            Button.init {
                userListFromNetworkWithPagination=1;
            } label: {
                HStack{
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Pagination List base on page number (Data From Network)").font(.system(size: 16,weight:.semibold))
                }
            }
                Button.init {
                    postListFromNetworkWithPagination=1;
                } label: {
                    HStack{
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        Text("Pagination List base on offset (Data From Network)").font(.system(size: 16,weight:.semibold))
                    }
                }
                Button.init {
                    simulateRemoteResponse=1;
                } label: {
                    HStack{
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        Text("Simulate Remote Response By Local File Json").font(.system(size: 16,weight:.semibold))
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
