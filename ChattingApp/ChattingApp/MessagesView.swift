//
//  MessagesView.swift
//  ChattingApp
//
//  Created by Nitin Bhatt on 7/18/21.
//

import SwiftUI

struct ChatMessage:Identifiable{
    var id = Int()
    var message = String()
}

class ChatMessageModel:ObservableObject{
    @Published var chatHistory = [ChatMessage]()
}

struct MessagesView: View {
    @State var textViewValue = String()
    @State var textViewHeight:CGFloat = 50.0
    
    @ObservedObject var messages = ChatMessageModel()
    
    var body: some View {
        VStack{
            List(messages.chatHistory, id: \.id){ message in
                Text(message.message)
            }
            HStack{
               ResizeableTextView(text: $textViewValue, height: $textViewHeight, placeholderText: "Type a message").frame(height: textViewHeight < 160 ? self.textViewHeight : 160).cornerRadius(20)
                Button(action: {
                    messages.chatHistory.append(ChatMessage(id: messages.chatHistory.count, message: textViewValue))
                    MessagesView.endEditing()
                    textViewValue = ""
                }){
                    Text("Send").fontWeight(.bold)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                }
            }.padding(10)
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}




struct ResizeableTextView: UIViewRepresentable{
    @Binding var text:String
    @Binding var height:CGFloat
    var placeholderText: String
    @State var editing:Bool = false
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.text = placeholderText
        textView.delegate = context.coordinator
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        if self.text.isEmpty == true{
            textView.text = self.editing ? "" : self.placeholderText
            textView.textColor = self.editing ? .white : .lightGray
        }
        
        DispatchQueue.main.async {
            self.height = textView.contentSize.height
            textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        ResizeableTextView.Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate{
        var parent: ResizeableTextView
        
        init(_ params: ResizeableTextView) {
            self.parent = params
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
               self.parent.editing = true
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
               self.parent.editing = false
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
        
        
    }
    
}


extension View{
    static func endEditing(){
        UIApplication.shared.windows.forEach{$0.endEditing(false)}
    }
}
