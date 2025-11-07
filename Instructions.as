// https://github.com/rockytriton/LLD_gbemu/
enum AddressMode 
{
    AM_IMP,
    AM_R_D16,
    AM_R_R,
    AM_MR_R,
    AM_R,
    AM_R_D8,
    AM_R_MR,
    AM_R_HLI,
    AM_R_HLD,
    AM_HLI_R,
    AM_HLD_R,
    AM_R_A8,
    AM_A8_R,
    AM_HL_SPR,
    AM_D16,
    AM_D8,
    AM_D16_R,
    AM_MR_D8,
    AM_MR,
    AM_A16_R,
    AM_R_A16
}

enum RegisterType 
{
    RT_NONE,
    RT_A,
    RT_F,
    RT_B,
    RT_C,
    RT_D,
    RT_E,
    RT_H,
    RT_L,
    RT_AF,
    RT_BC,
    RT_DE,
    RT_HL,
    RT_SP,
    RT_PC
}

enum InstructionType 
{
    IN_NONE,
    IN_NOP,
    IN_LD,
    IN_INC,
    IN_DEC,
    IN_RLCA,
    IN_ADD,
    IN_RRCA,
    IN_STOP,
    IN_RLA,
    IN_JR,
    IN_RRA,
    IN_DAA,
    IN_CPL,
    IN_SCF,
    IN_CCF,
    IN_HALT,
    IN_ADC,
    IN_SUB,
    IN_SBC,
    IN_AND,
    IN_XOR,
    IN_OR,
    IN_CP,
    IN_POP,
    IN_JP,
    IN_PUSH,
    IN_RET,
    IN_CB,
    IN_CALL,
    IN_RETI,
    IN_LDH,
    IN_JPHL,
    IN_DI,
    IN_EI,
    IN_RST,
    IN_ERR,
    //CB instructions...
    IN_RLC, 
    IN_RRC,
    IN_RL, 
    IN_RR,
    IN_SLA, 
    IN_SRA,
    IN_SWAP, 
    IN_SRL,
    IN_BIT, 
    IN_RES, 
    IN_SET
}

enum ConditionType 
{
    CT_NONE, 
    CT_NZ, 
    CT_Z, 
    CT_NC, 
    CT_C
}

class Instruction 
{
    InstructionType Inst = InstructionType::IN_NOP;
    AddressMode AddrMode = AddressMode::AM_IMP;
    RegisterType Register1 = RegisterType::RT_NONE;
    RegisterType Register2 = RegisterType::RT_NONE;
    ConditionType Condition = ConditionType::CT_NONE;
    uint8 Parameter = 0;
    bool Valid = false;

    Instruction(uint8 iParameter,
                InstructionType iInst = InstructionType::IN_NOP, 
                AddressMode iAddrMode = AddressMode::AM_IMP,
                RegisterType iRegister1 = RegisterType::RT_NONE,
                RegisterType iRegister2 = RegisterType::RT_NONE,
                ConditionType iCondition = ConditionType::CT_NONE)
    {
        Inst = iInst;
        AddrMode = iAddrMode;
        Register1 = iRegister1;
        Register2 = iRegister2;
        Condition = iCondition;
        Parameter = iParameter;
        Valid = true;
    }

    Instruction() {}
}

array<Instruction> InitInstructions()
{
    array<Instruction> Instructions;
    for (uint16 OpCode = 0; OpCode <= 255; OpCode++)
    {
        switch (OpCode)
        {
            case 0x00: Instructions.add(Instruction(0, InstructionType::IN_NOP, AddressMode::AM_IMP)); break;
            case 0x01: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D16, RegisterType::RT_BC)); break;
            case 0x02: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R, RegisterType::RT_BC, RegisterType::RT_A)); break;
            case 0x03: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_BC)); break;
            case 0x04: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_B)); break;
            case 0x05: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_B)); break;
            case 0x06: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D8, RegisterType::RT_B)); break;
            case 0x07: Instructions.add(Instruction(0, InstructionType::IN_RLCA)); break;
            case 0x08: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_A16_R, RegisterType::RT_NONE, RegisterType::RT_SP)); break;
            case 0x09: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_HL, RegisterType::RT_BC)); break;
            case 0x0A: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_BC)); break;
            case 0x0B: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_BC)); break;
            case 0x0C: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_C)); break;
            case 0x0D: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_C)); break;
            case 0x0E: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D8, RegisterType::RT_C)); break;
            case 0x0F: Instructions.add(Instruction(0, InstructionType::IN_RRCA)); break;

            case 0x10: Instructions.add(Instruction(0, InstructionType::IN_STOP)); break;
            case 0x11: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D16, RegisterType::RT_DE)); break;
            case 0x12: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R, RegisterType::RT_DE, RegisterType::RT_A)); break;
            case 0x13: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_DE)); break;
            case 0x14: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_D)); break;
            case 0x15: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_D)); break;
            case 0x16: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D8, RegisterType::RT_D)); break;
            case 0x17: Instructions.add(Instruction(0, InstructionType::IN_RLA)); break;
            case 0x18: Instructions.add(Instruction(0, InstructionType::IN_JR, AddressMode::AM_D8)); break;
            case 0x19: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_HL, RegisterType::RT_DE)); break;
            case 0x1A: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_DE)); break;
            case 0x1B: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_DE)); break;
            case 0x1C: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_E)); break;
            case 0x1D: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_E)); break;
            case 0x1E: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D8, RegisterType::RT_E)); break;
            case 0x1F: Instructions.add(Instruction(0, InstructionType::IN_RRA)); break;

            case 0x20: Instructions.add(Instruction(0, InstructionType::IN_JR, AddressMode::AM_D8, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NZ)); break;
            case 0x21: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D16, RegisterType::RT_HL)); break;
            case 0x22: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_HLI_R, RegisterType::RT_HL, RegisterType::RT_A)); break;
            case 0x23: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_HL)); break;
            case 0x24: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_H)); break;
            case 0x25: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_H)); break;
            case 0x26: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D8, RegisterType::RT_H)); break;
            case 0x27: Instructions.add(Instruction(0, InstructionType::IN_DAA)); break;
            case 0x28: Instructions.add(Instruction(0, InstructionType::IN_JR, AddressMode::AM_D8, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_Z)); break;
            case 0x29: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_HL, RegisterType::RT_HL)); break;
            case 0x2A: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_HLI, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0x2B: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_HL)); break;
            case 0x2C: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_L)); break;
            case 0x2D: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_L)); break;
            case 0x2E: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D8, RegisterType::RT_L)); break;
            case 0x2F: Instructions.add(Instruction(0, InstructionType::IN_CPL)); break;

            case 0x30: Instructions.add(Instruction(0, InstructionType::IN_JR, AddressMode::AM_D8, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NC)); break;
            case 0x31: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D16, RegisterType::RT_SP)); break;
            case 0x32: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_HLD_R, RegisterType::RT_HL, RegisterType::RT_A)); break;
            case 0x33: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_SP)); break;
            case 0x34: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_MR, RegisterType::RT_HL)); break;
            case 0x35: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_MR, RegisterType::RT_HL)); break;
            case 0x36: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_D8, RegisterType::RT_HL)); break;
            case 0x37: Instructions.add(Instruction(0, InstructionType::IN_SCF)); break;
            case 0x38: Instructions.add(Instruction(0, InstructionType::IN_JR, AddressMode::AM_D8, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_C)); break;
            case 0x39: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_HL, RegisterType::RT_SP)); break;
            case 0x3A: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_HLD, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0x3B: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_SP)); break;
            case 0x3C: Instructions.add(Instruction(0, InstructionType::IN_INC, AddressMode::AM_R, RegisterType::RT_A)); break;
            case 0x3D: Instructions.add(Instruction(0, InstructionType::IN_DEC, AddressMode::AM_R, RegisterType::RT_A)); break;
            case 0x3E: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0x3F: Instructions.add(Instruction(0, InstructionType::IN_CCF)); break;

            case 0x40: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_B, RegisterType::RT_B)); break;
            case 0x41: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_B, RegisterType::RT_C)); break;
            case 0x42: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_B, RegisterType::RT_D)); break;
            case 0x43: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_B, RegisterType::RT_E)); break;
            case 0x44: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_B, RegisterType::RT_H)); break;
            case 0x45: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_B, RegisterType::RT_L)); break;
            case 0x46: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_B, RegisterType::RT_HL)); break;
            case 0x47: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_B, RegisterType::RT_A)); break;
            case 0x48: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_C, RegisterType::RT_B)); break;
            case 0x49: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_C, RegisterType::RT_C)); break;
            case 0x4A: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_C, RegisterType::RT_D)); break;
            case 0x4B: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_C, RegisterType::RT_E)); break;
            case 0x4C: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_C, RegisterType::RT_H)); break;
            case 0x4D: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_C, RegisterType::RT_L)); break;
            case 0x4E: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_C, RegisterType::RT_HL)); break;
            case 0x4F: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_C, RegisterType::RT_A)); break;

            case 0x50: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_D, RegisterType::RT_B)); break;
            case 0x51: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_D, RegisterType::RT_C)); break;
            case 0x52: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_D, RegisterType::RT_D)); break;
            case 0x53: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_D, RegisterType::RT_E)); break;
            case 0x54: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_D, RegisterType::RT_H)); break;
            case 0x55: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_D, RegisterType::RT_L)); break;
            case 0x56: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_D, RegisterType::RT_HL)); break;
            case 0x57: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_D, RegisterType::RT_A)); break;
            case 0x58: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_E, RegisterType::RT_B)); break;
            case 0x59: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_E, RegisterType::RT_C)); break;
            case 0x5A: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_E, RegisterType::RT_D)); break;
            case 0x5B: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_E, RegisterType::RT_E)); break;
            case 0x5C: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_E, RegisterType::RT_H)); break;
            case 0x5D: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_E, RegisterType::RT_L)); break;
            case 0x5E: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_E, RegisterType::RT_HL)); break;
            case 0x5F: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_E, RegisterType::RT_A)); break;

            case 0x60: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_H, RegisterType::RT_B)); break;
            case 0x61: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_H, RegisterType::RT_C)); break;
            case 0x62: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_H, RegisterType::RT_D)); break;
            case 0x63: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_H, RegisterType::RT_E)); break;
            case 0x64: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_H, RegisterType::RT_H)); break;
            case 0x65: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_H, RegisterType::RT_L)); break;
            case 0x66: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_H, RegisterType::RT_HL)); break;
            case 0x67: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_H, RegisterType::RT_A)); break;
            case 0x68: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_L, RegisterType::RT_B)); break;
            case 0x69: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_L, RegisterType::RT_C)); break;
            case 0x6A: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_L, RegisterType::RT_D)); break;
            case 0x6B: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_L, RegisterType::RT_E)); break;
            case 0x6C: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_L, RegisterType::RT_H)); break;
            case 0x6D: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_L, RegisterType::RT_L)); break;
            case 0x6E: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_L, RegisterType::RT_HL)); break;
            case 0x6F: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_L, RegisterType::RT_A)); break;

            case 0x70: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R,  RegisterType::RT_HL, RegisterType::RT_B)); break;
            case 0x71: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R,  RegisterType::RT_HL, RegisterType::RT_C)); break;
            case 0x72: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R,  RegisterType::RT_HL, RegisterType::RT_D)); break;
            case 0x73: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R,  RegisterType::RT_HL, RegisterType::RT_E)); break;
            case 0x74: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R,  RegisterType::RT_HL, RegisterType::RT_H)); break;
            case 0x75: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R,  RegisterType::RT_HL, RegisterType::RT_L)); break;
            case 0x76: Instructions.add(Instruction(0, InstructionType::IN_HALT)); break;
            case 0x77: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R,  RegisterType::RT_HL, RegisterType::RT_A)); break;
            case 0x78: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0x79: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0x7A: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0x7B: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0x7C: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0x7D: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0x7E: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0x7F: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R,  RegisterType::RT_A, RegisterType::RT_A)); break;

            case 0x80: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0x81: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0x82: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0x83: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0x84: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0x85: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0x86: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0x87: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_A)); break;
            case 0x88: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0x89: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0x8A: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0x8B: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0x8C: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0x8D: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0x8E: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0x8F: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_A)); break;

            case 0x90: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0x91: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0x92: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0x93: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0x94: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0x95: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0x96: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0x97: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_A)); break;
            case 0x98: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0x99: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0x9A: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0x9B: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0x9C: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0x9D: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0x9E: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0x9F: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_A)); break;

            case 0xA0: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0xA1: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0xA2: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0xA3: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0xA4: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0xA5: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0xA6: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0xA7: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_A)); break;
            case 0xA8: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0xA9: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0xAA: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0xAB: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0xAC: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0xAD: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0xAE: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0xAF: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_A)); break;

            case 0xB0: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0xB1: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0xB2: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0xB3: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0xB4: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0xB5: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0xB6: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0xB7: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_A)); break;
            case 0xB8: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_B)); break;
            case 0xB9: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0xBA: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_D)); break;
            case 0xBB: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_E)); break;
            case 0xBC: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_H)); break;
            case 0xBD: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_L)); break;
            case 0xBE: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_HL)); break;
            case 0xBF: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_R, RegisterType::RT_A, RegisterType::RT_A)); break;

            case 0xC0: Instructions.add(Instruction(0, InstructionType::IN_RET, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NZ)); break;
            case 0xC1: Instructions.add(Instruction(0, InstructionType::IN_POP, AddressMode::AM_R, RegisterType::RT_BC)); break;
            case 0xC2: Instructions.add(Instruction(0, InstructionType::IN_JP, AddressMode::AM_D16, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NZ)); break;
            case 0xC3: Instructions.add(Instruction(0, InstructionType::IN_JP, AddressMode::AM_D16)); break;
            case 0xC4: Instructions.add(Instruction(0, InstructionType::IN_CALL, AddressMode::AM_D16, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NZ)); break;
            case 0xC5: Instructions.add(Instruction(0, InstructionType::IN_PUSH, AddressMode::AM_R, RegisterType::RT_BC)); break;
            case 0xC6: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0xC7: Instructions.add(Instruction(0, InstructionType::IN_RST, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NONE)); break;
            case 0xC8: Instructions.add(Instruction(0, InstructionType::IN_RET, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_Z)); break;
            case 0xC9: Instructions.add(Instruction(0, InstructionType::IN_RET)); break;
            case 0xCA: Instructions.add(Instruction(0, InstructionType::IN_JP, AddressMode::AM_D16, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_Z)); break;
            case 0xCB: Instructions.add(Instruction(0, InstructionType::IN_CB, AddressMode::AM_D8)); break;
            case 0xCC: Instructions.add(Instruction(0, InstructionType::IN_CALL, AddressMode::AM_D16, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_Z)); break;
            case 0xCD: Instructions.add(Instruction(0, InstructionType::IN_CALL, AddressMode::AM_D16)); break;
            case 0xCE: Instructions.add(Instruction(0, InstructionType::IN_ADC, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0xCF: Instructions.add(Instruction(0x08, InstructionType::IN_RST, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NONE)); break;

            case 0xD0: Instructions.add(Instruction(0, InstructionType::IN_RET, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NC)); break;
            case 0xD1: Instructions.add(Instruction(0, InstructionType::IN_POP, AddressMode::AM_R, RegisterType::RT_DE)); break;
            case 0xD2: Instructions.add(Instruction(0, InstructionType::IN_JP, AddressMode::AM_D16, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NC)); break;
            case 0xD4: Instructions.add(Instruction(0, InstructionType::IN_CALL, AddressMode::AM_D16, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NC)); break;
            case 0xD5: Instructions.add(Instruction(0, InstructionType::IN_PUSH, AddressMode::AM_R, RegisterType::RT_DE)); break;
            case 0xD6: Instructions.add(Instruction(0, InstructionType::IN_SUB, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0xD7: Instructions.add(Instruction(0x10, InstructionType::IN_RST, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NONE)); break;
            case 0xD8: Instructions.add(Instruction(0, InstructionType::IN_RET, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_C)); break;
            case 0xD9: Instructions.add(Instruction(0, InstructionType::IN_RETI)); break;
            case 0xDA: Instructions.add(Instruction(0, InstructionType::IN_JP, AddressMode::AM_D16, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_C)); break;
            case 0xDC: Instructions.add(Instruction(0, InstructionType::IN_CALL, AddressMode::AM_D16, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_C)); break;
            case 0xDE: Instructions.add(Instruction(0, InstructionType::IN_SBC, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0xDF: Instructions.add(Instruction(0x18, InstructionType::IN_RST, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NONE)); break;

            case 0xE0: Instructions.add(Instruction(0, InstructionType::IN_LDH, AddressMode::AM_A8_R, RegisterType::RT_NONE, RegisterType::RT_A)); break;
            case 0xE1: Instructions.add(Instruction(0, InstructionType::IN_POP, AddressMode::AM_R, RegisterType::RT_HL)); break;
            case 0xE2: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_MR_R, RegisterType::RT_C, RegisterType::RT_A)); break;
            case 0xE5: Instructions.add(Instruction(0, InstructionType::IN_PUSH, AddressMode::AM_R, RegisterType::RT_HL)); break;
            case 0xE6: Instructions.add(Instruction(0, InstructionType::IN_AND, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0xE7: Instructions.add(Instruction(0x20, InstructionType::IN_RST, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NONE)); break;
            case 0xE8: Instructions.add(Instruction(0, InstructionType::IN_ADD, AddressMode::AM_R_D8, RegisterType::RT_SP)); break;
            case 0xE9: Instructions.add(Instruction(0, InstructionType::IN_JP, AddressMode::AM_R, RegisterType::RT_HL)); break;
            case 0xEA: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_A16_R, RegisterType::RT_NONE, RegisterType::RT_A)); break;
            case 0xEE: Instructions.add(Instruction(0, InstructionType::IN_XOR, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0xEF: Instructions.add(Instruction(0x28, InstructionType::IN_RST, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NONE)); break;

            case 0xF0: Instructions.add(Instruction(0, InstructionType::IN_LDH, AddressMode::AM_R_A8, RegisterType::RT_A)); break;
            case 0xF1: Instructions.add(Instruction(0, InstructionType::IN_POP, AddressMode::AM_R, RegisterType::RT_AF)); break;
            case 0xF2: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_MR, RegisterType::RT_A, RegisterType::RT_C)); break;
            case 0xF3: Instructions.add(Instruction(0, InstructionType::IN_DI)); break;
            case 0xF5: Instructions.add(Instruction(0, InstructionType::IN_PUSH, AddressMode::AM_R, RegisterType::RT_AF)); break;
            case 0xF6: Instructions.add(Instruction(0, InstructionType::IN_OR, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0xF7: Instructions.add(Instruction(0x30, InstructionType::IN_RST, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NONE)); break;
            case 0xF8: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_HL_SPR, RegisterType::RT_HL, RegisterType::RT_SP)); break;
            case 0xF9: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_R, RegisterType::RT_SP, RegisterType::RT_HL)); break;
            case 0xFA: Instructions.add(Instruction(0, InstructionType::IN_LD, AddressMode::AM_R_A16, RegisterType::RT_A)); break;
            case 0xFB: Instructions.add(Instruction(0, InstructionType::IN_EI)); break;
            case 0xFE: Instructions.add(Instruction(0, InstructionType::IN_CP, AddressMode::AM_R_D8, RegisterType::RT_A)); break;
            case 0xFF: Instructions.add(Instruction(0x38, InstructionType::IN_RST, AddressMode::AM_IMP, RegisterType::RT_NONE, RegisterType::RT_NONE, ConditionType::CT_NONE)); break;
            default:
                Instructions.add(Instruction());
                break;
        }
    }

    return Instructions;
}