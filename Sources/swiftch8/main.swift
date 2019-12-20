import Glibc

var rom = [UInt16](repeating: 0xFFFF, count: 0xE00)
let rom_file = fopen("./brix.ch8", "r")
func get_NNN(_ opcode: UInt16) -> String {
    return String(opcode & 0x0FFF, radix: 16)
}
func get_N(_ opcode: UInt16) -> String {
    return String(opcode & 0x000F, radix: 16)
}
func get_Y(_ opcode: UInt16) -> String {
    return String((opcode & 0x00F0) >> 4, radix: 16)
}
func get_X(_ opcode: UInt16) -> String {
    return String((opcode & 0x0F00) >> 8, radix: 16)
}
func get_KK(_ opcode: UInt16) -> String {
    return String(opcode & 0x00FF, radix: 16)
}
if rom_file != nil {
	fread(&rom, MemoryLayout<UInt8>.size, 0xE00, rom_file)
    fclose(rom_file)
}

for opcode_uint16 in rom {
    let opcode = opcode_uint16.bigEndian

    let opcode_tuple = (
        (opcode & 0xF000) >> 12,
        (opcode & 0x0F00) >>  8,
        (opcode & 0x00F0) >>  4,
         opcode & 0x000F
    )

    switch opcode_tuple {
        case (0x0, 0x0, 0xE, 0x0): do {
            print( "CLS" )
        }
        case (0x0, 0x0, 0xE, 0xE): do {
            print( "RET" )
        }
        case (0x1, _, _, _): do {
            print( "JP", "0x" + get_NNN(opcode) )
        }
        case (0x2, _, _, _): do {
            print( "CALL", "0x" + get_NNN(opcode) )
        }
        case (0x3, _, _, _): do {
            print("SE", "V" + get_X(opcode) + "," , "0x" + get_KK(opcode))
        }
        case (0x4, _, _, _): do {
            print("SNE", "V" + get_X(opcode) + "," , "0x" + get_KK(opcode))
        }
        case (0x5, _, _, 0): do {
            print("SE", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x6, _, _, _): do {
            print("LD", "V" + get_X(opcode) + "," , "0x" + get_KK(opcode))
        }
        case (0x7, _, _, _): do {
            print("ADD", "V" + get_X(opcode) + "," , "0x" + get_KK(opcode))
        }
        case (0x8, _, _, 0): do {
            print("LD", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x8, _, _, 1): do {
            print("OR", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x8, _, _, 2): do {
            print("AND", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x8, _, _, 3): do {
            print("XOR", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x8, _, _, 4): do {
            print("ADD", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x8, _, _, 5): do {
            print("SUB", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x8, _, _, 6): do {
            print("SHR", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x8, _, _, 7): do {
            print("SUBN", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x8, _, _, 0xE): do {
            print("SHL", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0x9, _, _, 0): do {
            print("SNE", "V" + get_X(opcode) + "," , "V" + get_Y(opcode))
        }
        case (0xA, _, _, _): do {
            print("LD I,", "0x" + get_NNN(opcode))
        }
        case (0xB, _, _, _): do {
            print("JP V0,", "0x" + get_NNN(opcode))
        }
        case (0xC, _, _, _): do {
            print("RND", "V" + get_X(opcode) + "," , "0x" + get_KK(opcode))
        }
        case (0xD, _, _, _): do {
            print("DRW", "V" + get_X(opcode) + "," , "V" + get_Y(opcode), "0x" + get_N(opcode))
        }
        case (0xE, _, 9, 0xE): do {
            print("SKP", "V" + get_X(opcode))
        }
        case (0xE, _, 0xA, 0x1): do {
            print("SKNP", "V" + get_X(opcode))
        }
        case (0xF, _, 0x0, 0x7): do {
            print("LD", "V" + get_X(opcode) + ",", "DT")
        }
        case (0xF, _, 0x0, 0xA): do {
            print("LD", "V" + get_X(opcode) + ",", "K")
        }
        case (0xF, _, 0x1, 0x5): do {
            print("LD", "DT,", "V" + get_X(opcode))
        }
        case (0xF, _, 0x1, 0x8): do {
            print("LD", "ST,", "V" + get_X(opcode))
        }
        case (0xF, _, 0x1, 0xE): do {
            print("ADD", "I,", "V" +  get_X(opcode))
        }
        case (0xF, _, 0x2, 0x9): do {
            print("LD", "F,", "V" +  get_X(opcode))
        }
        case (0xF, _, 0x3, 0x3): do {
            print("LD", "B,", "V" +  get_X(opcode))
        }
        case (0xF, _, 0x5, 0x5): do {
            print("LD", "[I], ", "V" +  get_X(opcode))
        }
        case (0xF, _, 0x6, 0x5): do {
            print("LD", "V" +  get_X(opcode) + ",", "[I]")
        }
        default: do {
            print(  "(invalid) ---", 
                    String(opcode, radix: 16),
                    opcode_tuple
                )       
        }
    }

}