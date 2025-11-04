

// Copyright 2018-present Network Optix, Inc. Licensed under MPL 2.0: www.mozilla.org/MPL/2.0/


## Abstract ##

This repository provides a production-ready containerized deployment solution for the application, complete with Docker configuration files and supporting automation scripts. The project is designed as a turnkey deployment package intended to be used as-is without modification.

## Deployment Standard ##
Docker Compose is the default and recommended deployment method for this application. All components, configurations, and dependencies have been carefully orchestrated through the included docker-compose.yaml file to ensure reliable and reproducible deployments across different environments.

## Quality Assurance ##
This containerized deployment configuration represents the official testing standard used by our QA team. All quality assurance processes, integration tests, and performance validations are conducted using this exact Docker Compose setup with the specified application version. This ensures that the deployment method you use in production mirrors the extensively tested configuration validated by our quality assurance protocols.

## Version Compliance ##
This deployment package is version-locked and tested specifically with the application version specified in the configuration files. Using this repository as-is ensures compatibility and stability as verified through our comprehensive QA process.

By utilizing this Docker Compose-based deployment, you benefit from a thoroughly tested, standardized installation that matches our official QA environment, minimizing deployment variations and ensuring consistent behavior across all instances.

## Restrictions ##

*  Only Debian Linux container is supported.
*  Linux hosts are supported.
*  MacOS hosts can be used but with limitations.
*  Windows hosts not tested

## Nx Server Docker container support conditions ##

*  Nx Server Docker container is an experimental feature.
*  It is not recommended for critical systems.
*  Please, test carefully that all features work in your environment before using it.
*  We do not guarantee support, but we need your feedback and will try to address discovered 
issues in future releases.
*  Any support provided implies experience and skills of Docker and containerized environment specifics.

## Pre-built image ##

The latest image is available at [Nx registry](https://harbor.nxvms.dev/harbor/projects/3/repositories/metavms-server/artifacts-tab?publicAndNotLogged=yes).


## Build ##

Building an image from current directory

Recommended way is to use [docker-compose >= 1.25](https://docs.docker.com/compose/) utility.
Follow [Installation guide](https://docs.docker.com/compose/install/).
Review [build environment configuration](.env). Build image:

```bash
docker-compose build
```

## Run ##

If a host is already running a VMS Server in the traditional way, port setting have to be different
for the container Server and the Server on a host. 

```bash
# Run as root or use sudo.
# Create /srv/mediaserver directory.
install -d /srv/mediaserver

# Copy the example volumes to /srv/mediaserver/ directory and set permissions - the directory has
# to be owned by a VMS Server user with UID & GID equal to 999.
cp -a config-volumes/* /srv/mediaserver
chown 999:999 -R /srv/mediaserver

# Run containers in the daemon mode.
docker-compose up -d
```

## Cleanup ##
```bash
# Stop services and remove containers.
docker-compose down

# Remove state volumes.
rm -rf /srv/mediaserver
```
## Storage ##

### Volumes description ###
The included docker-compose.yaml file provisions one storage location for the video. If more storage
locations are required, additional volumes should be provisioned to the container. These need to be
separate volumes on the host as well.
Volumes are required to configure the Sever and save its state data.

| Default source mount location | Description               | Container mount point             |
| ----------------------------- | ------------------------- | --------------------------------- |
| /srv/mediaserver/entrypoind.d | User init scripts         | /opt/mediaserver/entrypoint.d     |
| /srv/mediaserver/etc          | Configuration             | /opt/networkoptix/mediaserver/etc |
| /srv/mediaserver/nx_ini       | Additional configuration  | /home/${COMPANY}/.config/nx_ini   |
| /srv/mediaserver/recordings   | Video storage             | /recordings                       |
| /srv/mediaserver/var          | State and logs            | /opt/networkoptix/mediaserver/var |
| **TMPFS**                     | Unix socket and tmp files | /opt/networkoptix/mediaserver/tmp |

The default location of the volumes is specified at [environment file](.env).

### Storage fs types support ###
The Nx Media Server can operate with the following filesystems types:
* vfat
* ecryptfs
* fuseblk //NTFS
* fuse
* fusectl
* xfs
* ext3
* ext2
* ext4
* exfat
* rootfs
* nfs
* nfs4
* nfsd
* cifs
* fuse.osxfs

## Licenses considerations ##

Licenses are tied to Hardware ID (HWID). Changing one identifier (including MAC) causes the HWID to 
change. Under such conditions HWID can be accidentally invalidated by modifications to the Docker container.

For more details see:
https://support.networkoptix.com/hc/en-us/articles/360036141153-HWID-changed-and-license-is-no-longer-recording

There are several ways that changes to the network settings can cause the HWID to change and license to invalidate:

*  Switching container network mode from host to bridge;
*  Starting up containers in bridged mode causes them to choose sequential MAC addresses.  If 
containers are started in a different order after license keys are <code>ssigned</code>, their 
MAC address will change, also changing the HWID, and invalidating the licenses;
*  Deliberately changing the MAC address of a container;
*  Changes to internal IP of the container can cause the MAC address to change as well;
*  Moving the Docker image to another host.

Note: If the license has been invalidated, it can be reactivated up to 3 times by contacting 
support. For more details see https://support.networkoptix.com/hc/en-us/articles/360036141153-HWID-changed-and-license-is-no-longer-recording

## Software Updates ##

Both in-client and manual image updates will invalidate licenses.
If update is required, the new image should be built and deployed:
```bash
docker-compose down

# Update the version in the .env file.

docker-compose build
docker-compose up -d 
```