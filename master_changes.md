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
  * Use coreutils' `sha512sum` instead of perl's `shasum` utility when using `./configure --with-cygwin-setup` [#6566 @kit-ty-kate - fix #6557]

## Infrastructure

## Release scripts
  * Switch the host of qemu-base-images from gitlab to github [#6510 @kit-ty-kate]
  * Speedup the initial clone of qemu-base-images when missing [#6510 @kit-ty-kate]
  * Update some of the platforms the prebuilt binaries are built on to Alpine 2.21, FreeBSD 14.3, OpenBSD 7.7 and NetBSD 10.1 [#6510 @kit-ty-kate]

## Install script
  * Add opam 2.4.0~beta1 [#6559 @kit-ty-kate]

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
  * Add a doc generation job under linux [#5349 @rjbou]
  * Update the github action scripts now that homebrew renamed the GNU patch binary to gpatch [#6296 @kit-ty-kate]
  * Add branch scheme `username/branch` for opam-rt specific branch to use [#6274 @rjbou]
  * Check `shell/install.sh` using `shellcheck` [#6313 @kit-ty-kate]
  * Fix the alpine depexts test [#6363 @kit-ty-kate]
  * Speedup the gentoo depexts test [#6363 @kit-ty-kate]
  * Add OCaml 5.3 to the build matrix [#6192 @kit-ty-kate]
  * Add OCaml 5.3/MSVC to the build matrix [#6192 @kit-ty-kate]
  * Add a test making sure `opam init` works in the absence of `OPAMROOT` [#5663 @kit-ty-kate]
  * Show Cygwin version info after loading it from the cache [#6383 @kit-ty-kate]
  * Upgrade the opam version used to setup the depexts workflows to 2.3.0 [#6444 @kit-ty-kate]
  * Enable the depexts workflow on master and when the opam description change [#6447 @kit-ty-kate]
  * Make depext generate action script pass spellcheck [#6471 @kit-ty-kate]
  * Add depext generate action script to spellcheck check action [#6471 @kit-ty-kate]
  * Some cleaning in depext generate action and instruction for local testing [#6471 @rjbou]
  * Cache the repository and a minimal one in docker image for depext jobs [#6471 @rjbou]
  * Use the good opam binary in depext jobs [#6471 @RyanGibb]
  * Add a job that test plugins compilation in order to keep them synchroniser [#6394 @rjbou]

## Doc

## Security fixes

# API updates
## opam-client

## opam-repository

## opam-state

## opam-solver

## opam-format

## opam-core
