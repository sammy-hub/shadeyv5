import Foundation

/// Centralized formatting utilities for consistent display across the app
enum AppFormatters {
    // MARK: - Currency
    
    static var currency: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
    
    static var currencyCompact: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
    
    // MARK: - Numbers
    
    static var wholeNumber: IntegerFormatStyle<Int> {
        .number
    }
    
    static var decimal: FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(0...2))
    }
    
    static var decimalPrecise: FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(2))
    }
    
    static func decimal(fractionDigits: Int) -> FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(fractionDigits))
    }
    
    // MARK: - Dates
    
    static var dateShort: Date.FormatStyle {
        .dateTime.day().month().year()
    }
    
    static var dateMedium: Date.FormatStyle {
        .dateTime.day().month(.wide).year()
    }
    
    static var dateLong: Date.FormatStyle {
        .dateTime.weekday(.wide).day().month(.wide).year()
    }
    
    static var dateAbbreviated: Date.FormatStyle {
        .dateTime.day().month(.abbreviated).year()
    }
    
    static var monthYear: Date.FormatStyle {
        .dateTime.month(.abbreviated).year()
    }
    
    static var monthOnly: Date.FormatStyle {
        .dateTime.month(.abbreviated)
    }
    
    static var timeOnly: Date.FormatStyle {
        .dateTime.hour().minute()
    }
    
    // MARK: - Measurements
    
    static func measurement(value: Double, unit: UnitType) -> String {
        let formattedValue = value.formatted(decimal)
        return "\(formattedValue) \(unit.displayName)"
    }
    
    static func measurement(value: Double, unit: UnitType, fractionDigits: Int) -> String {
        let formattedValue = value.formatted(decimal(fractionDigits: fractionDigits))
        return "\(formattedValue) \(unit.displayName)"
    }
    
    // MARK: - Percentages
    
    static func percentage(_ value: Double) -> String {
        (value * 100).formatted(decimal(fractionDigits: 1)) + "%"
    }
    
    // MARK: - Ratios
    
    static func ratio(_ value: Double) -> String {
        value.formatted(decimal(fractionDigits: 1))
    }
}
