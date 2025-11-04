from sys import argv

output = ""

if len(argv) < 2:
    print("usage:\npy compositor.py [input_file] [output_file?]")

with open(argv[1], "r") as unlimiter_script_file:
    file_lines = unlimiter_script_file.readlines()
    unlimiter_script_file.seek(0)

    for line_idx, line in enumerate(file_lines):
        line = line.strip()
        if line.startswith("//!"):
            command = line.split(" ")[1:]

            if len(command) < 2:
                print(f"invalid command at line {line_idx + 1}")
                continue
            
            operator = command[0]
            operands = command[1:]

            match operator.lower():
                case "compose":
                    for operand in operands:
                        try:
                            with open(operand, "r") as file_to_compose:
                                output += f"// {operand}\n"
                                lines_to_be_composed = file_to_compose.readlines()
                                for c_line in lines_to_be_composed:
                                    output += c_line
                        except FileNotFoundError:
                            print(f"no file named {operand} was found to compose (line {line_idx + 1})")
                            continue
                case _:
                    print(f"operator {operator} not yet implemented")
                    continue
        else:
            output += file_lines[line_idx]

output_filename = argv[2] if len(argv) >= 3 else "c_" + argv[1]

try:
    open(output_filename, "w").close()
except FileNotFoundError:
    open(output_filename, "x").close()

with open(output_filename, "w") as output_file:
    output_file.write(output)