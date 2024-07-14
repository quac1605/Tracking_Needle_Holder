clear; 

% Left Camera Intrinsics
leftFocalLength = [1401.1400, 1401.1400];
leftPrincipalPoint = [1150.3900, 670.6210];
leftRadialDistortion = [-0.1754, 0.0275, 0.0000];  % K1, K2, K3
leftTangentialDistortion = [-0.0013, -0.0006];  % P1, P2
    
% Right Camera Intrinsics
rightFocalLength = [1399.2200, 1399.2200];
rightPrincipalPoint = [1115.0000, 600.0290];
rightRadialDistortion = [-0.1711, 0.0258, 0.0000];  % K1, K2, K3
rightTangentialDistortion = [-0.0010, -0.0009];  % P1, P2
    
% Extrinsics (Translation and Rotation)
translationOfCamera2 = [62.9976, -0.0024, 0.0022];
rotationOfCamera2 = rotationVectorToMatrix([0.0034, 0.0000, -0.0008]);
    
% Create cameraParameters objects
leftCameraParams = cameraParameters('IntrinsicMatrix', [leftFocalLength(1), 0, leftPrincipalPoint(1); 0, leftFocalLength(2), leftPrincipalPoint(2); 0, 0, 1]', ...
                                        'RadialDistortion', leftRadialDistortion, ...
                                        'TangentialDistortion', leftTangentialDistortion);
    
rightCameraParams = cameraParameters('IntrinsicMatrix', [rightFocalLength(1), 0, rightPrincipalPoint(1); 0, rightFocalLength(2), rightPrincipalPoint(2); 0, 0, 1]', ...
                                         'RadialDistortion', rightRadialDistortion, ...
                                         'TangentialDistortion', rightTangentialDistortion);


% Create stereoParameters object
stereoParams = stereoParameters(leftCameraParams, rightCameraParams, rotationOfCamera2, translationOfCamera2);


I1 = imread("data/image_left_unrect/image_left_unrect_0.jpg");
I2 = imread("data/image_right_unrect/image_right_unrect_0.jpg");



[frameLeftRect, frameRightRect, reprojectionMatrix] = ...
    rectifyStereoImages(I1, I2, stereoParams);

%%% Blue mask detection  %%%


[detected_images1, colored_mask_image1] = createMask(frameRightRect);
figure;
imshow(colored_mask_image1); 
blue_props = regionprops(detected_images1, 'Centroid');


%%% Yellow mask detection  %%%


[detected_images2, yellow_mask] = createMask_Yellow(frameRightRect);
figure;
imshow(yellow_mask);

yellow_props = regionprops(yellow_mask, 'Centroid');
yellow_centroid = yellow_props(53).Centroid;

%%% Gray mask detection  %%%


[detected_images3, gray_mask] = createMask_Gray(frameRightRect);
figure;
imshow(gray_mask);
gray_props = regionprops(detected_images3, 'Centroid');
gray_centroid = gray_props(92).Centroid

% Convert to grayscale.
I1gray = im2gray(frameLeftRect);
I2gray = im2gray(frameRightRect);

% Create the Anaglyph Picture 
stereoAnaglyphImage = stereoAnaglyph(I1gray,I2gray)
figure 
imshow(stereoAnaglyphImage)
hold on;
plot(yellow_centroid(1), yellow_centroid(2), 'yo', 'MarkerSize', 10, 'LineWidth', 2);
plot(gray_centroid(1), gray_centroid(2), 'go', 'MarkerSize', 10, 'LineWidth', 2); % Mark gray part
title('Detected Coordinate Origin and Holder Tip');

pause(3);

% for k = 1:length(blue_props)
% %     Extract the coordinates of the blue tip
%     blue_tip_coords = blue_props(k).Centroid;
% 
% %     Shift coordinates to make the yellow object's centroid the origin
%     shifted_coords = blue_tip_coords - yellow_centroid;
% 
% %     Plot the shifted coordinates
%     plot(shifted_coords(1) + yellow_centroid(1), shifted_coords(2) + yellow_centroid(2), 'r*', 'MarkerSize', 10);
% 
% %     Calculate and plot the orientation vector (example vector)
%     x = shifted_coords(1) + yellow_centroid(1);
%     y = shifted_coords(2) + yellow_centroid(2);
%     x2 = x + 20;  % Example second point (to be replaced with actual method)
%     y2 = y + 20;  % Example second point (to be replaced with actual method)
% 
% %     Plot the orientation vector
%     quiver(x, y, x2 - x, y2 - y, 'r', 'LineWidth', 2);
% end
% 
% hold off;
% title('Needle Holder Tip Trajectory and Orientation with New Origin');

% 


% Create the Disparity map
[D,S] = istereo(I1gray,I2gray,[50 700], 3);

% Display the disparity map
figure;
waitfor(imagesc(D));
waitfor(colormap('jet'));  % Use the 'jet' colormap for better visualization
colorbar;  % Add a colorbar to visualize the range of disparities
caxis([min(D(:)) max(D(:))]);  % Set the color axis limits based on the data range
title('Disparity Map');


% Reconstruct 3D points
points3D = reconstructScene(D, stereoParams);

% Convert to meters and create a point cloud
points3D = points3D ./ 1000;
ptCloud = pointCloud(points3D, 'Color', frameRightRect);

% Visualize the point cloud
pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('3D Reconstruction of the Scene');


