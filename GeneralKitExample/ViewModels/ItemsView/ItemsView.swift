//
//  ItemsView.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import SwiftUI
struct ItemsView: View {
    @StateObject var viewModel = ItemsViewModel()
    @State var headerSize: CGSize = .zero

    var body: some View {
        ZStack{
            List{
                ForEach(viewModel.list, id: \.id) { item in
                        Text("\(item.id?.stringValue ?? "") \(item.username ?? "")")
                }
                if self.viewModel.paginationManager.hasNextPage {
                    LoadMoreView.init(action: self.viewModel.loadMore())
                }
            }.refreshable(action:self.viewModel.refresh())
            .listStyle(InsetListStyle.init())
        }.navigationTitle("List With Pagination Request (Data From Network)")
                
        }
      
    }

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
struct LoadMoreView: View {
    var action:() -> Void
    var body: some View {
        ZStack{
            VStack{
                ActivityIndicator.init(style:.medium, isAnimating: .constant(true))
            }.frame(maxWidth: .infinity, alignment: .center)
        }.frame(alignment:.center)
        .padding()
        .onAppear(perform:action)
        .listRowSeparator(.hidden)
    }
}

@available(iOS 13.0, *)
public struct ActivityIndicator: UIViewRepresentable {

    @Binding public var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    public init(style:UIActivityIndicatorView.Style,isAnimating:Binding<Bool>) {
        _isAnimating = isAnimating
        self.style = style
     }
    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
