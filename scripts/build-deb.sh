#!/usr/bin/env bash
# Build the dictinstant .deb and regenerate the flat APT repository metadata.
# Usage: bash scripts/build-deb.sh
set -euo pipefail
cd "$(dirname "$0")/.."

PKG="dictinstant"
VERSION="0.1.0"
STAGE="$(mktemp -d /tmp/di-build.XXXXXX)"
SITE_REPO="$(pwd)/site/repo"
GPGHOME="/tmp/di-gnupg"
mkdir -p "$GPGHOME"; chmod 700 "$GPGHOME"

echo "◆ Assembling package layout…"
mkdir -p "$STAGE/DEBIAN" "$STAGE/usr/bin" \
         "$STAGE/usr/share/$PKG/app" "$STAGE/usr/share/doc/$PKG"
cp site/app/index.html "$STAGE/usr/share/$PKG/app/index.html"
cp packaging/scripts/dictinstant "$STAGE/usr/bin/dictinstant"
chmod 755 "$STAGE/usr/bin/dictinstant"
cp packaging/debian/control "$STAGE/DEBIAN/control"
cp packaging/debian/rules "$STAGE/DEBIAN/rules"
printf '%s %s - Instant multi-source dictionary definitions\n' "$PKG" "$VERSION" \
  | gzip -9 -c > "$STAGE/usr/share/doc/$PKG/changelog.Debian.gz"

echo "◆ Building .deb…"
DEB="$STAGE/$PKG.deb"
dpkg-deb --root-owner-group --build "$STAGE" "$DEB" >/dev/null

echo "◆ Regenerating APT metadata…"
cp "$DEB" "$SITE_REPO/$PKG.deb"
cd "$SITE_REPO"
{
  echo "Package: $PKG"
  echo "Version: $VERSION"
  echo "Architecture: all"
  echo "Maintainer: Dariush Khosrowan <dariush@khosrowan.ir>"
  echo "Installed-Size: $(du -sk "$STAGE" | awk '{print $1}')"
  echo "Depends: python3"
  echo "Section: education"
  echo "Priority: optional"
  echo "Filename: ./$PKG.deb"
  echo "Size: $(stat -c%s "$PKG.deb")"
  echo "SHA256: $(sha256sum "$PKG.deb" | awk '{print $1}')"
  echo "Description: Instant multi-source dictionary definitions, examples and pictures"
  echo " Shows many definitions of a word from different free dictionaries at once —"
  echo " with example sentences and pictures — so you choose the meaning that clicks."
} > Packages
gzip -9 -c Packages > Packages.gz

SIZE_P=$(stat -c%s Packages); SIZE_GZ=$(stat -c%s Packages.gz)
{
  echo "Origin: dictinstant"
  echo "Label: dictinstant"
  echo "Suite: stable"
  echo "Codename: dictinstant"
  echo "Architectures: all"
  echo "Components: main"
  echo "Description: dictinstant APT repository"
  echo "Date: $(date -u +'%a, %d %b %Y %H:%M:%S UTC')"
  echo "MD5Sum:"
  echo " $(md5sum Packages | awk '{print $1}') $SIZE_P Packages"
  echo " $(md5sum Packages.gz | awk '{print $1}') $SIZE_GZ Packages.gz"
  echo "SHA1:"
  echo " $(sha1sum Packages | awk '{print $1}') $SIZE_P Packages"
  echo " $(sha1sum Packages.gz | awk '{print $1}') $SIZE_GZ Packages.gz"
  echo "SHA256:"
  echo " $(sha256sum Packages | awk '{print $1}') $SIZE_P Packages"
  echo " $(sha256sum Packages.gz | awk '{print $1}') $SIZE_GZ Packages.gz"
} > Release

rm -f InRelease Release.gpg
gpg --batch --homedir "$GPGHOME" --pinentry-mode loopback --passphrase '' \
  --clearsign -o InRelease Release
gpg --batch --homedir "$GPGHOME" --pinentry-mode loopback --passphrase '' \
  -abs -o Release.gpg Release
cp "$GPGHOME/dictinstant.gpg" "$SITE_REPO/dictinstant.gpg"

echo "✔ Built: $SITE_REPO/$PKG.deb"
ls -1 "$SITE_REPO"
rm -rf "$STAGE"
