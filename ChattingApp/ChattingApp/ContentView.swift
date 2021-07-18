//
//  ContentView.swift
//  ChattingApp
//
//  Created by Nitin Bhatt on 7/18/21.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented = false
    
    var body: some View {
        VStack{
            Button(action:{
                isPresented.toggle()
            }){
                Text("Open Chat Window")
            }.fullScreenCover(isPresented: $isPresented, content: {
                MessagesView()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
