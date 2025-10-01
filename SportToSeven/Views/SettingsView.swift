//
//  SettingsView.swift
//  SportToSeven
//
//  Created by Jack Reess on 08.09.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingResetAlert = false
    @State private var showingPrivacyPolicy = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()
                
                List {
                // App Info Section
                Section {
                    HStack {
                        AppIcon(
                            systemName: "dumbbell.fill",
                            size: 20,
                            color: .main,
                            backgroundColor: .main.opacity(0.1)
                        )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("7-Minute Workout")
                                .appHeadline()
                            Text("Version 1.0.0")
                                .appCaption()
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("About App")
                        .appHeadline()
                }
                
                // Actions Section
                Section {
                    SettingsRowView(
                        icon: "star.fill",
                        iconColor: .yellow,
                        title: "Rate App",
                        action: { rateApp() }
                    )
                    
                    SettingsRowView(
                        icon: "doc.text.fill",
                        iconColor: .blue,
                        title: "Privacy Policy",
                        action: {
                            if let url = URL(string: "https://www.termsfeed.com/live/496440cb-7d44-4a3b-8c69-0924a5e2ed1d") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                } header: {
                    Text("Actions")
                        .appHeadline()
                }
                
                // Data Section
                Section {
                    SettingsRowView(
                        icon: "trash.fill",
                        iconColor: .red,
                        title: "Reset All Data",
                        action: { showingResetAlert = true }
                    )
                } header: {
                    Text("Data")
                        .appHeadline()
                } footer: {
                    Text("This action will delete all your workouts, progress and settings. Data cannot be recovered.")
                        .appCaption()
                }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Reset All Data", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("Are you sure you want to delete all data? This action cannot be undone.")
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
        }
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func resetAllData() {
        let store = LocalStore.shared
        
        // Reset streak
        store.streakDays = 0
        store.lastWorkoutDate = nil
        
        // Reset history
        UserDefaults.standard.removeObject(forKey: "workout.history")
        
        // Reset custom workouts to defaults
        store.customWorkouts = CustomWorkoutLibrary.defaultWorkouts
        
        // Show success feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

struct SettingsRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                AppIcon(
                    systemName: icon,
                    size: 16,
                    color: iconColor,
                    backgroundColor: iconColor.opacity(0.1)
                )
                
                Text(title)
                    .appBody()
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.title.bold())
                    
                    Text("Last updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        PolicySection(
                            title: "Data Collection",
                            content: "The '7-Minute Workout' app does not collect or transmit personal user data. All data (workout progress, custom workouts) is stored locally on your device."
                        )
                        
                        PolicySection(
                            title: "Local Storage",
                            content: "The app uses UserDefaults to store your progress, streak and custom workouts. This data remains on your device and is not transmitted to third parties."
                        )
                        
                        PolicySection(
                            title: "App Rating",
                            content: "When requesting an app rating, the built-in Apple StoreKit system is used, which does not transmit any personal data."
                        )
                        
                        PolicySection(
                            title: "Policy Changes",
                            content: "We may update this privacy policy. Any changes will be communicated through app updates."
                        )
                        
                        PolicySection(
                            title: "Contact",
                            content: "If you have questions about this privacy policy, please contact us through the App Store."
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    SettingsView()
}
