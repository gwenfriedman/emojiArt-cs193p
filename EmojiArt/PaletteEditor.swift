//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Gwen Friedman on 2/25/22.
//

import SwiftUI

struct PaletteEditor: View {
    
    //Binding allows the paletteEditor to edit a palette that is somewhere else. can not be private
    @Binding var palette: Palette
    
    var body: some View {
        
        Form {
            nameSection
            addEmojisSection
            removeEmojiSection
        }
        .navigationTitle("Edit \(palette.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            //bind the text that's being edited to the name field in the @State
            TextField("Name", text: $palette.name)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            palette.emojis = (emojis + palette.emojis)
                .filter { $0.isEmoji }
//            TODO: this doesn't work
//            .removingDuplicateCharacters
        }
    }
        
    @State private var emojisToAdd = ""
        
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            //bind the text that's being edited to the name field in the @State
            TextField("", text: $emojisToAdd)
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            //.removingDuplicateCharacters
            let emojis = palette.emojis.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 4)))
            .previewLayout(.fixed(width: 300, height: 350))
    }
}

