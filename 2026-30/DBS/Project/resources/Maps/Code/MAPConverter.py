import struct
import os

# --- Configuration ---
VERTICES_LUMP = 'VERTEXES.lmp'
LINEDEFS_LUMP = 'LINEDEFS.lmp'
OUTPUT_WKT_FILE = 'map_geometry.wkt'
# -------------------

def read_vertices(filename):
    """Reads a VERTEXES.lmp file and returns a list of (x, y) tuples."""
    if not os.path.exists(filename):
        print(f"Error: Vertices file '{filename}' not found.")
        return None
    
    vertices = []
    with open(filename, 'rb') as f:
        while True:
            chunk = f.read(4) # Each vertex is 4 bytes (2 signed shorts)
            if not chunk:
                break
            # '<2h' = little-endian, two signed 16-bit integers
            x, y = struct.unpack('<2h', chunk)
            vertices.append((x, y))
    print(f"Read {len(vertices)} vertices from '{filename}'.")
    return vertices

def convert_linedefs_to_wkt(vertices_list, linedefs_filename, output_filename):
    """Reads a LINEDEFS.lmp file and writes WKT LineStrings to an output file."""
    if not os.path.exists(linedefs_filename):
        print(f"Error: Linedefs file '{linedefs_filename}' not found.")
        return

    lines_written = 0
    with open(linedefs_filename, 'rb') as f_in, open(output_filename, 'w') as f_out:
        while True:
            chunk = f_in.read(14) # A vanilla Doom linedef is 14 bytes
            if len(chunk) < 14:
                break
            
            # '<2H' = little-endian, two unsigned 16-bit integers for the vertex indices
            start_idx, end_idx = struct.unpack('<2H', chunk[0:4])
            
            # Look up the actual coordinates using the indices
            start_vertex = vertices_list[start_idx]
            end_vertex = vertices_list[end_idx]
            
            # Format the WKT LineString
            wkt_string = f"LINESTRING ({start_vertex[0]} {start_vertex[1]}, {end_vertex[0]} {end_vertex[1]})\n"
            
            # Write to the output file
            f_out.write(wkt_string)
            lines_written += 1
            
    print(f"Successfully wrote {lines_written} LineStrings to '{output_filename}'.")

# --- Main execution ---
if __name__ == "__main__":
    all_vertices = read_vertices(VERTICES_LUMP)
    if all_vertices:
        convert_linedefs_to_wkt(all_vertices, LINEDEFS_LUMP, OUTPUT_WKT_FILE)
