// exports.swift
// Test Support spine root for Formatter Primitives.
//
// Per [MOD-024] empty-shell template: zero external Test Support deps
// to anchor on (package has no upstream Package.swift dependencies), so
// the spine consists of a single `@_exported public import` of the
// package's own umbrella product. Downstream Test Support targets that
// declare swift-formatter-primitives as a dep will anchor on this
// re-export when extending the spine.

@_exported public import Formatter_Primitives
