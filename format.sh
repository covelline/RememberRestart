VERSION=0.53.2
OPTS="--swiftversion 5 ."
if which swiftformat >/dev/null; then
  swiftformat ${OPTS}
else
    mint run nicklockwood/SwiftFormat@${VERSION} ${OPTS}
fi
