# CToJS Compiler

This is a simple C to JavaScript compiler. It uses flex to generate a scanner. The scanner reads the input file and generates tokens.

## How to run

First, you need to install flex. You can do this by running the following command:

```
sudo apt install flex
```

Then, navigate to the appropriate folder (`./scanner`, `./parser/validator`, or `./parser/translator`) and compile the project by running the following command:
```
make
```

After that, you can run the compiler using one of the following commands, depending on the component:

```
./scanner ./test.c
```

or

```
./validator ./test.c
```

or

```
./translator ./test.c
``` 
