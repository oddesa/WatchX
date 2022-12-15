//
//  MovieBackdropCardView.swift
//  WatchX
//
//  Created by Jehnsen Kane on 01/09/21.
//

import SwiftUI

struct MovieBackdropCardView: View {
    
    let movie: Movie
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                if self.imageLoader.image != nil {
                    Image(uiImage: self.imageLoader.image!)
                        .resizable()
                }
            }
            .aspectRatio(16/9 ,contentMode: .fit)
            .cornerRadius(8)
            .shadow(radius: 4)
            Text(movie.title)
        }
        .lineLimit(1)
        .onAppear(perform: {
            self.imageLoader.loadImage(with: self.movie.backdropURL)
        })
    }
}

struct MovieBackdropCardView_Previews: PreviewProvider {
    static var previews: some View {
        MovieBackdropCardView(movie: Movie.stubbedMovie)
    }
}
