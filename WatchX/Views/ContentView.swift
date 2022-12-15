//
//  ContentView.swift
//  WatchX
//
//  Created by Jehnsen Kane on 31/08/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MovieListView()
                .tabItem {
                    VStack {
                        Image(systemName: "tv")
                        Text("Movies")
                    }
                }
                .tag(0)
            
            MovieSearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
