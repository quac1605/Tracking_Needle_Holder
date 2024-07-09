% Load stereo images
leftImage = imread('image_left_0.jpg');
rightImage = imread('image_right_0.jpg');

% Load stereo camera parameters
load('stereoParams.mat'); % This file should contain 'stereoParams' variable

% Rectify the images
[J1, J2] = rectifyStereoImages(leftImage, rightImage, stereoParams);

% Convert the rectified images to grayscale
grayImage1 = rgb2gray(J1);
grayImage2 = rgb2gray(J2);

% Compute the disparity map
disparityRange = [0, 64];
disparityMap = disparitySGM(grayImage1, grayImage2, 'DisparityRange', disparityRange);

% Reconstruct 3D points
points3D = reconstructScene(disparityMap, stereoParams);

% Convert to meters and create a point cloud
points3D = points3D ./ 1000;
ptCloud = pointCloud(points3D, 'Color', J1);

% Segment the needle holder rod based on blue color
blueThresholdLow = [0, 0, 100];
blueThresholdHigh = [50, 50, 255];

% Create a mask for the blue color
blueMask = (J1(:,:,1) >= blueThresholdLow(1)) & (J1(:,:,1) <= blueThresholdHigh(1)) & ...
           (J1(:,:,2) >= blueThresholdLow(2)) & (J1(:,:,2) <= blueThresholdHigh(2)) & ...
           (J1(:,:,3) >= blueThresholdLow(3)) & (J1(:,:,3) <= blueThresholdHigh(3));

% Select the points corresponding to the blue mask
indices = find(blueMask);
segmentedPtCloud = select(ptCloud, indices);

% Extract the locations of the segmented points
segmentedPoints = segmentedPtCloud.Location;

% Remove NaN values
segmentedPoints = segmentedPoints(~any(isnan(segmentedPoints), 2), :);

% Fit a line using PCA
coeff = pca(segmentedPoints);
linePt = mean(segmentedPoints, 1);
lineDir = coeff(:,1)';

% Visualize the result
figure;
pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
hold on;
plot3(linePt(1) + [0, lineDir(1)], linePt(2) + [0, lineDir(2)], linePt(3) + [0, lineDir(3)], '-r', 'LineWidth', 2);
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('3D Reconstruction and Needle Holder Rod Orientation');
legend('Point Cloud', 'Fitted Line');
hold off;

% Output the orientation (direction) of the needle holder rod
disp('Orientation of the needle holder rod:');
disp(lineDir);