---
layout: blog_entry
title: Package Principles- Cohesion
description: An introduction to the first three package principles
---
The Package Principles are a way of organizing classes in larger systems to make them more organized and manageable. They are well-described in [Agile Software Development: Principles, Patterns, and Practices](http://www.amazon.com/Software-Development-Principles-Patterns-Practices/dp/0135974445) by Robert "Uncle Bob" Martin.

There are a total of six principles. The first three are concerned with package cohesion, determining which classes should go into which packages. The principles of package cohesion aid in determining how software is packaged and distributed.

###The Reuse-Release Equivalence Principle
*"The unit of reuse is the unit of release."*

This principle declares that a package should be used as a whole, and in turn, should be released as a whole. The release of a package is coupled to the expectation that it will be reused. To ensure that a package will be used as a whole by a dependent application, no classes should be included which will not be used in some way.

If classes are not intended for reuse, they should not be packaged for distribution. Such classes are likely tailored to a specialized application, perhaps grouped and structured in a way that is easily maintainable on a local scale. However, extra consideration must be made before packaging these classes for a public release. If a package contains software intended for reuse, then it should not also contain software that is not intended for reuse.

*"Either all of the classes inside the package are \[reused\], or none of them are."*

Effective reuse requires releases to be maintained, versioned, and tracked. This allows users to distinguish between different versions of the package. They will be able to determine which versions are compatible with their application, and which might not be. Being able to identify "safe to use" versions of a package helps in the development of applications dependent on a package.

When using a package, all classes used should be from the same version. Using a mixture of classes from different versions of the same package can easily lead to incompatibilities and introduce instability. This is a risk for classes copied out of a distribution with no regard for versioning. To avoid this, a release tracking system is needed. The author of the package is responsible for tracking and maintaining the package, typically identifying releases using names and/or numbers.

An argument might be made for tracking software at the class level. However, even the simplest software grows beyond this level of maintainability when well-accepted practices in object-oriented design are observed. Classes become too plentiful to track individually, making packages the more appropriate choice. A package as the granule of release promotes cohesion between the elements in a package.

###The Common-Reuse Principle
*How do these classes relate to one another?*

If two classes are not always used together, or are rarely used together, they should not be included in the same package together. When two such classes are not dependent on one another, it implies that they are intended for different purposes. Common purpose is a quality of classes within a single package.

For example, classes which provide methods for trigonometry might be used in conjunction with classes used in matrix calculations. However, they can (and likely will be) used independently of each other. There is no good reason to include software in a package if it cannot be guaranteed that the user will depend on it. The classes in a package should be reused together. If one class is used, they are all used.

Classes collaborating with each other tend to belong within the same package. The common-reuse principle suggests a firm stance when classes are always used together. The classes inside a package should be inseparable. A prime example of this is with collections and iterators. Iterators cannot ever be used without collections, whereas collections can sometimes be used without explicitly using iterators. However, many implementations of collections still use iterators in an opaque way. These two sets of classes are inseparable and should remain packaged together.

###The Common-Closure Principle
*A change which affects a package affects all of the classes within that package.*

Referring back to the last principle, classes inside of a package are coupled together. As a result, a change to one will result in change to all others, however minor. When classes are subject to change, localizing these changes to a package eases maintenance of the package itself. A change which affects a package affects all classes within that package and no others.

This approach is especially important when considering the users of the package. Any change requires revalidation of dependent software. Localizing changes to a package eases the release process, requiring less revalidation on the part of the user. Each change to a release must be justified for making these demands on the user. When a change to a set of classes affect multiple packages, more revalidation is necessary. When considering this smaller degree of change to an individual package, this means there's less justification for forcing the user into this process.

Dependence on every class in a package adequately justifies requiring the user to revalidate dependent software. Changes kept within a single package will share the same reason for occurring. This satisfies the principle's demand that a package should not have more than one reason to change. The reason for change should be directed by the purpose of the package itself, not by any software outside of this scope.
