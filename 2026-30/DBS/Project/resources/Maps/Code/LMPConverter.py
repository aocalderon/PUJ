import struct
import os

# --- Configuration ---
input_lump_file = 'VERTEXES.lmp'
output_csv_file = 'vertices.csv'
# -------------------

# Check if the input file exists
if not os.path.exists(input_lump_file):
    print(f"Error: Input file '{input_lump_file}' not found.")
else:
    # Open the binary lump file for reading ('rb')
    # and the new CSV file for writing ('w')
    with open(input_lump_file, 'rb') as f_in, open(output_csv_file, 'w') as f_out:
        
        # Write the header row to the CSV file
        f_out.write('x,y\n')
        
        while True:
            # Read 4 bytes at a time (2 bytes for X, 2 for Y)
            chunk = f_in.read(4)
            
            # If the chunk is less than 4 bytes, we've reached the end of the file
            if len(chunk) < 4:
                break
            
            # Unpack the 4-byte chunk into two 16-bit signed integers.
            # '<' means little-endian byte order (standard for Doom WADs).
            # 'h' is the format code for a 16-bit signed integer.
            x, y = struct.unpack('<2h', chunk)
            
            # Write the x and y coordinates to the CSV file, followed by a newline
            f_out.write(f'{x},{y}\n')
            
    print(f"Successfully converted '{input_lump_file}' to '{output_csv_file}'.")
