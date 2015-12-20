# proxy-pal
A simple proxy scraper and tester.

## Install
```bash
> bundler install
> cp config.example.yml config.yml
```

## Tests
```bash
> rspec
```

## Usage

Make sure that config.yml looks like the way you want it: add/remove proxy sources, change the numbers of threads or whatever and then...

```bash
> cd bin
> ./proxy-pal.sh
```