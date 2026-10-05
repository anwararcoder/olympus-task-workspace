Language: java
Difficulty: hard
Type: feature_request

# Map and Iterable Entry Mappings

Support mapping from a `Map<K, V>` to an iterable or array result by treating each map entry as a source element, in the map's iteration order. In the reverse direction, map each iterable or array source element to a `Map.Entry<K, V>`, then add that entry's key and value to the result map.

Entry element mappings participate in normal mapping-method selection, conversions, and iterable mapping qualifiers. Abstract mapping methods may target `Map.Entry<K, V>` through its logical `key` and `value` target properties. Compatible lower-bounded map result types are supported when the selected entry mapping method returns a concrete entry type.
