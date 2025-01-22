from fastapi import FastAPI, UploadFile, File
from ultralytics import YOLO
import cv2
import numpy as np
from typing import List, Dict
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load YOLOv8 model globally
model = YOLO('best.pt')

@app.post("/api/v1/predict")
async def predict(files: List[UploadFile] = File(...)):
    response_list = []
    
    for file in files:
        # Read image from the uploaded file
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        # Get original image dimensions
        original_height, original_width = image.shape[:2]
        
        # Perform prediction
        results = model.predict(image, imgsz=640, conf=0.25)
        
        # Process results
        predictions = []
        
        for result in results:
            # Get masks in xy format
            if result.masks is not None:
                masks = result.masks.xy
                
                # Get class predictions
                cls = result.boxes.cls.cpu().numpy()
                conf = result.boxes.conf.cpu().numpy()
                
                for idx, (mask, class_id, confidence) in enumerate(zip(masks, cls, conf)):
                    mask_data = {
                        "mask_points": mask.tolist(),
                        "class_id": int(class_id),
                        "confidence": float(confidence),
                        "class_label": result.names[int(class_id)]
                    }
                    predictions.append(mask_data)
        
        # Create response for this image
        image_response = {
            "filename": file.filename,
            "success": True,
            "predictions": predictions,
            "image_info": {
                "width": original_width,
                "height": original_height
            }
        }
        response_list.append(image_response)
    
    return {
        "results": response_list
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
