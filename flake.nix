{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    { self
    , nixpkgs
    ,
    }:
    let
      package =
        { pkgs
        , recorder
        , ...
        }:
        pkgs.writeShellScriptBin "rec-sh" ''
          function slurp() { ${pkgs.slurp}/bin/slurp "$@"; }
          function ffmpeg() { ${pkgs.ffmpeg}/bin/ffmpeg "$@"; }
          ${
            if (builtins.isNull recorder)
            then ""
            else "RECSH_RECORDER=${recorder}"
          }

          ${builtins.readFile ./rec.sh}
        '';

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        f system pkgs);

      hmModule =
        { config
        , lib
        , pkgs
        , ...
        }:
        let
          cfg = config.programs.rec-sh;
        in
        {
          options.programs.rec-sh = options { inherit config lib pkgs; };
          config = with lib;
            mkIf cfg.enable {
              home.packages =
                let
                  recorder = cfg.recorder;
                in
                [
                  (package { inherit pkgs recorder; })
                ];
            };
        };

      nixosModule =
        { config
        , lib
        , pkgs
        , ...
        }:
        let
          cfg = config.programs.rec-sh;
        in
        {
          options.programs.rec-sh = options { inherit config lib pkgs; };
          config = with lib;
            mkIf cfg.enable {
              environment.systemPackages =
                let
                  recorder = cfg.recorder;
                in
                [
                  (package { inherit pkgs recorder; })
                ];
            };
        };

      options =
        { config
        , lib
        , pkgs
        , ...
        }:
          with lib;
          with lib.types; {
            enable = mkEnableOption "";
            recorder = mkOption {
              type = nullOr str;
              default = "${pkgs.wf-recorder}/bin/wf-recorder";
            };
          };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      packages =
        forAllSystems
          (system: pkgs:
            let
              recorder = null;
            in
            {
              rec-sh = package { inherit pkgs recorder; };
              default = self.packages.${system}.rec-sh;
            });

      legacyPackages =
        forAllSystems
          (system: pkgs:
            let
              recorder = null;
            in
            {
              rec-sh = package { inherit pkgs recorder; };
              default = self.legacyPackages.${system}.rec-sh;
            });

      nixosModules = {
        rec-sh = nixosModule;
        default = self.nixosModules.rec-sh;
      };

      homeManagerModules = {
        rec-sh = hmModule;
        default = self.homeManagerModules.rec-sh;
      };
      homeManagerModule = self.homeManagerModules.rec-sh;

      devShells =
        forAllSystems
          (system: pkgs: {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [
                slurp
                ffmpeg
                wf-recorder
                shellharden
              ];
            };
          });
    };
}
