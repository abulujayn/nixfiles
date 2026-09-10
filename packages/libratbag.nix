{ libratbag, fetchFromGitHub }:

libratbag.overrideAttrs {
  src = fetchFromGitHub {
    owner = "libratbag";
    repo = "libratbag";
    rev = "b8d4d3ca1f4d6b23c664ffee2888b8eb669bee21";
    hash = "sha256-8V/LIki/tI/9Wi6kuFJp6k1p+moMh8Gc8RNP1BUlZO8=";
  };
}
