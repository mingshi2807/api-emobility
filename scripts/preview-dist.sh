#!/bin/sh
set -eu

preview_dir=".redocly-preview-dist"
mkdir -p "$preview_dir"
cp logo-vedecom.png logo-vedecom-dark.png favicon-vedecom.png "$preview_dir/"
cp AGENTS.md readme.md "$preview_dir/"
if [ -L "$preview_dir/dist" ]; then
  rm "$preview_dir/dist"
fi

for api_dir in ERM HEMS OBC OCPP_OCPI OpenADR PKI charge-point ev-virtualizer; do
  link="$preview_dir/$api_dir"
  if [ -L "$link" ]; then
    rm "$link"
  fi
  if [ ! -e "$link" ]; then
    ln -s "../dist/$api_dir" "$link"
  fi
done

# Redocly preview loads redocly.yaml from --project-dir, so adapt the dist config
# into a temporary source-shaped project. Roots still resolve to bundled
# artifacts through the symlinked dirs.
sed \
  -e 's#root: \./dist/#root: ./#' \
  redocly.dist.yaml > "$preview_dir/redocly.yaml"

redocly preview --project-dir "$preview_dir" --product=realm --port="${PORT:-4000}" "$@"
