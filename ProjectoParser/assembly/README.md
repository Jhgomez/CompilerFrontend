## Description

Project 2 is a compiler, which is a type of compiler that creates native executables. The language compiles to 32-bit RISCV assembly, 
the lexical and syntax analyzer live inside the parser generated with peggyJs. The project follows [this](./Enunciado.pdf) specification,
The parser generates an AST, each node is then interpreted as specified in the documentation and we generate RISC-V instructions/code, 
the generated RISC-V code was then executed with a RISC-V simulator, during the development we used different simulators like 
[ripes](https://ripes.me/), [simriscv](https://simriscv.github.io/) and finally we ended up with [rars](https://github.com/TheThirdOne/rars),
ripes was a pretty nice tool due to the user interface it helped visualize/debug the memory usage better, while it was  little 
harder to visualize/debug the memory usage in rars, rars was prefered as it offers hints and descriptions of the risc-v instructions
and also supports floating point instructions/operations. During development we used documentation found in [projectf](https://projectf.io/),
in here you can see a reference to the compiler explorer which is a great tool also, for converting from decimal or text to and 
from HEX I used [this](https://www.rapidtables.com/convert/number/decimal-to-hex.html) calculator, I used this [documentation](https://msyksphinz-self.github.io/riscv-isadoc/html/rvfd.html#)
to get started with floating point instructions, I also learnt about "logical shift" also known as "bit shit" which can be a right 
or left shift, watch this [video](https://www.youtube.com/watch?v=-0FLvN7w3ZI) to learn more. I also learnt that there is at least 
two ways of representing a negative number in low level, we either can use the "IEEE 754" or "two's complement", the first is 
also used to represent floating point numbers. I was also able to understand better what is ASCII and UNICODE, both are
character encoding standards, this means both translate text to/from a decimal value using their own standard, UNICODE has different
implementations such as UTF-8, UTF-16 and UTF-32, each implementation is used in different use cases. In our case to store a
string I got each character UTF-16 decimal value and store them in an array and then store each in the heap as the heap is the dynamic
memory, while the stack is not usually too dynamic. So in the stack I only stored the address of where the first character of the 
string is located and then we know the string ends where we find the first 0 which indicates the end of line/end of string. A similar
process is done with floating point numbers, we take the floating point number and store it inside a JavaScript typed array, but I have
two types arrays working with the same buffer these two types array help mananing/handling binary data in JS and then convert it 
to a HEX string value wich is what risc-v can understand then store it like a decimal value but after that we can only interact
with it using floating point instructions. 

## Development environment set up

Set up is the same as described in the outer [READNE](../README.md)

## Generate Parser

Follow same instructions as described in the outer [READNE](../README.md)

## Run the app

Follow same instructions as described in the outer [READNE](../README.md)

## Notes

Same as in instructions described in the outer [READNE](../README.md)