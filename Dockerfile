FROM postgres:12

LABEL MAINTAINER Manuela Weigold <manuela.weigold@iaas.uni-stuttgart.de>

ENV PATTERN_ATLAS_CONTENT_REPOSITORY_URL "https://github.com/PatternAtlas/pattern-atlas-content.git"
ENV PATTERN_ATLAS_PRIVATE_CONTENT_REPOSITORY_URL "git@github.com:PatternAtlas/internal-pattern-atlas-content.git"
ENV PATTERN_ATLAS_CONTENT_REPOSITORY_BRANCH "master"
ENV SUBFOLDER_CONTENT_REPO_BACKUP_FILES "db-backup-files"
ENV COPY_CONTENT_REPOSITORY_TARGET_PATH "/var/pattern-atlas/testdata"
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_USER postgres
ENV JDBC_DATABASE_PORT 5060
ENV POSTGRES_DB db
ENV READ_ONLY false

# install dependencies (git)
RUN  apt-get update \
  && apt-get update -qq && apt-get install -qqy \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 5060

COPY clone-data-repo.sh clone-data-repo.sh
COPY create-read-only-user.sh create-read-only-user.sh


# if ssh key is set, clone data repo with the sql scripts for initalization and start postgres afterwards
CMD chmod 700 clone-data-repo.sh \
    && ./clone-data-repo.sh \
    && chmod 700 create-read-only-user.sh \
    && ./create-read-only-user.sh \
    && su postgres -c "/usr/local/bin/docker-entrypoint.sh postgres -p ${JDBC_DATABASE_PORT}"
