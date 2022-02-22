//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    
    //eventually this won't be a let
    let document = EmojiArtDocument()
    let paletteStore = PaletteStore(named: "default")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
