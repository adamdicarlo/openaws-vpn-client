{ lib
, glib
, gtk3
, pkg-config
, makeRustPlatform
, rust-bin
, wrapGAppsHook
, openvpn
, makeBinaryWrapper
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.minimal);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.minimal);
  };

in rustPlatform.buildRustPackage {
  pname = "openaws-vpn-client";
  version = "0.1.7";

  buildInputs = [
    pkg-config
    glib
    gtk3
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    makeBinaryWrapper
    pkg-config
  ];

  src = ./.;

  cargoHash = "sha256-yjhGDiO0pMVw9KFEUbCCF16uPfuusrxBKbFQcHlKYqY=";

  postInstall = ''
    install -Dt $out/share/applications ./share/applications/openaws-vpn-client.desktop
    install -Dt $out/share/openaws-vpn-client ./share/pwd.txt
    wrapProgram $out/bin/openaws-vpn-client \
      --set OPENVPN_FILE "${lib.makeBinPath [ openvpn ]}/openvpn" \
      --set SHARED_DIR "$out/share/openaws-vpn-client"
  '';

  meta = with lib; {
    description = "Unofficial open-source AWS VPN client written in Rust";
    homepage = "https://github.com/JonathanxD/openaws-vpn-client";
    license = licenses.mit;
  };
}
