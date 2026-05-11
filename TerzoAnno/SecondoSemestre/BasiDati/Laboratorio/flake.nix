{
  description = "PostgreSQL Devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true; # for mongodb
    };

    packages = with pkgs; [
      postgresql_18
      postgres-language-server
      python3
      python3Packages.psycopg2
      basedpyright
    ];
  in {
    devShells.${system} = {
      default = self.devShells.${system}.local;

      local = pkgs.mkShell {
        inherit packages;

        shellHook = ''
          # Create a diretory for the generated artifacts
          mkdir .nix-shell
          export NIX_SHELL_DIR=$PWD/.nix-shell

          # Put the PostgreSQL databases in the project diretory.
          export PGDATA=$NIX_SHELL_DIR/db

          # Clean up after exiting the Nix shell using `trap`
          # Executes only if there are no other Nix shells running
          cleanup() {
            # Stop PostgreSQL if it's running
            if pg_ctl -D $PGDATA status > /dev/null 2>&1; then
              pg_ctl -D $PGDATA stop
            fi

            # Delete `.nix-shell` directory
            cd $PWD
            rm -rf $NIX_SHELL_DIR
          }

          trap cleanup EXIT

          # If database is  not initialized (i.e., $PGDATA  directory does not
          # exist), then set  it up. Seems superfulous given  the cleanup step
          # above, but handy when one gets to force reboot the iron.
          if ! test -d $PGDATA
          then
            # Init PostgreSQL
            initdb $PGDATA

            # PostgreSQL  will  attempt  to create  a  pidfile  in
            # `/run/postgresql` by default, but it will fail as it
            # doesn't exist. By  changing the configuration option
            # below, it will get created in $PGDATA.
            OPT="unix_socket_directories"
            sed -i "s|^#$OPT.*$|$OPT = '$PGDATA'|" $PGDATA/postgresql.conf
          fi

          # Start PostgreSQL if it's not already running
          if ! pg_ctl -D $PGDATA status > /dev/null 2>&1; then
            pg_ctl -D $PGDATA -l $PGDATA/postgres.log start
          fi

          printf "PostgreSQL is running. To connect, use:\n\
          psql -h $PGDATA -U $USER -d postgres\n\n\
          Or via PostgreSQL connection URL:\n\
          postgresql://$USER@localhost/postgres\n"
        '';
      };

      uni = pkgs.mkShell {
        packages =
          packages
          ++ (with pkgs; [
            gpclient
          ]);

        shellHook = ''
          # Clean up after exiting the Nix shell using `trap`
          # Executes only if there are no other Nix shells running
          cleanup() {
            # Stop the vpn if it's running
            if test -n "$GPCLIENT_PID" && kill -0 $GPCLIENT_PID > /dev/null 2>&1; then
              kill $GPCLIENT_PID > /dev/null 2>&1
            fi
          }
          trap cleanup EXIT

          printf "Connecting to university's VPN:\n"
          sudo -v

          sudo gpclient --quiet --ignore-tls-errors connect "vpn.univr.it" > /dev/null 2>&1 &
          GPCLIENT_PID=$!

          printf "To connect to the uni database server, use:\n\
          psql -h dbserver.scienze.univr.it -U <userGIA> <userGIA>\n\n\
          Or via PostgreSQL connection URL:\n\
          postgresql://userGIA@dbserver.scienze.univr.it/userGIA\n"
        '';
      };

      mongo = pkgs.mkShell {
        packages = with pkgs; [
          mongosh
          mongodb-compass
          typescript-language-server
        ];

        # mongosh \"mongodb+srv://<username>:<password>@<cluster-url>/<database>\"\n\n\
        shellHook = ''
          printf "MongoDB environment is ready.\n\n\
          To connect to your cluster using the MongoDB Shell, use:\n\
          mongosh \"mongodb+srv://freecluster.7ev9td5.mongodb.net/\" --apiVersion 1 --username fabiooo4
          To connect using the GUI, run:\n\
          mongodb-compass\n"
        '';
      };
    };
  };
}
