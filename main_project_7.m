% Step 1: Read the Image
imageFile = 'rectified_output/anaglyph/anaglyph_0.jpg'; % Replace with your image file
I = imread(imageFile);

% Step 2: Convert the Image to HSV Color Space
I_hsv = rgb2hsv(I);

% Step 3: Define Color Thresholds for Blue Color
hueThresholdLow = 0.65; % Adjust as needed
hueThresholdHigh = 0.85; % Adjust as needed
saturationThresholdLow = 0.4;
saturationThresholdHigh = 1.0;
valueThresholdLow = 0.2;
valueThresholdHigh = 1.0;

% Step 4: Threshold the Image to Create a Binary Mask
mask = (I_hsv(:,:,1) >= hueThresholdLow & I_hsv(:,:,1) <= hueThresholdHigh) & ...
       (I_hsv(:,:,2) >= saturationThresholdLow & I_hsv(:,:,2) <= saturationThresholdHigh) & ...
       (I_hsv(:,:,3) >= valueThresholdLow & I_hsv(:,:,3) <= valueThresholdHigh);

% Step 5: Post-Processing
% Remove small objects and fill holes
mask = bwareaopen(mask, 50); % Remove small objects (adjust the size as needed)
mask = imfill(mask, 'holes');

% Step 6: Label and Measure Objects
labeledImage = bwlabel(mask);
objectProperties = regionprops(labeledImage, 'Area', 'Centroid', 'BoundingBox');

% Display the Original Image and the Mask
figure;
subplot(1, 2, 1);
imshow(I);
title('Original Image');

subplot(1, 2, 2);
imshow(mask);
title('Detected Blue Objects');

% Overlay the bounding boxes and centroids on the original image
figure;
imshow(I);
hold on;
for k = 1:length(objectProperties)
    rectangle('Position', objectProperties(k).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
    plot(objectProperties(k).Centroid(1), objectProperties(k).Centroid(2), 'b*');
end
title('Detected Blue Objects with Bounding Boxes and Centroids');
hold off;