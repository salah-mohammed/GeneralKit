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
    @State var headerSize: CGSize = .zero

    var body: some View {
        ZStack{
            GeometryReader { proxy in
                List {
//                    GeometryReader { proxy2 in
                        Section(
                            header: Color.red
                                .frame(height: self.headerSize.height)
                                .listRowInsets(EdgeInsets())
                                .anchorPreference(key: ScrollOffsetPreferenceKey.self, value: .bounds) {
                                    proxy[$0].origin
                                }
                                .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: { offset in
//                                    debugPrint("offset:\(offset.y)")
//                                    debugPrint("proxy:\(proxy.size)")
//                                    debugPrint("proxy2:\(proxy2.size)")
                                    
                                })
                        ) {
                            
                        }
                    Group.init {
                        ForEach(self.viewModel.list, id: \.id) {
                                Text($0.id?.stringValue ?? "")
                        }
                    }
                        Section() {
                          
                        }.background(
                            GeometryReader { proxy in
                                Color.clear.onAppear {
                                    print(proxy.size.height)
                                }
                            })
//                    }
                }.listStyle(GroupedListStyle())
                
              }
          
       
            /*
            List{
                Section() {
                    ForEach(viewModel.list, id: \.id) { item in
                        Text("\(item.id?.stringValue ?? "") \(item.username ?? "")")
                        
                    }
                }.background(GeometryReader{
                    let value = -$0.frame(in: .named("scroll")).origin.y;
                    let height = $0.size.height
//                    if (value+height) >= (height-30) && height > 0{
                        Color.clear.preference(key: ViewOffsetKey.self,
                                               value: -$0.frame(in: .named("scroll")).origin.y)
//                    }
                }) .onPreferenceChange(ViewOffsetKey.self) { value in
                    //                print("a")
                    print("\nvalue:\(value)")
//                    self.viewModel.moreAction()
                }
            }.coordinateSpace(name: "scroll")
            .refreshable(action:self.viewModel.refresh())
            .listStyle(InsetListStyle.init())
          
         */
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

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
