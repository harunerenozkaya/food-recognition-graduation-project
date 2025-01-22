import os
import torch
from ultralytics import YOLO
import matplotlib.pyplot as plt
from google.colab import drive

device = 'cuda' if torch.cuda.is_available() else 'cpu'
print(f'Using device: {device}')

drive.mount('/content/drive')

project_name = 'food_segmentation_project'
experiment_name = 'food_segmentation_experiment'

output_dir = os.path.join('/content/drive/MyDrive', project_name, experiment_name)
os.makedirs(output_dir, exist_ok=True)

torch.manual_seed(42)

results = model.train(
    data=f'{dataset.location}/data.yaml',
    epochs=50,
    imgsz=640,
    name=experiment_name,
    project=output_dir,
    plots=True,
    device=device,
    optimizer="SGD",
    lr0=0.01,
    momentum=0.9,
    weight_decay=0.0005,
    save=True,
    task='segment'
)

print("Results : ")
print(results)

model.val()

model.export(format="coreml", nms=True)


