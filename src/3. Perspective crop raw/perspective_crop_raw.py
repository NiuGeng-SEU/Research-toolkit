import cv2
import os
import numpy as np
import rawpy
from pathlib import Path

current_dir = Path(os.path.dirname(os.path.abspath(__file__)))

# Configuration
CONFIG = {
    # Folder paths

    'input_folder': str(current_dir / "Raw"),
    'output_folder': str(current_dir / "Processed"),
    
    # Perspective crop points
    'crop_points': {
        'top_left': [822, 447],
        'top_right': [5335, 447],
        'bottom_left': [490, 3960],
        'bottom_right': [5700, 3960]
    },
    
    # RAW processing parameters
    'raw_settings': {
        'use_camera_wb': True,
        'use_auto_wb': False,
        'bright': 1.0,
        'highlight_mode': 0,
        'gamma': (2.222, 4.5),
        'output_color': rawpy.ColorSpace.sRGB
    },
    
    # Output settings
    'output_format': {
        'extension': '.jpg',
        'jpeg_quality': 95
    }
}

class PerspectiveCropper:
    def __init__(self, input_folder, output_folder):
        self.input_folder = Path(input_folder)
        self.output_folder = Path(output_folder)
        self.output_folder.mkdir(exist_ok=True)
        
        # Convert config points to numpy array
        self.src_points = np.float32([
            CONFIG['crop_points']['top_left'],
            CONFIG['crop_points']['top_right'],
            CONFIG['crop_points']['bottom_left'],
            CONFIG['crop_points']['bottom_right']
        ])
    
    def process_image(self, image_path):
        try:
            with rawpy.imread(str(image_path)) as raw:
                img = raw.postprocess(**CONFIG['raw_settings'])
        except Exception as e:
            print(f"Error reading {image_path}: {e}")
            return
        
        # Calculate output size
        width = int(max(
            np.linalg.norm(self.src_points[0] - self.src_points[1]),
            np.linalg.norm(self.src_points[2] - self.src_points[3])
        ))
        height = int(max(
            np.linalg.norm(self.src_points[0] - self.src_points[2]),
            np.linalg.norm(self.src_points[1] - self.src_points[3])
        ))
        
        # Define destination points
        dst_points = np.float32([
            [0, 0],
            [width, 0],
            [0, height],
            [width, height]
        ])
        
        # Calculate and apply perspective transform
        matrix = cv2.getPerspectiveTransform(self.src_points, dst_points)
        result = cv2.warpPerspective(img, matrix, (width, height))
        
        # Convert color space and save
        result_rgb = cv2.cvtColor(result, cv2.COLOR_RGB2BGR)
        output_path = self.output_folder / (image_path.stem + CONFIG['output_format']['extension'])
        cv2.imwrite(str(output_path), result_rgb, 
                   [cv2.IMWRITE_JPEG_QUALITY, CONFIG['output_format']['jpeg_quality']])
        print(f"Processed: {image_path.name} -> {output_path.name}")
        
    def process_folder(self):
        for image_path in self.input_folder.glob("*.cr2"):
            self.process_image(image_path)

# Main execution
if __name__ == "__main__":
    cropper = PerspectiveCropper(CONFIG['input_folder'], CONFIG['output_folder'])
    cropper.process_folder()
    print("\nProcessing completed!")