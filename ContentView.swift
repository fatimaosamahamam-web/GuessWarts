
//
//  ContentView.swift
//  GuessWarts2
//
//  Created by Fatima Osama on 18/08/2025.
//
//

import SwiftUI

struct ContentView: View {
    // Game state variables
    @State private var myNumber = Int.random(in: 1...50)
    @State private var guess = ""
    @State private var messageTitle = "Guess the Number"
    @State private var messageComment = "to Complete Harry’s Spell, Wizard!"
    @State private var isWin = false
    @State private var attempts = 0
    
    // Difficulty
    @State private var level: Double = 1
    @State private var rangeMax = 50
    
    // Stopwatch state
    @State private var elapsedTime = 0
    @State private var isStopwatchRunning = false
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Difficulty label
    var levelName: String {
        switch level {
        case 1: return "Easy (1-50)"
        case 2: return "Medium (1-100)"
        case 3: return "Hard (1-200)"
        default: return "Easy"
        }
    }
    
    var body: some View {
        ZStack {
            // Fullscreen background image
            Image("image1_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 1) {
                
                // Game logo
                Image("image2_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 180)
                    .padding(.top, 60)
                    .offset(x:-30, y:70)
                
                // Calendar (attempts)
                HStack {
                    ZStack {
                        Image("image3_calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .offset(x:-20,y:50)
                        Text("\(attempts)")
                            .font(.custom("Chalkduster", size: 22))
                            .foregroundColor(.brown)
                            .offset(x:-20,y:55)
                    }
                    Spacer()
                }
                .padding(.horizontal, 10)
                
                // Crystal ball + sparks
                ZStack {
                    Image("image4_ball")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .offset(x:-45, y: -20)
                        .shadow(color: glowColor(), radius: 25, x: 0, y:0)
                    
                    if isWin {
                        ForEach(0..<25, id: \.self) { i in
                            Text("✨")
                                .font(.system(size: CGFloat.random(in: 16...26)))
                                .position(x: 200, y: 200)
                                .offset(
                                    x: CGFloat.random(in: -150...150),
                                    y: CGFloat.random(in: -150...150)
                                )
                                .rotationEffect(.degrees(Double.random(in: 0...360)))
                                .animation(
                                    Animation.spring(response: 0.6, dampingFraction: 0.4, blendDuration: 0.5)
                                        .delay(Double(i) * 0.02),
                                    value: isWin
                                )
                        }
                    }
                    
                    // Title + Comment
                    VStack(spacing: 4) {
                        Text(messageTitle)
                            .font(.custom("Chalkduster", size: titleFontSize()))
                            .foregroundColor(titleColor())
                            .minimumScaleFactor(0.6)
                            .multilineTextAlignment(.center)
                            .frame(width: 220)
                            .offset(x:-20, y: -20)
                        
                        Text(messageComment)
                            .font(.custom("Chalkduster", size: 20))
                            .foregroundColor(commentColor())
                            .multilineTextAlignment(.center)
                            .frame(width: 220)
                        .offset(x:-20, y: -20)

                    }
                    .offset(x:-30, y:5)
                    
                    // Input field
                    TextField("", text: $guess)
                        .font(.custom("Chalkduster", size: 18))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .frame(width: 100, height: 30)
                        .background(Color.brown.opacity(0.22))
                        .cornerRadius(6)
                        .offset(y:105)
                        .offset(x:-55)
                }
                
                // Guess button + Stopwatch beside it
                HStack {
                    // Stopwatch Circle (fixed position on the left of Guess button)
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 90, height: 90)
                            .shadow(radius: 10)
                            .offset(x:-35,y:-35)
                        
                        Text("\(elapsedTime)")
                            .font(.custom("Chalkduster", size: 28))
                            .foregroundColor(.yellow)
                            .offset(x:-35,y:-35)

                    }
                    .padding(.leading, 20)
                    .onReceive(timer) { _ in
                        if isStopwatchRunning {
                            elapsedTime += 1
                        }
                    }
                    
                    Spacer()
                    
                    // Guess button
                    Button(action: {
                        if let userGuess = Int(guess) {
                            attempts += 1
                            if userGuess == myNumber {
                                messageTitle = "Correct!"
                                messageComment = "You cast the perfect spell, Wizard!"
                                isWin = true
                            } else if userGuess < myNumber {
                                messageTitle = "Too Low"
                                messageComment = "Your magic needs more power, Wizard!"
                                isWin = false
                            } else {
                                messageTitle = "Too High"
                                messageComment = "Your spell is overflowing, Wizard!"
                                isWin = false
                            }
                            
                            // Start stopwatch only on first guess
                            if !isStopwatchRunning {
                                isStopwatchRunning = true
                                elapsedTime = 0
                            }
                        }
                    }) {
                        Image("image7_guessButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 120)
                            .offset(x:-110, y:-60)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 0)
                
                // Difficulty control
                VStack(spacing: 0) {
                    Text(levelName)
                        .font(.custom("Chalkduster", size: 25))
                        .foregroundColor(.yellow)
                        .shadow(radius:50)
                        .offset(x:-40,y:-30)
                    
                    ZStack{
                        Image("image5_broom")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 130)
                            .offset(x: -52,y:45)
                        
                        Slider(value: $level, in: 1...3, step: 1) { _ in
                            switch level {
                            case 1: rangeMax = 50
                            case 2: rangeMax = 100
                            case 3: rangeMax = 200
                            default: rangeMax = 50
                            }
                            myNumber = Int.random(in: 1...rangeMax)
                            attempts = 0
                            messageTitle = "Guess the Number"
                            messageComment = "to Complete Harry’s Spell, Wizard!"
                            guess = ""
                            isWin = false
                            elapsedTime = 0
                            isStopwatchRunning = false
                        }
                        .frame(width: 330)
                        .accentColor(.clear)
                        .offset(x:-80,y:35)
                    }
                    .offset(y: -100)
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    // MARK: - Helper functions
    private func titleColor() -> Color {
        switch messageTitle {
        case "Too High": return .red
        case "Too Low": return .blue
        case "Correct!": return .green
        case "Guess the Number": return Color(red: 0.55, green: 0.42, blue: 0.1)
        default: return .black
        }
    }
    
    private func commentColor() -> Color {
        switch messageTitle {
        case "Too High", "Too Low", "Correct!": return .black
        case "Guess the Number": return Color(red: 0.55, green: 0.42, blue: 0.1)
        default: return .black
        }
    }
    
    private func glowColor() -> Color {
        switch messageTitle {
        case "Too High": return Color.red.opacity(0.6)
        case "Too Low": return Color.blue.opacity(0.6)
        case "Correct!": return Color.green.opacity(0.6)
        default: return .clear
        }
    }
    
    private func titleFontSize() -> CGFloat {
        switch messageTitle {
        case "Too High", "Too Low", "Correct!": return 30
        case "Guess the Number": return 22
        default: return 22
        }
    }
    
    private func commentFontSize() -> CGFloat {
        switch messageTitle {
        case "Too Low": return 13
        case "Too High", "Correct!": return 18
        case "Guess the Number": return 14
        default: return 14
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 16 Pro")
    }
}
