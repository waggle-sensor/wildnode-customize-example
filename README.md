# Wild Waggle Node Image Customization Example

This repository is an example (that can be forked) for how to customize the [wildnode-image](https://github.com/waggle-sensor/wildnode-image). The open-source [wildnode-image](https://github.com/waggle-sensor/wildnode-image) is an open platform and therefore has open credentials (for the `root` user) and is missing potential secrets needed for a production deployment. The tools provided here are a template for how to add customizations and secrets to build a secure [wildnode-image](https://github.com/waggle-sensor/wildnode-image).

> It is **highly recommended** that the entirity of this README is read before getting started.

## How it works?

The following steps are taken to create the customized [wildnode-image](https://github.com/waggle-sensor/wildnode-image) image:

1. The [wildnode-image](https://github.com/waggle-sensor/wildnode-image) code is cloned into a `./_workdir`
2. Any changes within the `ROOTFS` folder are synced "on top" of the [wildnode-image](https://github.com/waggle-sensor/wildnode-image) cloned code
3. Any (optional) additional file system modifications are made as defined within the `./build.sh` script
4. A "secret" version file is created within the cloned [wildnode-image](https://github.com/waggle-sensor/wildnode-image) file system to be included in the resulting build image
5. The [wildnode-image](https://github.com/waggle-sensor/wildnode-image) build script (i.e. `./_workdir/build.sh`) is executed, creating the customized [wildnode-image](https://github.com/waggle-sensor/wildnode-image) image

## Creating your custom [wildnode-image](https://github.com/waggle-sensor/wildnode-image) repository

In order to build your own custom [wildnode-image](https://github.com/waggle-sensor/wildnode-image) you will need to create your own GitHub project (ex. `wildnode-myproject`) to store your custom changes and build / store the built images. To create your own project the following steps need to be taken:

1. Create a new repository (within the [waggle-sensor](https://github.com/waggle-sensor) organization) using this repository as a template

    > You probably want to create your project as a "private" repository as it will contain your secrets to secure your customized image.

2. Execute the steps to setup your own (GitHub Self-Hosted Runner)[https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners]. See [Configuring your GitHub self-hosted runner](#configuring-your-github-self-hosted-runner) below.

    > This is necessary as the image build process requires more resources than are allowed in a standard GitHub runner. It is recommended to use an x86 Linux machine for this self-hosted runner.

Now that your GitHub project exists, you can start committing code changes to it that will modify the [wildnode-image](https://github.com/waggle-sensor/wildnode-image) file system.

> In fact, the first commit you should make is to modify the `./project_name` file from the default example project name to something more specific to your project. It is used in the naming of the resulting image file.

## Usage Instructions

When making custom changes and to secure your own [wildnode-image](https://github.com/waggle-sensor/wildnode-image) image the following steps needs to be taken:

1. Add file system customizations to the `ROOTFS` folder within this repository.

    Simply place a file into `ROOTFS` directory in the exact relative path you desire the file to appear in the resulting image. For example, if you want to create a the `/etc/waggle/demofile` in the resulting image you could do the following:

    ```bash
    mkdir -p ./ROOTFS/etc/waggle
    echo "demo file contents" > /etc/waggle/demofile
    ```

    > It is important to replace the `./ROOTFS/root/credentials` file contents with a secure password, as this will be the password of the `root` user in the resulting image. See [Creating the `root` user credentials](#creating-the-root-user-credentials) below.

2. Optionally, make modifications to the `./build.sh` script to change how the base [wildnode-image](https://github.com/waggle-sensor/wildnode-image) file system is modified

    > There is a "placeholder" section within the `./build.sh` script that is intended for more advanced file system customizations. See [Appending a base wildnode-image file example](#appending-a-base-wildnode-image-file-example) below.

3. Update the `./base_image_tag` file to indicate the base version of [wildnode-image](https://github.com/waggle-sensor/wildnode-image) that you want to use.

    ```bash
    $ cat ./base_image_tag
    v1.9.0
    ```

    > See the [wildnode-image tags](https://github.com/waggle-sensor/wildnode-image/tags) for a list of valid tags

4. Execute the `./build.sh` script to start the build process.

    ```bash
    ./build.sh <arguments>
    ```

    > See [wildnode-image build.sh](https://github.com/waggle-sensor/wildnode-image/blob/main/build.sh) script for details on build arguments

5. Extract the resulting image from the `./_workdir` folder.

    ```bash
    $ ls -la _workdir/*.tbz2
    -rw-r--r--  1 jswantek  staff  4004545457 Aug 29 16:53 _workdir/testbuild_mfi_nx-1.9.0-0-ga2a8c51.tbz2
    ```

## Creating a Release

After all the code changes have been made and you are happy with the changes, a "release image" can be created in GitHub.

TODO, talk about tagging an
TODO: need to figure out how to do this.. DO WE NEED TO REPLICATE THE .github ci? maybe?

## Advanced Details & Instructions

### Configuring your GitHub self-hosted runner

TODO
- how to create a build runner (self-hosted)

### Creating the `root` user credentials

The `root` credentials file (`/root/credentials`) is a [salted](https://en.wikipedia.org/wiki/Salt_(cryptography)) file used to set the `root` user password on the image. To set the contents of the file do the following:

```bash
echo "PASSWORD" | mkpasswd --stdin --method=sha-512
```

### Appending a base [wildnode-image](https://github.com/waggle-sensor/wildnode-image) file example

TODO

### Versioning your custom image

TODO - talk about how the version file is created

TODO 
- details the purpose of this

DONT tag this repo with a version as its mostly for documentation and we dont want to confuse tags with the open source tag repo
