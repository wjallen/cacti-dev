## Development assets for CACTI project

This repo is a work in progress.


#### Example commands for creating and updating systems:

```
$ tapis systems create -F tacc-stampede2-execution-system.json
$ tapis systems create -F tacc-work-storage-system.json
```

```
$ tapis systems update -F tacc-stampede2-execution-system.json  tacc.stampede2.wallen
$ tapis systems update -F tacc-work-storage-system.json  tacc.work.wallen
```

#### Example commands for initializing app directory:

```
$ tapis apps init --app-label wallen-dlscore --app-description "DLScore scoring function" --app-version 1.0 dlscore-app
```

#### Example commands for deploying / redeploying app

```
$ tapis apps deploy -W . --no-build --no-push
```


#### Example commands for sharing app

```
$ tapis apps pems grant dlscore_app-1.0 <someusername> ALL
```
