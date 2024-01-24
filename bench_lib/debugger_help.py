# Save this script as disassemble_fp_mul3.py

import lldb
import re

def write_commands(debugger, command, result, internal_dict):
    # Get the current frame
    frame = debugger.GetSelectedTarget().GetProcess().GetSelectedThread().GetSelectedFrame()

    # Create a command return object to capture the output
    command_return_object = lldb.SBCommandReturnObject()

    # Save the output to a file
    filename = "instruction_outputs.txt"

    try:
        with open(filename, "w") as file:
            iteration = 0
            while iteration < 100000:
                debugger.GetCommandInterpreter().HandleCommand("step", command_return_object)

                # Check for errors in the command execution
                if command_return_object.HasResult():
                    print(f"Error: {command_return_object.GetError()}")
                    return

                # Extract the relevant part of the output (first line with ">:" combination)
                output_lines = command_return_object.GetOutput().split('\n')
                relevant_line = None
                for line in output_lines:
                    if ">:" in line:
                        relevant_line = line
                        break

                # If no line with ">:" combination is found, skip this iteration
                if relevant_line is None:
                    continue

                # Remove special characters, keeping only letters, numbers, and specified signs
                cleaned_statement = re.sub(r'[^a-zA-Z0-9<>:;]', ' ', relevant_line)

                # Replace multiple spaces, tabs, or a combination with a single space
                cleaned_statement = re.sub(r'\s+', ' ', cleaned_statement)

                # Write the cleaned current execution statement to the file
                file.write(cleaned_statement)
                file.write('\n')  # Add a newline between outputs
                file.flush()  # Ensure the data is written immediately to the file

                # Check if you are at the end of the function (modify this condition as needed)
                if "sub sp sp 0x71" in cleaned_statement:
                    print("Reached the end of the function. Stopping the loop.")
                    break

                iteration += 1

        print(f"Output saved to '{filename}'")
    except IOError as e:
        print(f"IOError: {e}")
    except Exception as e:
        print(f"Error writing to file: {e}")

    return False



# Add the command to LLDB
def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand('command script add -f debugger_help.write_commands write_commands')
