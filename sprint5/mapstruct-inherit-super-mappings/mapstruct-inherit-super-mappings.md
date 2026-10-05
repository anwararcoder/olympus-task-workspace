Language: java
Difficulty: hard
Type: feature_request

# Inherited Super Mappings

Add `boolean inheritSuperMappings() default false` to `@BeanMapping`. When enabled on a bean-mapping method that overrides mapper interface or superclass methods, inherit their property-level `@Mapping` declarations, including mapping compositions, without implicitly copying their other method-level mapping options.

A mapping or `ignore = true` declared on the current method wins for the same target path. Otherwise the most specific overridden declaration wins. Mappings for different targets from incomparable branches are combined, while competing mappings for the same target are a compilation error that identifies the target and declaring mapper types, even where those branches declare the same thing. A shared ancestor contributes once, and `target = "."` flattening declarations accumulate instead of competing as one target, whether they are inherited or declared on the current method.

Resolve override relationships through generic and transitive supertypes. When an inherited source path begins with a whole path segment that the overridden method resolves to a source parameter, rebind that segment to the overriding parameter in the same signature position and keep the rest of the path, which may be empty, including when same-typed parameters are renamed. A segment that resolves to a property instead keeps its meaning, so an unqualified property of a lone source parameter is left alone even when it is spelled like that parameter. Whether a leading segment denotes a parameter or a property is decided as the overridden method reads the inherited path, not by reading it again against the overriding signature. Java expression strings remain verbatim.

Using the option on a method that overrides no mapping method is a compilation error, while an overridden mapping method still counts when it declares no property mappings of its own. Existing explicit and automatic configuration inheritance fills only targets not supplied by the current or inherited super mappings, and behavior remains unchanged when the option is false.
