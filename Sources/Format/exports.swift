// exports.swift
// Re-exports the Formatter.`Protocol` declaration (and the Formatter
// namespace transitively) so consumers importing `Format` see both
// `Format<I, O, F>` and the protocol it conforms to via a single import.

@_exported public import Formatter_Protocol
