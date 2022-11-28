# dokuwiki-docker

![GitHub](https://img.shields.io/github/license/thatsydneything/dokuwiki-docker?style=for-the-badge) ![Snyk Vulnerabilities for GitHub Repo](https://img.shields.io/snyk/vulnerabilities/github/thatsydneything/dokuwiki-docker?style=for-the-badge) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/thatsydneything/dokuwiki/latest?style=for-the-badge) ![Docker Pulls](https://img.shields.io/docker/pulls/thatsydneything/dokuwiki?style=for-the-badge)

dokuwiki-docker is a lightweight, simple and highly customisable containerisation of the flat file based wiki, Dokuwiki!

This image has been designed to be as lightweight and secure as possible, but is still a work in progress, and I'm fairly new to creating Dockerfiles. To that end, any ideas, suggestions or feedback are welcome and can be submitted as issues.

## Versioning

The versioning for the dokuwiki images are simple - they follow the pattern of the dokuwiki release date followed by an increment which represents the revision of the container for the particular dokuwiki version. There are three ways to get the image:

| Version Syntax                    | Example                                                | What You Get |
| -------------                 |--------------                                             | - |
| `thatsydneything/<app-name>:latest`  | `thatsydneything/dokuwiki:latest` | The absolute latest revision of the dokuwiki container, regardless of the underlying dokuwiki version |
| `thatsydneything/<app-name>:<app-version>`       | `thatsydneything/dokuwiki:20220731a` | The latest revision of the dokwuki container with the underlying dokuwiki version of `2022-07-31a |`
| `thatsydneything/<app-name>:<app-version>.<increment>`          | `thatsydneything/dokuwiki:20220731a.0` | The specific first release of the dokuwiki container with the underlying dokuwiki version of `2022.07.31a` |

## Environment Variables

The container supports a number of different environment variables to customer the installation of the dokuwiki instance. *Note*: These variables are only used by the container for its first-time install. If the instance is persisted (refer persistence below), these variables are ignored.

| Variable                    | Function                                                  | Default |
| -------------                 |--------------                                             | - |
| `LANG`                | Sets the language used by the install. For information around which languages are available and the completeness of the translation, refer to https://translate.dokuwiki.org/ | `EN` |
| `ACL`         | Whether or not Access Control Lists are enabled. Acceptable values are `ON` and `OFF` | `ON`|
| `ACL_POLICY`           | What ACL Policy to apply to the install. Acceptable values are: `0`, `1` and `2` | `2` |
| `LICENSE`              | The licence to display on the wiki. Acceptable values are: | `0` |
| `ALLOW_REG`        | Whether new users are allowed to register on the wiki. Acceptable values are `ON` and `OFF` | `OFF` |
| `POP`                     | Whether to send anonymous usage statistics to Dokuwiki once per month. Acceptable values are `ON` and `OFF` | `OFF` |
| `TITLE`              | The title of the wiki   | `DokuWiki` |
| `USERNAME`              | The username for the initial Admin or 'Super User'                 | `WikiUser` |
| `PASSWORD` **REQUIRED**             | The password for the initial Admin or 'Super User'. **This variable is required, and the install will fail if it is not provided!** |
| `FULL_NAME`               | The full/real name of the initial Admin or 'Super User' | `Wiki User` |
| `EMAIL`            | The email address for the initial Admin or 'Super User' | `test@test.com` |

## Persistence

There are three folders that are required to be mounted to persist dokuwiki's data:

- `/usr/share/dokuwiki/conf` - all configuration, security settings and user accounts for the install.
- `/usr/share/dokuwiki/data` - all content.
- `/usr/share/dokuwiki/lib` - plugins and related data.

**NOTE:** As of the current version, this container **does not support bind mounts** unless the container is run as root. By default it runs as a non-privileged user, which is is by design. Volumes are considered the preferred method or persisting data. For assistance on setting up volumes in Docker, [refer to the docker documentation on volumes](https://docs.docker.com/storage/volumes/ "refer to the docker documentation on volumes").

## How To Run

At its most basic, you can set up Dokuwiki from the Docker CLI like below:

``docker run -d --mount source=<CONF VOLUME>,target=/usr/share/dokuwiki/conf --mount source=<DATA VOLUME>,target=/usr/share/dokuwiki/data --mount source=<LIB VOLUME>,target=/usr/share/dokuwiki/lib -e PASSWORD=<YOUR PASSWORD> -p 8080:8080 thatsydneything/dokuwiki:latest``

A sample docker compose will be available in the future.

A kubernetes tutorial will be available in the future.

**Using plain text passwords in the Docker CLI (or any method for that matter) is not recommended - use secrets instead!**

## How To Contact

At the moment, you can raise any feedback or suggestions by raising an issue on this repo. I'd like to create a blog in future to handle engagement and tutorials etc, but I'm not sure if that'll be done via a standalone blog or via a service like Medium. Watch this space!

## Changelog

### 20220731a.0

- Initial release