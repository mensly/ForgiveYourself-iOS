//
//  ContentView.swift
//  Forgive Yourself
//
//  Created by Michael Ensly on 7/2/21.
//

import SwiftUI

private let KEY_MISTAKES = "mistakes"

struct Mistake {
    var id: String
    var text: String
}

private func loadMistakes() -> [Mistake] {
    guard let mistakes = UserDefaults.standard.array(forKey: KEY_MISTAKES) else { return [] }
    return mistakes.map { (text: Any) -> Mistake in
        Mistake(id: UUID().description, text: text as! String)
    }
}

private func saveMistakes(mistakes: [Mistake]) {
    UserDefaults.standard.set(mistakes.map(\.text), forKey: KEY_MISTAKES)
}

struct ContentView: View {
    @State var mistakes: [Mistake] = loadMistakes()
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
                    saveMistakes(mistakes: mistakes)
                    mistake = ""
                }
                Button("Forgive Yourself") {
                    mistakes = []
                    saveMistakes(mistakes: mistakes)
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
