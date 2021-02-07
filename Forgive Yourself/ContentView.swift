//
//  ContentView.swift
//  Forgive Yourself
//
//  Created by Michael Ensly on 7/2/21.
//

import SwiftUI

struct Mistake {
    var id: String
    var text: String
}

struct ContentView: View {
    @State var mistakes: [Mistake] = [Mistake(id: "1", text: "Test 1"), Mistake(id: "2", text: "Test 2")]
    @State private var mistake: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Enter mistake", text: $mistake)
                Button("Add") {
                    if (mistake.isEmpty) {
                        return
                    }
                    mistakes.append(Mistake(id: UUID().description, text: mistake))
                    mistake = ""
                }
                Button("Forgive Yourself") {
                    mistakes = []
                }
                List(mistakes, id: \.id) { mistake in
                    Text(mistake.text)
                }
            }
            .navigationBarTitle("Forgive Yourself")
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
