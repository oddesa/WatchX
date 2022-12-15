//
//  ActivityIndicatorView.swift
//  WatchX
//
//  Created by Jehnsen Kane on 01/09/21.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        //kosong pak
    }
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    
}
