clear 

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


%%% Yellow mask detection  %%%


[detected_images2, yellow_mask] = createMask_Yellow(frameRightRect);
figure;
imshow(colored_mask_image2);

yellow_props = regionprops(yellow_mask, 'Centroid');
yellow_centroid = yellow_props.Centroid;


% Convert to grayscale.
I1gray = im2gray(frameLeftRect);
I2gray = im2gray(frameRightRect);

% Create the Anaglyph Picture 
stereoAnaglyphImage = stereoAnaglyph(I1gray,I2gray)
figure 
imshow(stereoAnaglyphImage)
title("Composite Image (Red - Left Image, Cyan - Right Image)")



% Create the Disparity map
[D, S] = istereo(I1gray, I2gray, [50 700], 3);

% Display the disparity map
figure;
imagesc(D);
colormap('jet');  % Use the 'jet' colormap for better visualization
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


