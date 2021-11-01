//
//  ContentView.swift
//  Shared
//
//  Created by Neil McEvoy on 2021-11-01.
//

import MetalUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            MetalView{
                BasicMetalView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
