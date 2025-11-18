# StateMachineTree
 System for creating non-animation state machines using Godot's AnimationTrees. Godot's AnimationStateMachine interface is super convenient for managing Animation States, its a shame it can't be used to drive behaviour rather than Animation... Or can it?

## StateTree
- Holds lists of StateCallbacks
- Automatically generates an AnimationPlayer with an empty "State" animation
- Automatically sets it's tree_root to a new AnimationStateMachine
  
Build out your state machine by creating "State" animation states, and naming them how you like. Then, start adding callbacks to the StateTree, using the names you choose as the key.

### Entry Callbacks
Called when the state is entered

### Update Callbacks
Called when the state is updated

### Exit Callbacks
Called when the state is exited

## StateMethodCallback
- Invokes a method when called
- Comes in Node and Resource flavors

## StatePropertyCallback
- Sets a specific property to a specific value when caleld
- Comes in Node and Resource flavors
