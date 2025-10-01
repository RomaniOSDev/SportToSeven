//
//  CustomComponents.swift
//  SportToSeven
//
//  Created by Jack Reess on 08.09.2025.
//

import SwiftUI


// MARK: - Custom Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    let size: ButtonSize
    
    enum ButtonSize {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small:
                return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium:
                return EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            case .large:
                return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
            }
        }
        
        var font: Font {
            switch self {
            case .small:
                return .subheadline.bold()
            case .medium:
                return .headline.bold()
            case .large:
                return .title2.bold()
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundColor(.white)
            .padding(size.padding)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.main, .secondCLR],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: .main.opacity(0.3),
                radius: configuration.isPressed ? 4 : 12,
                x: 0,
                y: configuration.isPressed ? 2 : 6
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    let size: PrimaryButtonStyle.ButtonSize
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundColor(.main)
            .padding(size.padding)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.white, lineWidth: 2)
                    )
            )
            .shadow(
                color: .main.opacity(0.1),
                radius: configuration.isPressed ? 2 : 8,
                x: 0,
                y: configuration.isPressed ? 1 : 4
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct IconButtonStyle: ButtonStyle {
    let color: Color
    let size: CGFloat
    
    init(color: Color = .main, size: CGFloat = 24) {
        self.color = color
        self.size = size
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: size))
            .foregroundColor(color)
            .frame(width: 44, height: 44)
            .background(
                Circle()
                    .fill(color.opacity(0.1))
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Custom Background
struct AppBackground: View {
    let showGradient: Bool
    let showLines: Bool
    
    init(showGradient: Bool = true, showLines: Bool = true) {
        self.showGradient = showGradient
        self.showLines = showLines
    }
    
    var body: some View {
        ZStack {
            // Base background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            if showGradient {
                // Gradient overlay
                LinearGradient(
                    colors: [
                        .main.opacity(0.05),
                        .secondCLR.opacity(0.03),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            if showLines {
                // Decorative lines
                GeometryReader { geometry in
                    ZStack {
                        // Diagonal lines
                        ForEach(0..<6, id: \.self) { index in
                            Path { path in
                                let width = geometry.size.width
                                let height = geometry.size.height
                                let spacing = width / 6
                                let x = CGFloat(index) * spacing
                                
                                path.move(to: CGPoint(x: x - 30, y: -30))
                                path.addLine(to: CGPoint(x: x + 30, y: height + 30))
                            }
                            .stroke(
                                .main.opacity(0.06),
                                style: StrokeStyle(lineWidth: 1, lineCap: .round)
                            )
                        }
                        
                        // Horizontal accent lines
                        ForEach(0..<3, id: \.self) { index in
                            Path { path in
                                let width = geometry.size.width
                                let height = geometry.size.height
                                let y = height * 0.25 + CGFloat(index) * height * 0.25
                                
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: width, y: y))
                            }
                            .stroke(
                                .main.opacity(0.04),
                                style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                            )
                        }
                        
                        // Vertical accent lines
                        ForEach(0..<2, id: \.self) { index in
                            Path { path in
                                let width = geometry.size.width
                                let height = geometry.size.height
                                let x = width * 0.2 + CGFloat(index) * width * 0.6
                                
                                path.move(to: CGPoint(x: x, y: 0))
                                path.addLine(to: CGPoint(x: x, y: height))
                            }
                            .stroke(
                                .main.opacity(0.03),
                                style: StrokeStyle(lineWidth: 1, lineCap: .round)
                            )
                        }
                        
                        // Circular accents
                        Circle()
                            .stroke(
                                .main.opacity(0.03),
                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                            )
                            .frame(width: 180, height: 180)
                            .position(x: geometry.size.width * 0.85, y: geometry.size.height * 0.15)
                        
                        Circle()
                            .stroke(
                                .secondCLR.opacity(0.04),
                                style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                            )
                            .frame(width: 120, height: 120)
                            .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.85)
                        
                        // Small decorative dots
                        ForEach(0..<8, id: \.self) { index in
                            Circle()
                                .fill(.main.opacity(0.05))
                                .frame(width: 4, height: 4)
                                .position(
                                    x: geometry.size.width * (0.1 + CGFloat(index) * 0.1),
                                    y: geometry.size.height * (0.1 + CGFloat(index % 3) * 0.3)
                                )
                        }
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}

// MARK: - Custom Cards
struct AppCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let cornerRadius: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
    
    init(
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 20,
        shadowColor: Color = .main.opacity(0.1),
        shadowRadius: CGFloat = 10,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 5)
            )
    }
}

// MARK: - Custom Progress Indicators with App Colors
struct AppCircularProgress: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let showTime: Bool
    let remaining: Int?
    let total: Int?
    
    @State private var animatedProgress: Double = 0
    
    init(
        progress: Double,
        size: CGFloat = 120,
        lineWidth: CGFloat = 8,
        showTime: Bool = false,
        remaining: Int? = nil,
        total: Int? = nil
    ) {
        self.progress = max(0, min(1, progress))
        self.size = size
        self.lineWidth = lineWidth
        self.showTime = showTime
        self.remaining = remaining
        self.total = total
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color(.systemGray6), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: [.main, .secondCLR, .main],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: animatedProgress)
            
            // Time display
            if showTime, let remaining = remaining {
                VStack(spacing: 2) {
                    Text("\(remaining)")
                        .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.main)
                    
                    Text("sec")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
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

struct AppLinearProgress: View {
    let progress: Double
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(
        progress: Double,
        height: CGFloat = 8,
        cornerRadius: CGFloat = 4
    ) {
        self.progress = max(0, min(1, progress))
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemGray6))
                    .frame(height: height)
                
                // Progress bar
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                    LinearGradient(
                        colors: [.main, .secondCLR],
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

// MARK: - Custom Icons
struct AppIcon: View {
    let systemName: String
    let size: CGFloat
    let color: Color
    let backgroundColor: Color
    
    init(
        systemName: String,
        size: CGFloat = 24,
        color: Color = .main,
        backgroundColor: Color = .main.opacity(0.1)
    ) {
        self.systemName = systemName
        self.size = size
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size))
            .foregroundColor(color)
            .frame(width: size * 2, height: size * 2)
            .background(
                Circle()
                    .fill(backgroundColor)
            )
    }
}

// MARK: - Custom Text Styles
extension Text {
    func appTitle() -> some View {
        self
            .font(.largeTitle.bold())
            .foregroundColor(.main)
    }
    
    func appHeadline() -> some View {
        self
            .font(.headline.bold())
            .foregroundColor(.main)
    }
    
    func appBody() -> some View {
        self
            .font(.body)
            .foregroundColor(.primary)
    }
    
    func appCaption() -> some View {
        self
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

#Preview {
    VStack(spacing: 30) {
        // Button examples
        VStack(spacing: 16) {
            Button("Primary Button") { }
                .buttonStyle(PrimaryButtonStyle(size: .large))
            
            Button("Secondary Button") { }
                .buttonStyle(SecondaryButtonStyle(size: .medium))
            
            Button(action: {}) {
                Image(systemName: "heart.fill")
            }
            .buttonStyle(IconButtonStyle())
        }
        .padding()
        
        // Progress examples
        VStack(spacing: 20) {
            AppCircularProgress(
                progress: 0.7,
                showTime: true,
                remaining: 15,
                total: 30
            )
            
            AppLinearProgress(progress: 0.6)
                .frame(height: 8)
        }
        .padding()
        
        // Card example
        AppCard {
            VStack {
                Text("App Card")
                    .appHeadline()
                Text("Beautiful card with app colors")
                    .appBody()
            }
        }
        .padding()
    }
    .background(AppBackground())
}
