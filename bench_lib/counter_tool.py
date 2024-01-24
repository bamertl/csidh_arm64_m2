import os

def map_instruction_category(instruction):
    if instruction in ['add', 'sub', 'adcs', 'adds', 'subs', 'sbcs']:
        return 'add_sub'
    elif instruction in ['ldr', 'ldp', 'str', 'stp']:
        return 'ld_st'
    elif instruction in ['mul', 'umulh']:
        return 'mul'
    else:
        return 'rest'

def count_arm_instructions(file_paths):
    instructions_count = {'add_sub': 0, 'ld_st': 0, 'mul': 0, 'rest': 0}

    for file_path in file_paths:
        with open(file_path, 'r') as file:
            for line in file:
                if '>:' in line:
                    instruction = line.split('>: ')[1].split()[0]
                    category = map_instruction_category(instruction)
                    instructions_count[category] += 1
            instructions_count['add_sub'] -= 1  # Remove the last 'sub' instruction

    return instructions_count

def write_markdown_table(file_names, instructions_counts, markdown_file_path):
    with open(markdown_file_path, 'w') as markdown_file:
        markdown_file.write("# Instruction Counts\n\n")
        markdown_file.write("| File        |")
        
        for category in instructions_counts[file_names[0]].keys():
            markdown_file.write(f" {category} |")
        
        markdown_file.write("\n|-------------|")
        
        for _ in instructions_counts[file_names[0]].keys():
            markdown_file.write("------------|")
        
        markdown_file.write("\n")
        
        for file_name in file_names:
            markdown_file.write(f"| **{file_name}** |")
            
            for category in instructions_counts[file_name].keys():
                markdown_file.write(f" {instructions_counts[file_name][category]} |")
            
            markdown_file.write("\n")

if __name__ == "__main__":
    # Replace with your actual file paths
    file_paths = ["instruction_outputs.txt"]

    file_names = [os.path.basename(file_path) for file_path in file_paths]
    instructions_counts = {file_name: count_arm_instructions([file_path]) for file_name, file_path in zip(file_names, file_paths)}

    # Write the transposed result to a Markdown file for each input file
    markdown_file_path = "instruction_counts_transposed.md"
    write_markdown_table(file_names, instructions_counts, markdown_file_path)

    print(f"Markdown file '{markdown_file_path}' created successfully.")
