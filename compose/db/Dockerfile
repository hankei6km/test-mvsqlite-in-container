ARG VARIANT=ubuntu
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY docker-entrypoint* /

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  # Intall tools
  # * build-essential - make sqlite3(dynamic link ver)
  # * fuse3 - for FUSE mode
  # * sqlite3 - use to try FUSE mode
  && apt-get -y install --no-install-recommends build-essential fuse3 sqlite3 2>&1 \
  # Isntall FoundationDB
  && wget https://github.com/apple/foundationdb/releases/download/7.1.15/foundationdb-clients_7.1.15-1_amd64.deb \
  && dpkg -i foundationdb-clients_7.1.15-1_amd64.deb \
  && wget https://github.com/apple/foundationdb/releases/download/7.1.15/foundationdb-server_7.1.15-1_amd64.deb \
  && dpkg -i foundationdb-server_7.1.15-1_amd64.deb \
  # cleanup
  && rm foundationdb-clients_7.1.15-1_amd64.deb foundationdb-server_7.1.15-1_amd64.deb \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  ## Change FoundatioDB config
  #&& echo -e "[fdbserver.4501]\n[fdbserver.4502]\n[fdbserver.4503]\n[fdbserver.4504]" >> /etc/foundationdb/foundationdb.conf \
  # Setup entrypoint
  && chmod a+x /docker-entrypoint.sh \
  && chmod a+x /docker-entrypoint-start.sh \
  && chmod a+x /docker-entrypoint-node.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

ARG USERNAME=vscode
WORKDIR "/home/${USERNAME}"
USER ${USERNAME}

# Install mvSQLite into user env
RUN mkdir -p "/home/${USERNAME}/mvsqlite/my_databases" \
  && cd "/home/${USERNAME}/mvsqlite" \
  && curl -L -o ./libmvsqlite_preload.so https://github.com/losfair/mvsqlite/releases/download/v0.1.16/libmvsqlite_preload.so \
  && curl -L -o ./mvstore https://github.com/losfair/mvsqlite/releases/download/v0.1.16/mvstore \
  && chmod +x ./mvstore \
  && curl -L -o ./mvsqlite-fuse https://github.com/losfair/mvsqlite/releases/download/v0.1.16/mvsqlite-fuse \
  && chmod +x ./mvsqlite-fuse \
  # Build sqlite(dynamic link)
  && wget https://www.sqlite.org/2022/sqlite-amalgamation-3390200.zip \
  && unzip sqlite-amalgamation-3390200.zip \
  && rm sqlite-amalgamation-3390200.zip \
  && cd sqlite-amalgamation-3390200 \
  && gcc -O2 -fPIC --shared -o libsqlite3.so ./sqlite3.c -lpthread -ldl -lm \
  && gcc -O2 -o sqlite3 ./shell.c -L. -lsqlite3

COPY --chown="vscode:users" mvsql/* "/home/${USERNAME}/mvsqlite/"
#RUN chmod u+x "/home/${USERNAME}/mvsqlite/start_mvsql.sh" \
#  && chmod u+x "/home/${USERNAME}/mvsqlite/create_test_ns.sh" \
#  && chmod u+x "/home/${USERNAME}/mvsqlite/sqlite_mv.sh" \
#  && chmod u+x "/home/${USERNAME}/mvsqlite/mount_mvsql.sh"

