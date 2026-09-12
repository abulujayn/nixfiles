final: prev:
{
  noctalia = prev.noctalia.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      file="src/shell/control_center/tabs/home_tab.cpp"

      # Fail clearly if upstream changes the relevant Home layout.
      grep -qF '// --- Media (top of left column) ---' "$file" || {
        echo "Noctalia Home media block has changed upstream"
        exit 1
      }

      grep -qF 'leftColumn->addChild(std::move(mediaCard));' "$file" || {
        echo "Noctalia Home media insertion has changed upstream"
        exit 1
      }

      # Remove the Home media-card construction.
      sed -i \
        '/\/\/ --- Media (top of left column) ---/,/\/\/ --- Date\/Time + Weather (below media) ---/ {
          /\/\/ --- Date\/Time + Weather (below media) ---/!d
        }' \
        "$file"

      # Don't add the removed card to the Home layout.
      sed -i \
        '/leftColumn->addChild(std::move(mediaCard));/d' \
        "$file"
    '';
  });
}
