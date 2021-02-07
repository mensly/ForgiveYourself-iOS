//
//  HelpView.swift
//  Forgive Yourself
//
//  Created by Michael Ensly on 8/2/21.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("The purpose of this application is to help track your mistakes during the year.")
            Text("At least once a year you should forgive yourself and wipe the slate clean.")
            Text("You cannot edit or remove individual items, only forgive yourself by wiping the slate.")
            Text("If you need help doing so, these numbers might be useful:")
            Button("Australia: BeyondBlue") {
                EnvironmentValues.init().openURL(URL(string: "tel:1300224636")!)
            }.accentColor(ACCENT_COLOR)
            Button("UK: SupportLine") {
                EnvironmentValues.init().openURL(URL(string: "tel:01708765200")!)
            }.accentColor(ACCENT_COLOR)
            Button("USA: SAMHSA") {
                EnvironmentValues.init().openURL(URL(string: "tel:18009855990")!)
            }.accentColor(ACCENT_COLOR)
            Text("Note: This app is not associated with the above services.")
            Spacer()
        }.padding()
        .navigationBarTitle("Help")
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
