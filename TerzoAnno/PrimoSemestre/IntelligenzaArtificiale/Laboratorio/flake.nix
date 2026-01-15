{
  description = "ai-lab environment with Python 3.7";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    jupyterlab-gruvbox = pkgs.python3Packages.buildPythonPackage rec {
      pname = "jupyterlab-gruvbox-dark";
      version = "0.1.0";
      format = "wheel";

      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/py3/j/jupyterlab-gruvbox-dark/jupyterlab_gruvbox_dark-0.1.0-py3-none-any.whl";
        sha256 = "89ac133d401eff9f83f33be1ca812e9c3ad9e93d277c0aaa231934b5621d93bb";
      };

      doCheck = false;
    };

    pythonEnv = pkgs.python3.withPackages (ps:
      with ps; [
        scipy
        numpy
        jupyterlab
        jupyterlab-gruvbox
        ipykernel
        matplotlib
        tqdm
      ]);
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "ai-lab";

      packages = [
        pythonEnv
        pkgs.nodejs
      ];

      shellHook = ''
        export JUPYTER_CONFIG_DIR="$PWD/.jupyter/config"
        export JUPYTER_DATA_DIR="$PWD/.jupyter/data"
        export JUPYTER_RUNTIME_DIR="$PWD/.jupyter/runtime"
        export JUPYTERLAB_SETTINGS_DIR="$PWD/.jupyter/user-settings"
        export JUPYTERLAB_WORKSPACES_DIR="$PWD/.jupyter/workspaces"

        # Clear previous state
        rm -rf "$JUPYTER_RUNTIME_DIR"
        rm -rf "$JUPYTERLAB_WORKSPACES_DIR"
        mkdir -p "$JUPYTER_RUNTIME_DIR"

        # Apply theme
        THEME_DIR="$JUPYTERLAB_SETTINGS_DIR/@jupyterlab/apputils-extension"
        mkdir -p "$THEME_DIR"
        echo '{"theme": "jupyterlab_gruvbox_dark"}' > "$THEME_DIR/themes.jupyterlab-settings"

        # Use defined kernel
        export IPYTHONDIR="$PWD/.jupyter/ipython"
        python -m ipykernel install --user --name=ai-lab --display-name="Python (AI Lab)" > /dev/null

        echo "Starting Jupyter Notebook..."
        jupyter lab
      '';
    };
  };
}
