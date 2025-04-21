{
  description = "Python venv development template";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      pythonPackages = pkgs.python3Packages;
    in {
      devShells.default = pkgs.mkShell {
        name = "python-venv";
        venvDir = "./.venv";
        buildInputs = [
          pythonPackages.python
          pythonPackages.venvShellHook
          pythonPackages.numpy
        ];

        postVenvCreation = ''
          unset SOURCE_DATE_EPOCH
          pip install -r requirements.txt
        '';
        postShellHook = ''
          # allow pip to install wheels
          unset SOURCE_DATE_EPOCH
        '';
      };
      packages.default = with pkgs.python3Packages; buildPythonPackage rec {
        pname = "ddddocr";
        doCheck = false;

        nativeBuildInputs = [ pkgs.installShellFiles ];

        build-system = [
          setuptools
          setuptools-scm
        ];

        dependencies = [
          numpy
          onnxruntime
          pillow
          opencv-python-headless
        ];

        src = ./.;
        version = "1.5.5";
      };
    });
}
