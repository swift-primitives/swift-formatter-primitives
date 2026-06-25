// exports.swift
// Re-exports the upstream targets this integration target builds on:
// Pair (the shape primitive being conformed) and Either (the canonical
// binary failure-coproduct used by combinators in the formatter domain).
// Re-exports Formatter_Protocol and Formattable so consumers see the
// formatter namespace surface via a single import.

@_exported public import Either_Primitives
@_exported public import Formattable
@_exported public import Formatter_Protocol
@_exported public import Pair_Primitives
