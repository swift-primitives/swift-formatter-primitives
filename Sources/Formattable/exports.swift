// exports.swift
// Re-exports Formatter_Protocol (which transitively re-exports
// Formatter_Primitive) so consumers importing `Formattable` see
// `Formatter.\`Protocol\`` in scope via a single import.

@_exported public import Formatter_Protocol
