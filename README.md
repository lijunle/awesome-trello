# Awesome Trello

[![Build Status](https://travis-ci.org/lijunle/awesome-trello.svg?branch=master)](https://travis-ci.org/lijunle/awesome-trello)

Some awesome Trello utilities.

## Development

Clone this repo:

```sh
git clone https://github.com/lijunle/awesome-trello.git
```

Install the dependencies:

```sh
cd awesome-trello
npm install
dotnet restore
```

Easy development in watch mode. Open two terminals. One for:

```sh
cd Awesome.Trello.Pages
node elm-watch.js
```

Another one for:

```sh
cd Awesome.Trello
dotnet watch run
```

## Deployment

The Travis CI is set up for deployment. See the [config file](https://github.com/lijunle/awesome-trello/blob/master/.travis.yml) for more details.

All commits pushed to master will be deployed if the build succeed.

## License

MIT License.
