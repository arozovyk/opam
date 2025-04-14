#!/bin/bash

set -xue

. .github/scripts/main/preamble.sh

unset-dev-version () {
  # disable git versioning to allow OPAMYES use for upgrade
  touch src/client/no-git-version
}

export OCAMLRUNPARAM=b

(set +x ; echo -en "::group::build opam\r") 2>/dev/null
if [[ "$OPAM_TEST" -eq 1 ]] || [[ "$OPAM_DOC" -eq 1 ]] || [[ "$OPAM_DEPENDS" -eq 1 ]] ; then
  export OPAMROOT=$OPAMBSROOT
  # If the cached root is newer, regenerate a binary compatible root
  opam env || { rm -rf $OPAMBSROOT; init-bootstrap; }
  eval $(opam env)
fi

case "$1" in
  *-pc-windows|*-w64-mingw32)
    CONFIGURE_PREFIX='D:\Local'
    PREFIX="$(cygpath "$CONFIGURE_PREFIX")";;
  *)
    PREFIX=~/local
    CONFIGURE_PREFIX="$PREFIX";;
esac

./configure --prefix $CONFIGURE_PREFIX --with-vendored-deps --with-mccs
if [ "$OPAM_TEST" != "1" ]; then
  echo 'DUNE_PROFILE=dev' >> Makefile.config
fi

if [ $OPAM_UPGRADE -eq 1 ]; then
  unset-dev-version
fi
# Disable implicit transitive deps
sed -i -e '/(implicit_transitive_deps /s/true/false/' dune-project
make all admin opam-stripped
sed -i -e '/(implicit_transitive_deps /s/false/true/' dune-project

rm -f "$PREFIX/bin/opam"
make install
(set +x ; echo -en "::endgroup::build opam\r") 2>/dev/null

export PATH="$PREFIX/bin:$PATH"
opam --version

if [[ "$OPAM_DOC" -eq 1 ]]; then
  make -C doc html man-html pages

  if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    . .github/scripts/common/hygiene-preamble.sh
    diff="git diff $BASE_REF_SHA..$PR_REF_SHA"
    set +e
    files=$($diff --name-only --diff-filter=A -- src/**/*.mli)
    set -e
    if [ -n "$files" ]; then
      echo '::group::new module(s) added - check index updated too'
      if $diff --name-only --exit-code -- doc/index.html ; then
        echo '::error new module(s) added but doc/index.html not updated'
        echo "$files"
        exit 3
      fi
      echo '::endgroup::new module added - checking it'
    else
      echo 'No new modules added'
    fi
  fi

  mapfile -t htmlfiles < <(ls doc/pages/*.md | sed -e 's/\.md$/.html/')
  mapfile -t manfiles < <(opam help topics | sed -e 's|.*|doc/man-html/opam-&.html|')
  mapfile -O "${#manfiles[@]}" -t manfiles < <(opam admin help topics | sed -e 's|.*|doc/man-html/opam-admin-&.html|')

  echo '::group::checking for generated files'
  echo "pages: $htmlfiles"
  echo "topics: $manfiles"
  files=("${htmlfiles[@]}" "${manfiles[@]}")
  missing=""
  for file in "${files[@]}"; do
    if ! test -f "$file" ; then
      missing="$missing '$file'"
    fi
  done
  if [ "x$missing" != "x" ]; then
    echo "::error missing generated doc files: $missing"
    exit 4
  fi
  echo '::endgroup::checking generated files'
fi

prepare_project () {
  # warning, perform a cd
  org=$1
  project=$2

  url="https://github.com/$org/$project"
  dir="$CACHE/$project"

  if [ ! -d "$CACHE/$project" ]; then
    git clone "$url" "$dir"
  fi
  cd "$dir"
  git fetch origin
  if [ "$GITHUB_EVENT_NAME" = "pull_request" ] && git ls-remote --exit-code origin "$GITHUB_PR_USER/$BRANCH" ; then
    BRANCH=$GITHUB_PR_USER/$BRANCH
  fi
  if git ls-remote --exit-code origin "$BRANCH"; then
    PR_BRANCH=$BRANCH
  elif [ "$GITHUB_EVENT_NAME" = pull_request ] && git ls-remote --exit-code origin "$GITHUB_BASE_REF"; then
    PR_BRANCH=$GITHUB_BASE_REF
  else
    PR_BRANCH=master
  fi
  if git branch | grep -q "$PR_BRANCH"; then
    git checkout "$PR_BRANCH"
    git reset --hard "origin/$PR_BRANCH"
  else
    git checkout -b "$PR_BRANCH" "origin/$PR_BRANCH"
  fi

  test -d _opam || opam switch create . --no-install --formula '"ocaml-system"'
  eval $(opam env)
  opam pin "$GITHUB_WORKSPACE" -yn --with-version to-test
}

if [ "$OPAM_TEST" = "1" ]; then
  # test if an upgrade is needed
  set +e
  opam list 2> /dev/null
  rcode=$?
  if [ $rcode -eq 10 ]; then
    echo "Recompiling for an opam root upgrade"
    (set +x ; echo -en "::group::rebuild opam\r") 2>/dev/null
    unset-dev-version
    make all admin
    rm -f "$PREFIX/bin/opam"
    make install
    opam list 2> /dev/null
    rcode=$?
    set -e
    if [ $rcode -ne 10 ]; then
      echo -e "\e[31mBad return code $rcode, should be 10\e[0m";
      exit $rcode
    fi
    (set +x ; echo -en "::endgroup::rebuild opam\r") 2>/dev/null
  fi
  set -e

  # Note: these tests require a "system" compiler and will use the one in $OPAMBSROOT
  make tests

  make distclean

  # Compile and run opam-rt
  (set +x ; echo -en "::group::opam-rt\r") 2>/dev/null
  prepare_project "ocaml-opam" "opam-rt"

  # opam lib pins defined in opam-rt are ignored as there is a local pin
  opam pin . -yn --ignore-pin-depends
  opam install opam-rt --deps-only opam-devel.to-test
  make || { opam reinstall opam-client -y; make; }
  (set +x ; echo -en "::endgroup::opam-rt\r") 2>/dev/null
fi

test_project () {
  org=$1
  project=$2
  ignore_depends=$3
  make_cmd=$4

  ignore=""
  if [ $ignore_depends -eq 1 ]; then
    ignore="--ignore-pin-depends"
  fi

  (set +x; echo -en "::group::depends-$project\r") 2>/dev/null
  prepare_project "$org" "$project"
  set +e
  opam pin . -yn $ignore
  opam install "$project" --deps-only opam-client.to-test
  $make_cmd || { opam reinstall opam-client -y; $make_cmd; }
  code=$?
  if [ $code -ne 0 ]; then
    DEPENDS_ERRORS="$DEPENDS_ERRORS $project"
  fi
  set -e
  (set +x ; echo -en "::endgroup::depends-$project\r") 2>/dev/null
}

if [ "$OPAM_DEPENDS" = "1" ]; then

  DEPENDS_ERRORS=""
  (set +x; echo -en "::group::depends\r") 2>/dev/null

  test_project "ocaml-opam" "opam-publish" 0 "make"

  if [ -n "$DEPENDS_ERRORS" ]; then
    echo -e "\e[31mErrors detected in plugins $DEPENDS_ERRORS\e[0m";
    echo 1
  fi
  (set +x ; echo -en "::endgroup::depends\r") 2>/dev/null
fi
