# The Flyweight Pattern (A structural design pattern)
The Flyweight Structural design pattern aims to optimizes memory usage by sharing common data among instances.
* Separates the permanent and the changing parts
* Clients provide the changeable, extrinsic state
* The intrinsic, immutable state gets shared between flyweight objects
The pattern reduces memory usage by sharing common objects across multiple contexts.

## How it works
* Separates intrinsic, immutable state from changing, extrinsic state
* The intrinsic state is stored within the Flyweight    
* Clients pass extrinsic state to the Flyweight

## Benefits
* Can significantly reduce memory usage


## Pitfalls
* High number of extrinsic states affects pattern performance
* Compromised efficiency when clients access Flyweight objects directly.
* Code complexity


## Conclusion
* The Flyweight can optimize memory usage when numerous objects share the same common state


