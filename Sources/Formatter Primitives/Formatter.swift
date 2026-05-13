//
//  Formatter.swift
//  swift-formatter-primitives
//
//  Namespace for formatting capability primitives.
//

/// Namespace for formatting capability primitives.
///
/// `Formatter` is the abstract capability layer for value-to-value
/// transformations whose audience is humans rather than machines:
/// locale-dependent presentation, lossy projection, return-complete
/// output. Concrete formatters live in subject-domain packages
/// (e.g. `Numeric.Decimal.Formatter`, `Text.Case.Formatter`); the
/// configuration vocabulary that parameterizes them lives in the
/// sibling `Format` namespace (`swift-format-primitives`).
public enum Formatter {}
