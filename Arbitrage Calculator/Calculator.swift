//
//  Calculator.swift
//  Arbitrage Calculator
//
//  Created by John Reichel on 8/3/21.
//

import SwiftUI

struct Calculator: View {
    
    @State var OriginalOdds: String = "2.0"
    @State var OriginalStake: String = "0.00"
    @State var OriginalPayout: String = "0.00"
    @State var HedgeOdds: String = "2.0"
    @State var HedgeStake: String = "0.00"
    @State var HedgePayout: String = "0.00"
    @State var ArbitrageProfit: String = "0.00"
    @State var Decimal: Bool = true
    @State var American: Bool = false
    @State var AmericanSymbolOriginal : Bool = true
    @State var AmericanSymbolHedge : Bool = true
    @State var VisibleAmerican = true
    @State var VisibleSymbol = true
    @State var profitCheck = true
    
    init(){
            UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            StrokeText(text: "Arbitrage Calculator", width: 2, color: Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold))
                    .multilineTextAlignment(.center)
            HStack {
                Button(action: {
                    Decimal = true
                    American = false
                    if AmericanSymbolOriginal {
                        OriginalOdds = "\(((Float(OriginalOdds)! / 100 + 1) * 100).rounded() / 100)"
                    } else {
                        OriginalOdds = "\(((100 / Float(OriginalOdds)! + 1) * 100).rounded() / 100)"
                    }
                    
                    if AmericanSymbolHedge {
                        HedgeOdds = "\(((Float(HedgeOdds)! / 100 + 1) * 100).rounded() / 100)"
                    } else {
                        HedgeOdds = "\(((100 / Float(HedgeOdds)! + 1) * 100).rounded() / 100)"
                    }
                }, label: {
                    if Decimal {
                        Text("Decimal")
                            .foregroundColor(.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                            .font(.system(size: 20, weight: .bold))
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), lineWidth: 5).frame(width: 125, height: 50).background(Color.white).cornerRadius(10))
                    } else {
                        Text("Decimal")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5).frame(width: 125, height: 50).cornerRadius(10))
                    }
                })
                .padding(.trailing, 25)
                Button(action: {
                    American = true
                    Decimal = false
                    if (Float(OriginalOdds)!) >= 2 {
                        OriginalOdds = "\(((Float(OriginalOdds)! - 1) * 100).rounded())"
                    } else {
                        OriginalOdds = "\((100 / (Float(OriginalOdds)! - 1)).rounded())"
                        AmericanSymbolOriginal = false
                    }
                    if (Float(HedgeOdds)!) >= 2 {
                        HedgeOdds = "\(((Float(HedgeOdds)! - 1) * 100).rounded())"
                    } else {
                        HedgeOdds = "\((100 / (Float(HedgeOdds)! - 1)).rounded())"
                        AmericanSymbolHedge = false
                    }
                    
                }, label: {
                    if American {
                        Text("American")
                            .foregroundColor(.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                            .font(.system(size: 20, weight: .bold))
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), lineWidth: 5).frame(width: 125, height: 50).background(Color.white).cornerRadius(10))
                            
                    } else {
                        Text("American")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5).frame(width: 125, height: 50).cornerRadius(10))
                            .opacity(VisibleAmerican ? 0.3:1)
                    }
                })
                .padding(.leading, 25)
            }
            .padding()
            .frame(maxWidth: .infinity)
            Form {
                if Decimal {
                    Section(header: Text("Original Odds")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("%")
                            TextField("Original Stake", text: $OriginalOdds)
                                .keyboardType(.numberPad)
                                .onChange(of: OriginalOdds) { _ in
                                    if OriginalOdds.isEmpty {
                                        OriginalOdds = "2.0"
                                    } else {
                                        let filtered = OriginalOdds.filter {"0123456789.".contains($0)}
                                        if filtered.contains(".") {
                                            let splitted = filtered.split(separator: ".")
                                            if splitted.count >= 2 {
                                                let preDecimal = String(splitted[0])
                                                let afterDecimal =
                                                    String(splitted[1])
                                                OriginalOdds = "\(preDecimal).\(afterDecimal)"
                                            }
                                        }
                                    }
                                    
                                    OriginalPayout = "\(Float(OriginalStake)! * Float(OriginalOdds)!)"
                                    OriginalPayout = "\(((Float(OriginalPayout)! * 100).rounded() / 100))"
                                    
                                    HedgeStake = "\((Float(OriginalPayout)! / Float(HedgeOdds)! * 100).rounded() / 100)"
                                    
                                    HedgePayout = "\((Float(HedgeOdds)! * Float(HedgeStake)! * 100).rounded() / 100)"
                                    
                                    ArbitrageProfit = "\(Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!)"
                                    ArbitrageProfit = "\((Float(ArbitrageProfit)! * 100).rounded() / 100)"
                                    if Float(ArbitrageProfit)! >= 0 {
                                        profitCheck = true
                                    } else {
                                        profitCheck = false
                                    }
                                }
                        }
                    }
                    
                    Section(header: Text("Original Stake")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            TextField("Original Stake", text: $OriginalStake)
                                .onChange(of: OriginalStake) { _ in
                                    if OriginalStake.isEmpty {
                                        OriginalStake = "0.00"
                                    } else {
                                        let filtered = OriginalStake.filter {"0123456789.".contains($0)}
                                        if filtered.contains(".") {
                                            let splitted = filtered.split(separator: ".")
                                            if splitted.count >= 2 {
                                                let preDecimal = String(splitted[0])
                                                let afterDecimal =
                                                    String(splitted[1])
                                                OriginalStake = "\(preDecimal).\(afterDecimal)"
                                            }
                                        }
                                    }
                                    
                                    OriginalPayout = "\(Float(OriginalStake)! * Float(OriginalOdds)!)"
                                    OriginalPayout = "\(((Float(OriginalPayout)! * 100).rounded() / 100))"
                                    
                                    HedgeStake = "\((Float(OriginalPayout)! / Float(HedgeOdds)! * 100).rounded() / 100)"
                                    
                                    HedgePayout = "\((Float(HedgeOdds)! * Float(HedgeStake)! * 100).rounded() / 100)"
                                    
                                    ArbitrageProfit = "\(Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!)"
                                    ArbitrageProfit = "\((Float(ArbitrageProfit)! * 100).rounded() / 100)"
                                    if Float(ArbitrageProfit)! >= 0 {
                                        profitCheck = true
                                    } else {
                                        profitCheck = false
                                    }
                                }
                        }
                    }
                    
                    Section(header: Text("Original Payout")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            Text(OriginalPayout)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    
                    Section(header: Text("Hedge Odds")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("%")
                            TextField("Original Stake", text: $HedgeOdds)
                                .onChange(of: HedgeOdds) { _ in
                                    if HedgeOdds.isEmpty {
                                        HedgeOdds = "2.0"
                                    } else {
                                        let filtered = HedgeOdds.filter {"0123456789.".contains($0)}
                                        if filtered.contains(".") {
                                            let splitted = filtered.split(separator: ".")
                                            if splitted.count >= 2 {
                                                let preDecimal = String(splitted[0])
                                                let afterDecimal =
                                                    String(splitted[1])
                                                HedgeOdds = "\(preDecimal).\(afterDecimal)"
                                            }
                                        }
                                    }
                                    
                                    HedgeStake = "\((Float(OriginalPayout)! / Float(HedgeOdds)! * 100).rounded() / 100)"
                                    
                                    HedgePayout = "\((Float(HedgeOdds)! * Float(HedgeStake)! * 100).rounded() / 100)"
                                    
                                    ArbitrageProfit = "\(Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!)"
                                    ArbitrageProfit = "\((Float(ArbitrageProfit)! * 100).rounded() / 100)"
                                    if Float(ArbitrageProfit)! >= 0 {
                                        profitCheck = true
                                    } else {
                                        profitCheck = false
                                    }
                                }
                        }
                    }
                    
                    Section(header: Text("Hedge Stake")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            Text(HedgeStake)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    
                    Section(header: Text("Hedge Payout")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            Text(HedgePayout)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    
                    Section(header: Text("Arbitrage Profit")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            Text(ArbitrageProfit)
                                .foregroundColor(profitCheck ? .green:.red)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                }
                if American {
                    Section(header: Text("Original Odds")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Button(action: {
                                if AmericanSymbolOriginal {
                                    AmericanSymbolOriginal = false
                                    
                                } else {
                                    AmericanSymbolOriginal = true
                                }
                            }, label: {
                                Text(AmericanSymbolOriginal ? "+" : "-")
                                    .foregroundColor(.black)
                                    .opacity(VisibleSymbol ? 1:0.3)
                                    .onAppear(perform: {
                                        pulsateSymbol()
                                    })
                            })
                            .onChange(of: AmericanSymbolHedge, perform: { value in
                                if AmericanSymbolOriginal {
                                    OriginalPayout = "\((((Float(OriginalOdds)! / 100 + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                
                                    if AmericanSymbolHedge {
                                        HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                        HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                    } else {
                                        HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                        HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                    }
                                
                                    ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                    if Float(ArbitrageProfit)! >= 0 {
                                        profitCheck = true
                                    } else {
                                        profitCheck = false
                                    }
                                } else {
                                    OriginalPayout = "\((((100 / Float(OriginalOdds)! + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                    
                                    if AmericanSymbolHedge {
                                        HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                        HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                    } else {
                                        HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                        HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                    }
                                    
                                    ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                    if Float(ArbitrageProfit)! >= 0 {
                                        profitCheck = true
                                    } else {
                                        profitCheck = false
                                    }
                                }
                            })
                            .onChange(of: AmericanSymbolOriginal, perform: { value in
                                if AmericanSymbolOriginal {
                                    OriginalPayout = "\((((Float(OriginalOdds)! / 100 + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                
                                    if AmericanSymbolHedge {
                                        HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                        HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                    } else {
                                        HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                        HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                    }
                                
                                    ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                    if Float(ArbitrageProfit)! >= 0 {
                                        profitCheck = true
                                    } else {
                                        profitCheck = false
                                    }
                                } else {
                                    OriginalPayout = "\((((100 / Float(OriginalOdds)! + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                    
                                    if AmericanSymbolHedge {
                                        HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                        HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                    } else {
                                        HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                        HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                    }
                                    
                                    ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                    if Float(ArbitrageProfit)! >= 0 {
                                        profitCheck = true
                                    } else {
                                        profitCheck = false
                                    }
                                }
                            })
                            TextField("Original Stake", text: $OriginalOdds)
                                .onChange(of: OriginalOdds) { _ in
                                    if OriginalOdds.isEmpty {
                                        OriginalOdds = "100.0"
                                    } else {
                                        let filtered = OriginalOdds.filter {"0123456789.".contains($0)}
                                        if filtered.contains(".") {
                                            let splitted = filtered.split(separator: ".")
                                            if splitted.count >= 2 {
                                                let preDecimal = String(splitted[0])
                                                let afterDecimal =
                                                    String(splitted[1])
                                                OriginalOdds = "\(preDecimal).\(afterDecimal)"
                                            }
                                        }
                                    }
                                    
                                    if AmericanSymbolOriginal {
                                        OriginalPayout = "\((((Float(OriginalOdds)! / 100 + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                    
                                        if AmericanSymbolHedge {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        } else {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        }
                                    
                                        ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                        if Float(ArbitrageProfit)! >= 0 {
                                            profitCheck = true
                                        } else {
                                            profitCheck = false
                                        }
                                    } else {
                                        OriginalPayout = "\((((100 / Float(OriginalOdds)! + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                        
                                        if AmericanSymbolHedge {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        } else {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        }
                                        
                                        ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                        if Float(ArbitrageProfit)! >= 0 {
                                            profitCheck = true
                                        } else {
                                            profitCheck = false
                                        }
                                    }
                                }
                        }
                    }
                    
                    Section(header: Text("Original Stake")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            TextField("Original Stake", text: $OriginalStake)
                                .onChange(of: OriginalStake) { _ in
                                    if OriginalStake.isEmpty {
                                        OriginalStake = "0.00"
                                    } else {
                                        let filtered = OriginalStake.filter {"0123456789.".contains($0)}
                                        if filtered.contains(".") {
                                            let splitted = filtered.split(separator: ".")
                                            if splitted.count >= 2 {
                                                let preDecimal = String(splitted[0])
                                                let afterDecimal =
                                                    String(splitted[1])
                                                OriginalStake = "\(preDecimal).\(afterDecimal)"
                                            }
                                        }
                                    }
                                    
                                    if AmericanSymbolOriginal {
                                        OriginalPayout = "\((((Float(OriginalOdds)! / 100 + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                    
                                        if AmericanSymbolHedge {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        } else {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        }
                                    
                                        ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                        if Float(ArbitrageProfit)! >= 0 {
                                            profitCheck = true
                                        } else {
                                            profitCheck = false
                                        }
                                    } else {
                                        OriginalPayout = "\((((100 / Float(OriginalOdds)! + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                        
                                        if AmericanSymbolHedge {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        } else {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        }
                                        
                                        ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                        if Float(ArbitrageProfit)! >= 0 {
                                            profitCheck = true
                                        } else {
                                            profitCheck = false
                                        }
                                    }
                                }
                        }
                    }
                    
                    Section(header: Text("Original Payout")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            Text(OriginalPayout)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    
                    Section(header: Text("Hedge Odds")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Button(action: {
                                if AmericanSymbolHedge {
                                    AmericanSymbolHedge = false
                                } else {
                                    AmericanSymbolHedge = true
                                }
                            }, label: {
                                Text(AmericanSymbolHedge ? "+" : "-")
                                    .foregroundColor(.black)
                                    .opacity(VisibleSymbol ? 1:0.3)
                                    .onAppear(perform: {
                                        pulsateSymbol()
                                    })
                            })
                            TextField("Original Stake", text: $HedgeOdds)
                                .onChange(of: HedgeOdds) { _ in
                                    if HedgeOdds.isEmpty {
                                        HedgeOdds = "100.0"
                                    } else {
                                        let filtered = HedgeOdds.filter {"0123456789.".contains($0)}
                                        if filtered.contains(".") {
                                            let splitted = filtered.split(separator: ".")
                                            if splitted.count >= 2 {
                                                let preDecimal = String(splitted[0])
                                                let afterDecimal =
                                                    String(splitted[1])
                                                HedgeOdds = "\(preDecimal).\(afterDecimal)"
                                            }
                                        }
                                    }
                                    
                                    if AmericanSymbolOriginal {
                                        OriginalPayout = "\((((Float(OriginalOdds)! / 100 + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                    
                                        if AmericanSymbolHedge {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        } else {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        }
                                    
                                        ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                        if Float(ArbitrageProfit)! >= 0 {
                                            profitCheck = true
                                        } else {
                                            profitCheck = false
                                        }
                                    } else {
                                        OriginalPayout = "\((((100 / Float(OriginalOdds)! + 1) * Float(OriginalStake)!) * 100).rounded() / 100)"
                                        
                                        if AmericanSymbolHedge {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (Float(HedgeOdds)! / 100 + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((Float(HedgeOdds)! / 100 + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        } else {
                                            HedgeStake = "\(((Float(OriginalPayout)! / (100 / Float(HedgeOdds)! + 1)) * 100).rounded() / 100)"
                                            HedgePayout = "\((((100 / (Float(HedgeOdds)!) + 1) * Float(HedgeStake)!) * 100).rounded() / 100)"
                                        }
                                        
                                        ArbitrageProfit = "\(((Float(OriginalPayout)! - Float(HedgeStake)! - Float(OriginalStake)!) * 100).rounded() / 100)"
                                        if Float(ArbitrageProfit)! >= 0 {
                                            profitCheck = true
                                        } else {
                                            profitCheck = false
                                        }
                                    }
                                    
                                }
                        }
                    }
                    
                    Section(header: Text("Hedge Stake")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            Text(HedgeStake)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    
                    Section(header: Text("Hedge Payout")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            Text(HedgePayout)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    
                    Section(header: Text("Arbitrage Profit")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                    ) {
                        HStack {
                            Text("$")
                            Text(ArbitrageProfit)
                                .foregroundColor(profitCheck ? .green:.red)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                }
            }
            .frame(width: 350, height: 725, alignment: .center)
            .foregroundColor(Color.black)
            .background(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.7)))
            .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 5)
            )
            
                
        }
        .frame(height: 1000)
        .background(RadialGradient(gradient: Gradient(colors: [.white, .init(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))]), center: .center, startRadius: 20, endRadius: 500))
        .onAppear(perform: {
            pulsateAmerican()
        })
    }
    
    func pulsateAmerican() {
        withAnimation(Animation.easeInOut(duration: 1.5).repeatCount(5, autoreverses: true)) {
                VisibleAmerican.toggle()
            }
    }
    
    func pulsateSymbol() {
        withAnimation(Animation.easeInOut(duration: 1.5).repeatCount(5, autoreverses: true)) {
                VisibleSymbol.toggle()
            }
    }
}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        Calculator()
    }
}

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}


