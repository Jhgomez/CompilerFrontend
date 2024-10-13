import { ObjectsRecord } from "./objectsinmemory.js"
import { registers as R } from "./registers.js"
import { breakStringIntoCharUnicodeArray } from "./utils.js" 

class Instruction {
    constructor (instruction, rd, rs1, rs2) {
        this.instruction = instruction
        this.rd = rd
        this.rs1 = rs1
        this.rs2 = rs2
    }

    toString() {
        const operands = []
        if (this.rd != undefined) operands.push(this.rd)
        if (this.rs1 != undefined) operands.push(this.rs1)
        if (this.rs2 != undefined) operands.push(this.rs2)
        return `${this.instruction} ${operands.join(", ")}`
    }
}

export class OakGenerator {

    constructor() {
        this.instructions = []
        this.stackMimic = new ObjectsRecord()
    }

    // Aritmethic instructions

    add(rd, s1, s2) {
        this.instructions.push(new Instruction('add', rd, s1, s2))
    }

    sub(rd, s1, s2) {
        this.instructions.push(new Instruction('sub', rd, s1, s2))
    }

    mul(rd, s1, s2) {
        this.instructions.push(new Instruction('mul', rd, s1, s2))
    }

    div(rd, s1, s2) {
        this.instructions.push(new Instruction('div', rd, s1, s2))
    }

    // modulus operator
    rem(rd, s1, s2) {
        this.instructions.push(new Instruction('rem', rd, s1, s2))
    }

    addi(rd, s1, immediate) {
        this.instructions.push(new Instruction('addi', rd, s1, immediate))
    }

    li(rd, value) {
        this.instructions.push(new Instruction('li', rd, value))
    }

    // stores rs1 value in rs2 memory address, means rs2 has to be an address in memory like an address to a variable
    // loaded into a temp or the SP
    sw(rs1, rs2, index = 0) {
        this.instructions.push(new Instruction('sw', rs1, `${index}(${rs2})`))
    }

    // stores first byte only of rs1 value inside rs2 memory address, means rs2 has to be an address in memory like an address to a variable
    // loaded into a temp or the SP
    sb(rs1, rs2, index = 0) {
        this.instructions.push(new Instruction('sb', rs1, `${index}(${rs2})`))
    }

    // saves rs1 value in memory into rd but rs1 has to be an address like a global varialbe address loaded into a temp or 
    // the SP, if we pass a global variable name it will work like a pseudo instruction in the sense that it will do a "la"
    // but in this case, meaning in our generator, this instuction only covers the scenario where the rs1 is a loaded address
    lw(rd, rs1, index = 0) {
        this.instructions.push(new Instruction('lw', rd, `${index}(${rs1})` ))
    }

    // saves the first byte only of rs1 value in memory into rd but rs1 has to be an address like a global varialbe address loaded in to a temp or 
    // the SP
    lb(rd, rs1, index = 0) {
        this.instructions.push(new Instruction('lb', rd, `${index}(${rs1})` ))
    }

    pushToStack(rd) {
        // stack grows to the the bottom, meaning if you want to point to a new address direction in the stack
        // you have to take off 4 bytes since each direction has 4 bytes. Every 4 bytes is a new address
        this.addi(R.SP, R.SP, -4)
        // store the value in rs1 in new address the stack pointer is pointing to
        this.sw(rd, R.SP)
    }

    // Numbers are pushed to stack
    // Strings are pushed to heap and the address where they start in heap is stored in stack so they can be retreived
    pushLiteral(literal) {
        switch(literal.type) {
            case 'string':
                // we are saving string in heap here

                // save heap address where the string will start in the stack
                this.pushToStack(R.HP)

                // this breaks the string into chars and they each char is represented in its unicode form
                const stringCharsUnicodeRepresentation = breakStringIntoCharUnicodeArray(literal.value)

                stringCharsUnicodeRepresentation.forEach( charBits => {
                    // load char bits integer representation into t1
                    this.li(R.T0, charBits)
                    // store the byte into the heap address
                    this.sb(R.T0, R.HP)
                    // point to a "new" available byte memory in heap
                    this.addi(R.HP, R.HP, 1)
                });

                // it could change but right now length indicates the pointer address
                // in the stack which is how we locate this string in the heap, and the dynamic lenght indicates
                // the number or bytes, each character is a byte in the heap
                this.stackMimic.pushObject(undefined, 4, literal.value.length, literal.type)
                break
            case 'int':
                // stack grows to the the bottom, meaning if you want to point to a new address direction in the stack
                // you have to take off 4 bytes since each address/register has 4 bytes. Every 4 bytes is a new address
                this.addi(R.SP, R.SP, -4)

                // load value into t1
                this.li(R.T1, literal.value)
                // store the value in rs1 in new address the stack pointer is pointing to
                this.sw(R.T1, R.SP)

                this.stackMimic.pushObject(undefined, 4, undefined, literal.type)
                break
        }
    }

    // this method saves the value of "static" literals(like char, int, bool) or the address in memory where
    // the value is stored, if the object being retrieved is a dynamic size type(like array, string or structs), into rd
    // registry but also returns the object which lives in the stack mimic list which contains the object info, bare in mind
    // that the info available is different for just pure literals or other types like objects or arrays
    popObject(rd, id) {
        this.lw(rd, R.SP)
        // move the stack pointer one position before the last value we just "poped" into rd
        this.add(R.SP, R.SP, 4)

        return this.stackMimic.popObject(id)
    }

    comment(comment) {
        this.instructions.push(new Instruction(`# ${comment}`))   
    }

    generateAssemblyCode() {
        // create heap, heap is just a way to see/order the memory increasing it with positive number
        // on the other hand stack increases with negative numbers
        const heapDcl = '\n.data\nheap: .word 0\n'

        const heapInit = `\n.text\n#initializing heap\nla ${R.HP}, heap\n`

        const main = 'main:\n'

        const instructions = this.instructions.map(instruction => instruction.toString()).join('\n')

        return `${heapDcl}${heapInit}${main}${instructions}`
    }
}