  #!/usr/bin/env bash
  opam_libs=$(./opam show . -f name 2>/dev/null)
  depends_on=$(echo "$opam_libs" | sed 's/$/.2.3.0/' | paste -sd, -)

  packages=$(./opam list --or --depends-on "$depends_on" --columns name -s )

  for exclude in $opam_libs; do
    packages=$(echo "$packages" | grep -v -x "$exclude")
  done
 

 echo $packages

 


all_opam_revdeps=$(opam list --or --recursive --depends-on opam-state,opam-solver,opam-repository,opam-installer,opam-format,opam-devel,opam-core,opam-client --columns name | tail -n +3 | sort)

odoc_revdeps=$(opam list --recursive --depends-on odoc --columns name | tail -n +3 | sort)

echo "📦 Packages depending on both odoc and at least one opam-* lib:"
comm -12 <(echo "$all_opam_revdeps") <(echo "$odoc_revdeps")