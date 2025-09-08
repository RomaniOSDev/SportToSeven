import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var navigateToWorkout = false
    @State private var navigateToCustomWorkouts = false
    @State private var navigateToSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            Text("7-Minute Workout")
                                .appTitle()
                            
                            // Today's progress with circular indicator
                            AppCard {
                                VStack(spacing: 12) {
                                    Text("Today")
                                        .appHeadline()
                                    
                                    AppCircularProgress(
                                        progress: min(1.0, Double(viewModel.todaySeconds) / 420.0),
                                        size: 80,
                                        lineWidth: 6
                                    )
                                    
                                    VStack(spacing: 2) {
                                        Text("\(viewModel.todaySeconds / 60)")
                                            .font(.title2.bold())
                                            .monospacedDigit()
                                            .foregroundColor(.main)
                                        Text("min")
                                            .appCaption()
                                    }
                                }
                            }
                        }
                        
                        AppCard {
                            VStack(spacing: 12) {
                                Text("Streak")
                                    .appHeadline()
                                
                                HStack(spacing: 16) {
                                    AppIcon(
                                        systemName: "flame.fill",
                                        size: 20,
                                        color: .white,
                                        backgroundColor: .secondCLR
                                    )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(viewModel.streakDays)")
                                            .font(.title.bold())
                                            .monospacedDigit()
                                            .foregroundColor(.main)
                                        Text("days in a row")
                                            .appCaption()
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        Spacer()
                        
                        
                        VStack(spacing: 16) {
                            Button(action: { navigateToWorkout = true }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "play.fill")
                                    Text("Start Workout")
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle(size: .large))
                            .padding(.horizontal)
                            
                            Button(action: { navigateToCustomWorkouts = true }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("My Workouts")
                                }
                            }
                            .buttonStyle(SecondaryButtonStyle(size: .large))
                            .padding(.horizontal)
                        }
                        
                    }
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigateToSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.main)
                    }

                }
            })
            .onAppear { viewModel.refresh() }
            .navigationDestination(isPresented: $navigateToWorkout, destination: {
                WorkoutView()
            })
            .navigationDestination(isPresented: $navigateToSettings, destination: {
                SettingsView()
            })
            .navigationDestination(isPresented: $navigateToCustomWorkouts, destination: {
               CustomWorkoutsListView()
            })
            .navigationViewStyle(StackNavigationViewStyle())
        }
       
        
    }
}

#Preview {
    HomeView()
}


