✅ Design Choice: Named Parameter buildRenderItems({required List<String> ids})
We chose to use the named parameter version of buildRenderItems instead of a positional one. This aligns with our pattern of passing navigation context via .extra (e.g., GoRouter), improves clarity at the call site, and supports future extensibility (e.g., filtering, conditional resolution).

Example usage:
renderItems = buildRenderItems(ids: sequenceIds);








✅🟠❌