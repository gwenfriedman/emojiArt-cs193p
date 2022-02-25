//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Gwen Friedman on 2/25/22.
//

import SwiftUI

struct PaletteChooser: View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font {.system(size:emojiFontSize)}
    
    @EnvironmentObject var store : PaletteStore
    
    @State private var chosenPaletteIndex = 0
    
    var body: some View {
        let palette = store.palette(at: chosenPaletteIndex)
        HStack {
            paletteControlButton
            body(for: palette)
        }
        .clipped()
    }
    
    var paletteControlButton: some View {
        Button {
            withAnimation {
                //TODO: this isn't working
                chosenPaletteIndex = chosenPaletteIndex + 1 % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        
        //view builder
        .contextMenu { contextMenu }
    }
    
    @ViewBuilder
    var contextMenu: some View {
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
//            editing = true
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
//            editing = true
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
            managing = true
        }
        goToMenu
    }
    
    var goToMenu: some View {
        Menu {
            ForEach (store.palettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = store.palettes.index(matching: palette) {
                        chosenPaletteIndex = index
                    }
                }
            }
        } label : {
            Label("Go To", systemImage: "text.insert")
        }
    }
    
    func body(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojisView(emojis: palette.emojis)
                .font(emojiFont)
        }
        //add the id so that the view is replaced when the palette is changed
        .id(palette.id)
        .transition(rollTransition)
        //put the popover up (what the view points to)
//        .popover(isPresented: $editing) {
//            PaletteEditor(palette: $store.palettes[chosenPaletteIndex])
//        }
        
        .popover(item: $paletteToEdit) { palette in
            //can do this because of utility function
            //cleaner than the bool version
            PaletteEditor(palette: $store.palettes[palette])
        }
        
        //This could go anywhere because it's a sheet
        .sheet(isPresented: $managing) {
            PaletteManager()
        }
    }
    
//    @State private var editing = false
    @State private var paletteToEdit: Palette?
    @State private var managing = false
    
    var rollTransition: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .offset(x: 0, y: emojiFontSize),
            removal: .offset(x: 0, y: -emojiFontSize))
    }
}

struct ScrollingEmojisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
//                TODO: add removingDuplicateCharacters
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        //Drag
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
