# Contract Examples — Q6 & Q7

Reference examples for input/output contracts. Use when the user needs guidance on what to provide.

## Q6: Input Contract Example

```
Source: "User interview + domain documents"
Schema: "Unstructured text — interview transcripts, PDF/markdown docs"
Validation: "At least 1 source document provided; EO stated"
Error: "If no sources → abort with message; if EO missing → re-prompt"
SLA: "Available at session start; no latency constraint"
Version: "v1.0"
```

## Q7: Output Contract Example

```
Consumer: "Build Engine — consumes VANA-SPEC for implementation"
Schema: "VANA-SPEC markdown — Verb/Adverb/Noun/Adjective sections with binary A.C. tables"
Validation: "All A.C.s are binary (pass/fail); every Verb has at least 1 A.C. per S/E/Sc pillar"
Error: "If structuring fails → return partial with error flags; human reviews before handoff"
SLA: "Output within 30 min of /learn:structure completion"
Version: "v1.0"
```
