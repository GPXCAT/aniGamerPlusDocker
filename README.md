Build Image
```bash
docker-compose build --no-cache
```

Run With Docker-Compose
```bash
docker-compose up -d
```

Init config.json
```bash
wget https://raw.githubusercontent.com/miyouzi/aniGamerPlus/master/config-sample.json -O config.json
sed -i 's/127.0.0.1/0.0.0.0/g' config.json
```

Init aniGamer.db
```bash
touch aniGamer.db
```

Init cookie.txt
```bash
touch cookie.txt
```
