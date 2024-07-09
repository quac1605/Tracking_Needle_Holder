% Load stereo images
leftImage = imread('image_left_0.jpg');
rightImage = imread('image_right_0.jpg');

% % Load stereo camera parameters
% load('stereoParams.mat'); % This file should contain 'stereoParams' variable
% 
% % Rectify the images
% [J1, J2] = rectifyStereoImages(leftImage, rightImage, stereoParams);


grayImage1 = rgb2gray(leftImage);
grayImage2 = rgb2gray(rightImage);
disparityMap = disparitySGM(grayImage1, grayImage2, 'DisparityRange', [0, 64]);

%%%%%%%%%%%%%%
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

% Save the stereoParams object
save('stereoParams.mat', 'stereoParams');

% Helper function to convert rotation vector to matrix
function R = rotationVectorToMatrix(r)
    theta = norm(r);
    if theta < eps
        R = eye(3);
        return;
    end
    k = r / theta;
    K = [0, -k(3), k(2); k(3), 0, -k(1); -k(2), k(1), 0];
    R = eye(3) + sin(theta) * K + (1 - cos(theta)) * K^2;
end

%%%%%%%%%%%%%%

%%%%%%%
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



%%%%%%%

% Reconstruct 3D points
points3D = reconstructScene(disparityMap, stereoParams);

% Convert to meters and create a point cloud
points3D = points3D ./ 1000;
ptCloud = pointCloud(points3D, 'Color', J1);

% Visualize the point cloud
pcshow(ptCloud, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('3D Reconstruction of the Scene');