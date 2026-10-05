Language: java
Difficulty: hard
Type: enhancement

# Compact binary form for generated immutables

When `org.immutables:serial` is on the compilation classpath, extend the value processor so generated `@Value.Immutable` implementations gain a compact binary form without a new annotation. The implementation receives a public instance method `writeTo(java.io.DataOutput)` and a public static method `readFrom(java.io.DataInput)`; reading a written value yields an equal value. Without the serial artifact, generation is unchanged. If the value type already declares or inherits either signature, preserve that API and add neither part of a conflicting binary form.

Generate the method pair only when the stored value can be reconstructed faithfully. Builder-built values must support primitive and boxed scalars, strings, enums, optionals, arrays, direct nested generated immutables, and the collection shapes below. Constructor-built values must at least support types whose stored non-auxiliary attributes are all constructor parameters using scalars, enums, optionals, lists, sets, or maps; other faithfully reconstructible constructor forms may also be supported. Value types may declare type parameters, but `Object`, unresolved type-variable attributes, arrays of arrays, collections of collections, and nested values inside containers are outside the required surface. Concrete type arguments do not by themselves disqualify a direct nested generated immutable. Unsupported or recursive shapes must receive neither method rather than a partial form, and must not prevent unrelated eligible values from receiving the methods.

The encoded data carries no attribute names. Attribute matching must not depend on declaration order: reordered attributes still match, while renamed attributes behave as missing rather than matching by position. Distinct attributes must never be conflated; a type that cannot distinguish them safely receives neither method. Readers must skip unknown attributes without desynchronizing later ones.

Across value-type versions, added attributes are ignored by older readers and missing attributes take their normal default or absent values. A writer/reader type mismatch is also treated as absent, including mismatched container elements and map keys or values. These rules apply to supported constructor-built values as well. Compatibility follows the encoded shape rather than the declared type name, and enums are recovered by matching constant name even after reordering. Strings of any length round-trip.

Lists, sets, sorted sets, multisets, maps, sorted maps, bimaps, and multimaps of supported scalar, string, or enum elements retain their declared shape. Multisets preserve counts, and multimaps preserve per-key multiplicity. Values from standard Java and Guava collection or optional factories round-trip. Java and Guava optionals preserve presence, including `OptionalInt`, `OptionalLong`, and `OptionalDouble`. Primitive arrays and reference arrays of supported scalar, string, or enum elements round-trip by contents.

Required nested support covers direct, acyclic generated immutables that also receive the binary form, regardless of package, declared type name, or concrete type arguments. Their version changes must not desynchronize following outer attributes.

Derived and auxiliary attributes are omitted. Derived attributes are recomputed during construction, optional auxiliary attributes use their normal defaults, and a required auxiliary attribute disables the binary form. Incomplete input produces an error rather than a wrong value.
