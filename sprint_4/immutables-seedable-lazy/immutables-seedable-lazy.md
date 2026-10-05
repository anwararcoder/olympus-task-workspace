Language: java
Difficulty: hard
Type: feature_request

# Seedable Lazy Attributes

Introduce seedable lazy attributes as a new generated capability. The new mode uses an accessor annotated with both `@Value.Lazy` and `@Value.Default` and accepts an explicit value through generated builders and with-methods. This applies to regular generated builders; strict and staged builders are not required. Any direct setter or collection/map mutator establishes a seed, including legal `null`, false, zero, empty optional, empty array, and empty collection or map values. Until then, its initializer stays cold.

An unseeded hybrid retains ordinary `@Value.Lazy` initialization and declared checked-exception signatures.

Calling a hybrid with-method with a value equal to a computed fallback still establishes an explicit seed. Copying a value while changing another attribute preserves an explicit seed, but leaves an omitted or merely computed fallback cold in the copy.

Generated `toBuilder`, builder `from`, and `copyOf` paths preserve explicit seeds without calling the hybrid accessor. An unseeded source acts as absent and does not clear a destination seed. `Modifiable.from(...)` follows the same rule for generated immutable and modifiable sources. Copying from an arbitrary external implementation leaves the hybrid unseeded and does not read its getter, including when a style disables builder `from`.

A generated Modifiable returns a fresh fallback on each unseeded access without marking the attribute set; unset and clear remove explicit seeds. Converting it to an immutable value preserves explicit seeds and leaves unseeded hybrids cold.

Ordinary Java serialization resets both explicit and computed lazy state without forcing the attribute, while generated structural serialization and marshaling omit it. Reject the combination for interned immutable values and types without generated builders or with-methods, with a diagnostic mentioning both annotations.
