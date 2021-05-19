//
//  Direction.swift
//  Weather
//
//  Created by Егор Никитин on 19.05.2021.
//

import Foundation

enum Direction: String, CaseIterable {
    case С, ССВ, СВ, ВСВ, В, ВЮВ, ЮВ, ЮЮВ, Ю, ЮЮЗ, ЮЗ, ЗЮЗ, З, ЗСЗ, СЗ, ССЗ
}

extension Direction: CustomStringConvertible  {
    init<D: BinaryFloatingPoint>(_ direction: D) {
        self =  Self.allCases[Int((direction.angle+11.25).truncatingRemainder(dividingBy: 360)/22.5)]
    }
    var description: String { rawValue.uppercased() }
}

extension BinaryFloatingPoint {
    var angle: Self {
        (truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
    }
    var direction: Direction { .init(self) }
}
