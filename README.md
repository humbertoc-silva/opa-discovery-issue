# opa-discovery-issue
Sample repository used to reproduce the OPA discovery issue when using signed non-discovery bundles.

# Instructions

## discovery-with-signed-bundle
The `discovery-with-signed-bundle` folder is used to build a discovery bundle with a config that points to a signed policy bundle.

The `build-discovery-with-signed-bundle.sh` script must be used to build a new discovery bundle and the `discovery-with-signed-bundle.tar.gz` result file must be moved to the folder `docker-compose/bundle-server/configuration`.

## discovery-with-unsigned-bundle
The `discovery-with-unsigned-bundle` folder is used to build a discovery bundle with a config that points to an unsigned policy bundle.

The `build-discovery-with-unsigned-bundle.sh` script must be used to build a new discovery bundle and the `discovery-with-unsigned-bundle.tar.gz` result file must be moved to the folder `docker-compose/bundle-server/configuration`.

## signed-policy-bundle
The `signed-policy-bundle` folder is used to build a signed policy bundle.

The `build-signed-policy-bundle.sh` script must be used to build a new policy bundle and the `signed-policy-bundle.tar.gz` result file must be moved to the folder `docker-compose/bundle-server/bundles`.

## unsigned-policy-bundle
The `unsigned-policy-bundle` folder is used to build an unsigned policy bundle.

The `build-unsigned-policy-bundle.sh` script must be used to build a new policy bundle and the `unsigned-policy-bundle.tar.gz` result file must be moved to the folder `docker-compose/bundle-server/bundles`.

## keys
The `keys` folder contains the RSA keys used to sign and validate the policy bundle.

## docker-compose
The `docker-compose` folder contains the necessary files to run the bundle server and OPA.

The folder `docker-compose/bundle-server/bundles` contais the policy bundles.
The folder `docker-compose/bundle-server/configuration` contains the discovery bundles.

The `docker-compose-up.sh` script must be used to start the containers. The script export an environment variable used to select the type of bundle:

```sh
export BUNDLE_TYPE=unsigned
```

```sh
export BUNDLE_TYPE=signed
```

The `BUNDLE_TYPE` environment variable is used on the command that starts the OPA container and determines which discovery bundle OPA will download.

## test.sh

The `test.sh` script is used to test OPA policy when the server starts successfully.

# Issue

When OPA is configured to load a discovery bundle with a config that points to a signed bundle the following error occurs:

```
{"addrs":[":8181"],"diagnostic-addrs":[":8282"],"level":"info","msg":"Initializing server.","time":"2022-05-03T15:29:21Z"}
{"level":"warning","msg":"OPA running with uid or gid 0. Running OPA with root privileges is not recommended. Use the -rootless image to avoid running with root privileges. This will be made the default in later OPA releases.","time":"2022-05-03T15:29:21Z"}
{"level":"debug","msg":"maxprocs: Leaving GOMAXPROCS=4: CPU quota undefined","time":"2022-05-03T15:29:21Z"}
{"level":"debug","msg":"Download starting.","time":"2022-05-03T15:29:21Z"}
{"headers":{"Prefer":["modes=snapshot,delta"],"User-Agent":["Open Policy Agent/0.40.0 (linux, amd64)"]},"level":"debug","method":"GET","msg":"Sending request.","time":"2022-05-03T15:29:21Z","url":"http://bundle_server/configuration/discovery-with-signed-bundle.tar.gz"}
{"level":"debug","msg":"Server initialized.","time":"2022-05-03T15:29:21Z"}
{"headers":{"Accept-Ranges":["bytes"],"Connection":["keep-alive"],"Content-Length":["669"],"Content-Type":["application/octet-stream"],"Date":["Tue, 03 May 2022 15:29:21 GMT"],"Etag":["\"62713cc4-29d\""],"Last-Modified":["Tue, 03 May 2022 14:31:32 GMT"],"Server":["nginx/1.21.6"]},"level":"debug","method":"GET","msg":"Received response.","status":"200 OK","time":"2022-05-03T15:29:21Z","url":"http://bundle_server/configuration/discovery-with-signed-bundle.tar.gz"}
{"level":"debug","msg":"Download in progress.","time":"2022-05-03T15:29:21Z"}
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0xe93380]

goroutine 50 [running]:
github.com/open-policy-agent/opa/plugins/discovery.(*Discovery).processBundle(0xc0000f7d80, {0x1fb0800?, 0xc00007e000?}, 0xc00042b6b8?)
        /src/plugins/discovery/discovery.go:294 +0x5e0
github.com/open-policy-agent/opa/plugins/discovery.(*Discovery).reconfigure(0x0?, {0x1fb0800, 0xc00007e000}, {{0xc000370051, 0xe}, 0xc0001c02d0, {0x0, 0x0}, {0x1fb48e8, 0xc000400020}, ...})
        /src/plugins/discovery/discovery.go:239 +0x32
github.com/open-policy-agent/opa/plugins/discovery.(*Discovery).processUpdate(0xc0000f7d80, {0x1fb0800, 0xc00007e000}, {{0xc000370051, 0xe}, 0xc0001c02d0, {0x0, 0x0}, {0x1fb48e8, 0xc000400020}, ...})
        /src/plugins/discovery/discovery.go:206 +0x173
github.com/open-policy-agent/opa/plugins/discovery.(*Discovery).oneShot(0xc0000f7d80, {0x1fb0800?, 0xc00007e000?}, {{0xc000370051, 0xe}, 0xc0001c02d0, {0x0, 0x0}, {0x1fb48e8, 0xc000400020}, ...})
        /src/plugins/discovery/discovery.go:176 +0x9d
github.com/open-policy-agent/opa/download.(*Downloader).oneShot(0xc000174600, {0x1fb0800, 0xc00007e000})
        /src/download/download.go:255 +0x302
github.com/open-policy-agent/opa/download.(*Downloader).loop(0xc000174600, {0x1fb0800, 0xc00007e000})
        /src/download/download.go:203 +0xd2
created by github.com/open-policy-agent/opa/download.(*Downloader).doStart
        /src/download/download.go:167 +0xca
```