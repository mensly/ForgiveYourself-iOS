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

private let EDGE_INSETS = EdgeInsets(top: NO_PADDING, leading: PADDING, bottom: NO_PADDING, trailing: PADDING)

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
    @State private var mistakes: [Mistake] = loadMistakes()
    @State private var mistake: String = ""
    @State private var showingClearPrompt = false
    @State private var showingNotificationPrompt = false
    @State private var showingNotifications = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Enter mistake", text: $mistake, onCommit: { addMistake() })
                    .padding(EDGE_INSETS)
                Button("Add") { addMistake() }
                    .accentColor(ACCENT_COLOR)
                    .padding(EDGE_INSETS)
                    .disabled(mistake.isEmpty)
                Button("Forgive Yourself") {
                    showingClearPrompt = true
                }
                    .disabled(mistakes.count == 0)
                    .accentColor(ACCENT_COLOR)
                    .padding(EDGE_INSETS)
                List(mistakes, id: \.id) { mistake in
                    Text(mistake.text)
                }
            }
            .navigationBarTitle("Forgive Yourself")
            .navigationBarItems(leading: NavigationLink("Help", destination: HelpView())
                                    .accentColor(ACCENT_COLOR)
                                    .padding(EDGE_INSETS),
                                trailing: NavigationLink(destination: NotificationView(), isActive: $showingNotifications, label: { Text("Notifications") })
                                    .accentColor(ACCENT_COLOR)
                                    .padding(EDGE_INSETS))
            .alert(isPresented: $showingNotificationPrompt) {
                Alert(title: Text("Would you like to configure a notification?"),
                      primaryButton: .default(Text("Yes")) {
                        showingNotifications = true
                      },
                      secondaryButton: .default(Text("No")))
            }
        }.accentColor(ACCENT_COLOR)
            .alert(isPresented: $showingClearPrompt) {
                Alert(title: Text("Are you sure you have forgiven yourself?"),
                      primaryButton: .default(Text("Yes")) {
                        mistakes = []
                        saveMistakes(mistakes: mistakes)
                      },
                      secondaryButton: .default(Text("No")))
            }
    }
    
    private func addMistake() {
        if mistake.isEmpty {
            return
        }
        mistakes.append(Mistake(id: UUID().description, text: mistake))
        saveMistakes(mistakes: mistakes)
        mistake = ""
        if mistakes.count == 1 && !isNotificationEnabled() {
            showingNotificationPrompt = true
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
