import SwiftUI

enum AssetManager {
    static let cardsPath = "cards"
    
    static func verifyAssets() {
        #if DEBUG
        DeckService.shared.loadDeck().forEach { card in
            let imageName = card.fullImageName
            assert(UIImage(named: imageName) != nil,
                   "Missing card image: \(imageName)")
        }
        #endif
    }
}

// MARK: - Required Assets Checklist
/*
 1. Colors:
    - DarkViolet (#1A0B2E)
    - MysticalPurple (#4A2B6B)
 
 2. Major Arcana Images (0-21):
    - cards/major/fool.png
    - cards/major/magician.png
    - cards/major/highpriestess.png
    - cards/major/empress.png
    - cards/major/emperor.png
    - cards/major/hierophant.png
    - cards/major/lovers.png
    - cards/major/chariot.png
    - cards/major/strength.png
    - cards/major/hermit.png
    - cards/major/wheel.png
    - cards/major/justice.png
    - cards/major/hangedman.png
    - cards/major/death.png
    - cards/major/temperance.png
    - cards/major/devil.png
    - cards/major/tower.png
    - cards/major/star.png
    - cards/major/moon.png
    - cards/major/sun.png
    - cards/major/judgement.png
    - cards/major/world.png
 
 3. Minor Arcana Images:
    Wands (22-35):
    - cards/minor/wands_ace.png through cards/minor/wands_king.png
    
    Cups (36-49):
    - cards/minor/cups_ace.png through cards/minor/cups_king.png
    
    Swords (50-63):
    - cards/minor/swords_ace.png through cards/minor/swords_king.png
    
    Pentacles (64-77):
    - cards/minor/pentacles_ace.png through cards/minor/pentacles_king.png
 
 Note: All images should be:
 - High resolution (at least 600x900px)
 - 2:3 aspect ratio
 - PNG format with transparency
 - Optimized for file size
*/ 