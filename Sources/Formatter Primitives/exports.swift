// exports.swift
// Umbrella re-export of the Formatter namespace, protocol surface,
// Formattable attachment protocol, the top-level Format witness, and the
// Pair shape-primitive integration target.
//
// Per [MOD-005] the umbrella target's sole content is `@_exported public
// import` statements re-exporting sub-namespace targets. Consumers
// importing `Formatter_Primitives` get the union: namespace + protocol +
// Formattable + Format + Formatter Pair Primitives.

// DISABLED 2026-05-23 (per user direction): the draft `Format` witness struct
// in the `Format` module collides with swift-format-primitives' `Format` enum
// namespace, producing ecosystem-wide "ambiguous type 'Format'" errors through
// this umbrella re-export. Not re-exported until the Format/Formatter naming is
// reconciled; the `Format` module/struct itself remains intact and buildable.
// @_exported public import Format
@_exported public import Formattable
@_exported public import Formatter_Pair_Primitives
@_exported public import Formatter_Primitive
@_exported public import Formatter_Protocol
