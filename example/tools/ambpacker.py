import argparse
from PIL import Image
import os

def create_black_metallic_standin(width, height, output_path):
    """Creates a solid black image (L mode) of a specified size."""
    try:
        # 'L' mode is grayscale (single channel), which is what we need for the input
        img = Image.new('L', (width, height), color=0) 
        img.save(output_path, "PNG")
        print(f"Created black metallic stand-in image: {output_path}")
    except Exception as e:
        print(f"Error creating black image: {e}")

def pack_metallic_smoothness_unity(metallic_path, roughness_path, output_path):
    # This is the same function we used before, using Image.merge()
    if not os.path.exists(metallic_path) or not os.path.exists(roughness_path):
        print("Error: One or more input files not found.")
        return

    try:
        metallic = Image.open(metallic_path).convert('L')
        roughness = Image.open(roughness_path).convert('L')

        if metallic.size != roughness.size:
            print("Error: Metallic and Roughness maps must have the same dimensions.")
            return

        smoothness = Image.eval(roughness, lambda p: 255 - p)
        packed_map = Image.merge('RGBA', (metallic, metallic, metallic, smoothness))
        packed_map.save(output_path, "PNG")
        print(f"Successfully packed textures to: {output_path}")

    except Exception as e:
        print(f"An error occurred during image processing: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Pack separate Metallic and Roughness maps into a single Unity-compatible Metallic-Smoothness map (R=Metallic, A=Smoothness). Supports generating a black metallic stand-in if a metallic map is missing.")
    
    parser.add_argument('--roughness', '-r', type=str, required=True, help="Path to the input roughness map (e.g., *_Roughness.png).")
    parser.add_argument('--output', '-o', type=str, required=True, help="Path for the output packed texture file (e.g., *_MS_Packed.png).")
    parser.add_argument('--metallic', '-m', type=str, help="Path to the input metallic map. If omitted, a black stand-in is created.")
    
    args = parser.parse_args()
    
    # Logic to handle missing metallic map:
    metallic_input_path = args.metallic
    if not metallic_input_path:
        # If no metallic path provided, check the roughness size and create a black stand-in first
        try:
            temp_roughness_img = Image.open(args.roughness)
            width, height = temp_roughness_img.size
            temp_roughness_img.close()
            
            # Define a temporary name for the black image
            temp_metallic_path = "temp_black_metallic_standin.png"
            create_black_metallic_standin(width, height, temp_metallic_path)
            metallic_input_path = temp_metallic_path
            
            # Run the packing operation
            pack_metallic_smoothness_unity(metallic_input_path, args.roughness, args.output)
            
            # Clean up the temporary black image file
            os.remove(temp_metallic_path)
            print(f"Cleaned up temporary file: {temp_metallic_path}")

        except FileNotFoundError:
            print(f"Error: Roughness file not found at {args.roughness}")
        except Exception as e:
            print(f"An error occurred during automatic black map generation: {e}")
            
    else:
        # If metallic path was provided, just run the packing function directly
        pack_metallic_smoothness_unity(args.metallic, args.roughness, args.output)


