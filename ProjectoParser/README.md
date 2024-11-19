## Description

Project 1 is a making an interpreter, which is a type of compiler, the project follows [this](./Enunciado.pdf) specification,
this language generates an AST, each node is then interpreted as specified in the documentation, using javascript, the generated
javascript code is then executed on the javascript engine from the browser. In this case javascript could represent what in 
Java is known as bytecode which is some sort of intermediate representation

## Development environment set up

1. Install `node`, to do this I used `nvm`, there is other ways to install `node` anyways. I 
installed `nvm 1.1.12` and used it to install `node v22.5.1`.


2. Make sure `npx` is installed. `npm`, the node package manager, will also be installed; I installed version `10.8.3`. According
to some info `npx`, which is know as the node package runner, will also be installed along `npm` from `npm@5.2.0`
so make sure it is installed with `npx --version` or `where npx`, both commands will only work if
`nodejs` has been added to the environment variable called `path`, this variable specifies a set of 
directories where executable programs are located. `npx` should be installed in the nodejs directory, at least in
windows, so you can check if the executable exists different ways, using the commands above, again make
sure nodejs is already in the `path` or go check in nodejs folder, in windows is inside `program files`. if not installed
just run `npm install -g npx`. `npx` allows us to run node packages without having to download them locally, in
this project we do this since that was a restriction, however this means you could also declare local dependencies, you'd
initiate a file to declare dependencies with `npm init` and define the package we are interested in, in this case it is
**`peggy`**, running it with `npx` means `peggy` is a development only dependency

## Generate Parser

1. Generate the parser from your grammar using peggy, there is different ways to do this. You could
run from the command line directly with `npx peggy ./oakland.pegjs --format=es --dependencies '{"nodes": "./nodes.js"}'`, 
if you get an error try changing peggy version `npx peggy@<version> ./oakland.pegjs --format=es --dependencies '{"nodes": "./nodes.js"}'`,
if you get an error make sure the paths to the `oakland.pegjs` and `nodes.js` files are set correctly. The other options is
to define the arguments in a javascript file like we did in `config.js` then just execute `npx peggy -c ./config.js`, troubleshooting
is the same, check path of `config.js` file and/or try other version of `peggy`. The other option is to generate the parser from peggy's
website, however you can not declare a dependecy like we did before and all the javascript code your parser depends on has
to be declared inside the same `.pegjs` file, javascript code can be declare inside brackets and then in  "Parser variable For CommonJS" enter "Window.peg", download
the ES6 module, ES6 is the new module system.

## Run the app

1. To run the app you should just need to run it from a server, this is a requirement from peggy if its run in this type of setup.
Check the reason in this [documentation](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Tools_and_setup/set_up_a_local_testing_server#the_problem_with_testing_local_files), 
in this case is because of "They include other files" section. In the same documentation you can see two options to run a server locally
either with `nodejs` or `python`, in our case we used `live server` extension in "VS Code".

## Notes

In our UI we used `ACE` which is a standalone code editor written in JavaScript, we injected it using JSDeliver which is a CDN.
To learn more about how CDNs work look [here](https://www.freecodecamp.org/news/import-javascript-and-css-from-a-public-cdn/),
or search "How to Import JavaScript and CSS from a Public CDN", we did it in one line in our JavaScript script with `import * as aceEditor from 'https://cdn.jsdelivr.net/npm/ace-builds@1.36.2/+esm'`
