{
  description = "Sisyphe system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    sops-nix.url = "github:Mic92/sops-nix";
    rgrunbla-pkgs.url = "github:rgrunbla/Flakes";
  };

  outputs = { self, nixpkgs, sops-nix, rgrunbla-pkgs }: {
    devShell.x86_64-linux = with import nixpkgs { system = "x86_64-linux"; };
      mkShell {
        buildInputs = [ ansible ];
        ANSIBLE_INVENTORY = "./hosts";
        shellHook = ''
          ansible-galaxy collection install community.general
        '';
      };
  };
}
