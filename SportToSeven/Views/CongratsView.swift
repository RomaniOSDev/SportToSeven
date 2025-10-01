//
//  CongratsView.swift
//  SportToSeven
//
//  Created by Jack Reess on 08.09.2025.
//

import SwiftUI

struct CongratsView: View {
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 24) {
                // Success icon
                ZStack {
                    Circle()
                        .foregroundStyle(.secondCLR)
                        .opacity(0.1)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.secondCLR)
                }
                
                VStack(spacing: 8) {
                    Text("Congratulations!")
                        .foregroundStyle(.main)
                        .font(.largeTitle)
                    
                    Text("Workout completed. Keep it up!")
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
    }
}

#Preview {
    CongratsView()
}



