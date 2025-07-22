Working version changelog, used as a base for the changelog and the release
note.
Prefixes used to help generate release notes, changes, and blog posts:
* ✘ Possibly scripts breaking changes
* ◈ New option/command/subcommand
* [BUG] for bug fixes
* [NEW] for new features (not a command itself)
* [API] api updates 🕮
If there is changes in the API (new non optional argument, function renamed or
moved, etc.), please update the _API updates_ part (it helps opam library
users)

## Version
  * Add `opam 2.4.0~rc1` to the install scripts [#6583 @kit-ty-kate]
  * Bump the version number to `2.5.0~alpha1~dev` [#6584 @kit-ty-kate]

## Global CLI

## Plugins

## Init

## Config report

## Actions

## Install

## Build (package)

## Remove

## UI

## Switch

## Config

## Pin

## List

## Show

## Var/Option

## Update / Upgrade

## Tree

## Exec

## Source

## Lint

## Repository

## Lock

## Clean

## Env

## Opamfile

## External dependencies

## Format upgrade

## Sandbox

## VCS

## Build

## Infrastructure

## Release scripts

## Install script

## Admin

## Opam installer

## State

## Opam file format

## Solver

## Client

## Shell

## Internal

## Internal: Unix

## Internal: Windows

## Test

## Benchmarks

## Reftests
### Tests

### Engine

## Github Actions

## Doc

## Security fixes

# API updates
## opam-client

## opam-repository
  * `OpamRepositoryBackend.update`: change type `Update_patch (filename * filename list)` to also hold the list of changed filed [#6614 @arozovyk - fix #5824]
  * `OpamRepositoryBackend.get_diff`: change the return type to `(filename * filename list) option` to include the list of changed files [#6614 @arozovyk - fix #5824]
  * `OpamRepository.update`: change the return type to include the list of changed files [#6614 @arozovyk - fix #5824]

## opam-state

## opam-solver

## opam-format

## opam-core
