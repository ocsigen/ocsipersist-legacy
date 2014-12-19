# Ocsipersist

Ocsipersist is an extension for ocsigen server to use a key/value store. It's used pervasively in Eliom to handle sessions and references.

The project contains several backends:
- dbm
- sqlite

Each backend must implement the signature `Ocsipersist_sig` in a module named `Ocsipersist`. Only one backend can be used at a time, and the choice is done by linking the chosen backend.

## Install

You can install with opam:

- pin this repository
- `opam install ocsipersist`
