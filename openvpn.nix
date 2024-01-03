{openvpn}:
openvpn.overrideAttrs (oldAttrs: {
  patches = [./openvpn-v2.6.8-aws.patch];
})
