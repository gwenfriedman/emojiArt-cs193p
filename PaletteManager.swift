//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Gwen Friedman on 2/25/22.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
//    @Environment(\.colorScheme) var colorScheme
    
    //binding
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name)
                                //changes the text size based on dark/light mode, but it isn't working
//                                .font(colorScheme == .dark ? .largeTitle : .caption)
                            Text(palette.emojis)
                        }
                        .gesture(editMode == .active ? tap : nil)
                    }
                }
                //teaching forEach how to do delete and move
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            
            //overrides the environment
//            .environment(\.colorScheme, .dark)
            //use the binding to see if list is in edit mode
            .toolbar {
                ToolbarItem {
                //built in, toggles the value of editMode
                    EditButton()
                }
                
                //only show on iphone
                ToolbarItem(placement: .navigationBarLeading) {
                    if presentationMode.wrappedValue.isPresented,
                       UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            environment(\.editMode, $editMode)
        }
    }
    
    var tap: some Gesture {
        TapGesture().onEnded {
            //can add code for on tap
        }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
//            .previewDevice("iPhone 8")
            .environmentObject(PaletteStore(named: "Preview"))
        
    }
}
