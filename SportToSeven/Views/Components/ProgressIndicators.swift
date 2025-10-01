//
//  ProgressIndicators.swift
//  SportToSeven
//
//  Created by Jack Reess on 08.09.2025.
//

import SwiftUI

// MARK: - Circular Progress Indicator
struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let color: Color
    let backgroundColor: Color
    
    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        size: CGFloat = 120,
        color: Color = .accentColor,
        backgroundColor: Color = Color(.systemGray5)
    ) {
        self.progress = max(0, min(1, progress))
        self.lineWidth = lineWidth
        self.size = size
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [color.opacity(0.3), color, color.opacity(0.8)],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}

// MARK: - Animated Circular Progress with Timer
struct AnimatedCircularProgress: View {
    let remaining: Int
    let total: Int
    let size: CGFloat
    let color: Color
    let showTime: Bool
    
    @State private var animatedProgress: Double = 0
    
    init(
        remaining: Int,
        total: Int = 30,
        size: CGFloat = 120,
        color: Color = .green,
        showTime: Bool = true
    ) {
        self.remaining = remaining
        self.total = total
        self.size = size
        self.color = color
        self.showTime = showTime
    }
    
    private var progress: Double {
        max(0, min(1, Double(total - remaining) / Double(total)))
    }
    
    var body: some View {
        ZStack {
            CircularProgressView(
                progress: animatedProgress,
                size: size,
                color: color
            )
            
            if showTime {
                VStack(spacing: 4) {
                    Text("\(remaining)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(color)
                    
                    Text("sec")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(.easeInOut(duration: 0.3)) {
                animatedProgress = newProgress
            }
        }
    }
}

// MARK: - Gradient Linear Progress
struct GradientProgressView: View {
    let progress: Double
    let height: CGFloat
    let cornerRadius: CGFloat
    let colors: [Color]
    let backgroundColor: Color
    
    init(
        progress: Double,
        height: CGFloat = 8,
        cornerRadius: CGFloat = 4,
        colors: [Color] = [.blue, .purple, .pink],
        backgroundColor: Color = Color(.systemGray5)
    ) {
        self.progress = max(0, min(1, progress))
        self.height = height
        self.cornerRadius = cornerRadius
        self.colors = colors
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .frame(height: height)
                
                // Progress bar
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: colors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: height)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Workout Progress Ring
struct WorkoutProgressRing: View {
    let totalRemaining: Int
    let totalDuration: Int
    let size: CGFloat
    
    @State private var animatedProgress: Double = 0
    
    init(totalRemaining: Int, totalDuration: Int = 420, size: CGFloat = 100) {
        self.totalRemaining = totalRemaining
        self.totalDuration = totalDuration
        self.size = size
    }
    
    private var progress: Double {
        max(0, min(1, Double(totalDuration - totalRemaining) / Double(totalDuration)))
    }
    
    private var minutesRemaining: Int {
        totalRemaining / 60
    }
    
    private var secondsRemaining: Int {
        totalRemaining % 60
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color(.systemGray6), lineWidth: 6)
                .frame(width: size, height: size)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: [.blue, .purple, .pink, .orange],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: animatedProgress)
            
            // Time display
            VStack(spacing: 2) {
                Text("\(minutesRemaining):\(String(format: "%02d", secondsRemaining))")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.primary)
                
                Text("remaining")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(.easeInOut(duration: 0.3)) {
                animatedProgress = newProgress
            }
        }
    }
}

// MARK: - Exercise Phase Progress
struct ExercisePhaseProgress: View {
    let phase: WorkoutViewModel.Phase
    let currentIndex: Int
    let totalExercises: Int
    
    var body: some View {
        VStack(spacing: 12) {
            // Exercise counter
            HStack {
                Text("Exercise \(currentIndex + 1) of \(totalExercises)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(phaseDescription)
                    .font(.caption)
                    .foregroundColor(phaseColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(phaseColor.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            // Progress bar
            switch phase {
            case .work(_, let remaining):
                GradientProgressView(
                    progress: 1 - Double(remaining) / 30.0,
                    colors: [.green, .mint]
                )
            case .rest(let remaining):
                GradientProgressView(
                    progress: 1 - Double(remaining) / 10.0,
                    colors: [.orange, .yellow]
                )
            default:
                GradientProgressView(progress: 0)
            }
        }
    }
    
    private var phaseDescription: String {
        switch phase {
        case .ready:
            return "Ready"
        case .work:
            return "Work"
        case .rest:
            return "Rest"
        case .finished:
            return "Finished"
        }
    }
    
    private var phaseColor: Color {
        switch phase {
        case .ready:
            return .blue
        case .work:
            return .green
        case .rest:
            return .orange
        case .finished:
            return .purple
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // Circular progress examples
        HStack(spacing: 20) {
            AnimatedCircularProgress(remaining: 15, total: 30, color: .green)
            AnimatedCircularProgress(remaining: 5, total: 10, color: .orange)
        }
        
        // Workout progress ring
        WorkoutProgressRing(totalRemaining: 180, totalDuration: 420)
        
        // Gradient progress
        VStack(spacing: 10) {
            GradientProgressView(progress: 0.3, colors: [.blue, .purple])
            GradientProgressView(progress: 0.7, colors: [.green, .mint])
            GradientProgressView(progress: 0.9, colors: [.orange, .red])
        }
        .padding(.horizontal)
    }
    .padding()
}

