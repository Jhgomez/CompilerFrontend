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
with it using floating point instructions. The idea to be able to manage memory is keep a "stack" which
is some sort or record stored inside a collection of objects in memory, each record has the info about the object that the value in memory represents, like the type, subtype, level(scope), etc. arrays and methods are the closest thing, in this project, that I built that has the idea of how a class should be
represented or stored, I mean we have to define where the properties and values will be stored, for example and array is just and address in the heap that is stored in the stack, this address points to the first item of the array, however at the time I create an array I always store the lenght of the array as some sort of property in the previous position(4 bytes before) in memory, right before the firtst item of the array, 
to be able to read info without messing the stack or heap the pointers are always pointing to the top either of the stack or the heap, the stack pointer is provided by the framework but the heap pointer is just a variable I created that holds the value of an empty/available space in memory right after the last
value that was stored in the heap, the stack pointer behaves differently because "I set it up" this way and that is that the stack pointer is always pointing to the latest value added to the stack, so in order to move for example through an array I create temporary pointers, that means I retrieve the array address which is a heap address stored in the stack and copy it into a register and then start moving it, this helps avoid overwriting data in the stack and/or heap. The Functions behave like the following, first thing we do when 
compiling a function is move the generated code to another "buffer", then leave a space in the stack and the mimic to store the the 
return address and then create the variables that represent the parameters either with an empty space for each or a randon/default value, however be aware a value is always added to the to the mimic of the stack, which again is a collection, then we execute the code just to
generate the instructions that live inside the function, the instrucctions genreated by a function declaration will be written once only
when a function call is found first thing is write the return address and then write the value to each parameter, then we jump and link to
and the function is executed. and return when it is finished

check the entries file to test application.

## Development environment set up

Set up is the same as described in the outer [READNE](../README.md)

## Generate Parser

Follow same instructions as described in the outer [READNE](../README.md)

## Run the app

Follow same instructions as described in the outer [READNE](../README.md)

## Notes

Same as in instructions described in the outer [READNE](../README.md)