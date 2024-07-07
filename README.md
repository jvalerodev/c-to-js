# CppToJS Compiler

This is a simple C++ to JavaScript compiler. It uses flex to generate a scanner. The scanner reads the input file and generates tokens.

## How to run

First, you need to install flex. You can do this by running the following command:

```
sudo apt install flex
```

Then, you can compile the project by running the following command:

```
make
```

After that, you can run the compiler by running the following command:

```
./scanner ./test.c
```
