import sys
import os
from PIL import Image
import numpy as np
import cv2
import subprocess

def generate_pbr_maps(image_path, normal_strength=1.0, ao_strength=0.7):
    if not os.path.exists(image_path):
        print(f"Error: File not found at {image_path}")
        return

    try:
        img_color = Image.open(image_path).convert('RGB')
        img_gray = img_color.convert('L')
        base, ext = os.path.splitext(image_path)
        print(f"Processing image: {image_path}")

        albedo_path_png = f"{base}_Albedo.png"
        grayscale_path_png = f"{base}_Grayscale.png"
        normal_path_png = f"{base}_NormalMap.png"
        ao_path_png = f"{base}_AO_Map.png"

        img_color.save(albedo_path_png)
        img_gray.save(grayscale_path_png)
        print(f"Saved albedo map to: {albedo_path_png}")
        print(f"Saved grayscale map to: {grayscale_path_png}")

        # --- Generate Normal Map (from height data) ---
        height_data = np.array(img_gray, dtype=float)
        dz_dx = height_data[:, 1:] - height_data[:, :-1]
        dz_dy = height_data[1:, :] - height_data[:-1, :]
        dz_dx = np.pad(dz_dx, ((0, 0), (0, 1)), mode='edge')
        dz_dy = np.pad(dz_dy, ((0, 1), (0, 0)), mode='edge')
        shape = height_data.shape
        normal_map_np = np.zeros((shape[0], shape[1], 3), dtype=float) # Corrected shape access
        normal_map_np[:, :, 0] = dz_dx
        normal_map_np[:, :, 1] = dz_dy
        normal_map_np[:, :, 2] = 1.0 / normal_strength
        length = np.sqrt(np.sum(normal_map_np**2, axis=2, keepdims=True))
        normal_map_np /= length
        normal_map_np = (normal_map_np + 1.0) / 2.0 * 255.0
        normal_map_np = normal_map_np.astype(np.uint8)
        normal_map_np[:, :, 1] = 255 - normal_map_np[:, :, 1] # Invert green for Unity (OpenGL)
        Image.fromarray(normal_map_np, 'RGB').save(normal_path_png)
        print(f"Saved normal map to: {normal_path_png}")

        # --- Generate Approximate Ambient Occlusion Map ---
        ao_source = np.array(Image.eval(img_gray, lambda x: 255 - x))
        blur_kernel_size = 21 
        blurred_ao = cv2.GaussianBlur(ao_source, (blur_kernel_size, blur_kernel_size), 0)
        ao_map_np = np.clip(blurred_ao * ao_strength, 0, 255).astype(np.uint8)
        Image.fromarray(ao_map_np, 'L').save(ao_path_png)
        print(f"Saved ambient occlusion map to: {ao_path_png}")


    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2 or len(sys.argv) > 4:
        print("Usage 1 (Defaults): python generate_pbr_maps.py <path_to_input_image.png>")
        print("Usage 2 (Custom Normal Strength): python generate_pbr_maps.py <path_to_input_image.png> <normal_strength_float>")
        print("Usage 3 (Custom Normal & AO Strength): python generate_pbr_maps.py <path_to_input_image.png> <normal_strength_float> <ao_strength_float>")
    else:
        # CORRECT ARGUMENT PARSING:
        # Get the path string from index 1 of the list
        image_path_input = sys.argv[1]
        
        # Get optional strength values by index, using default if not present
        strength = float(sys.argv[2]) if len(sys.argv) >= 3 else 1.0
        ao_str = float(sys.argv[3]) if len(sys.argv) == 4 else 0.7
        
        generate_pbr_maps(image_path_input, strength, ao_str)

