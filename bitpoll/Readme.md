[Bitpoll](https://github.com/fsinfuhh/Bitpoll) is a software to conduct polls about Dates, Times or general Questions.

The Dockerfile contains a Bitpoll installation.

Download [settings_local.py](https://raw.githubusercontent.com/fsinfuhh/Bitpoll/master/bitpoll/settings_local.sample.py) and adjust the settings. An working example can be found [here](https://github.com/Chessmasterrr/docker/tree/master/bitpoll/settings_local.py).

Run the image with:

```bash
docker run -p 8000:8000 -v /path/on/host/settings_local.py:/Bitpoll/bitpoll/settings_local.py -v /path/on/host/database/:/Bitpoll/database/ -d chessmasterrr/bitpoll:latest
```

On the first run, initialise the database by running (this will delete existing data!):

```bash
docker exec <containerID> ./manage.py migrate
```
