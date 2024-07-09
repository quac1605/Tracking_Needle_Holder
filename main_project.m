% Load Camera Parameters
paramsLeft.fx = 1401.1400;
paramsLeft.fy = 1401.1400;
paramsLeft.cx = 1150.3900;
paramsLeft.cy = 670.6210;
paramsLeft.k1 = -0.1754;
paramsLeft.k2 = 0.0275;
paramsLeft.p1 = -0.0013;
paramsLeft.p2 = -0.0006;
paramsLeft.k3 = 0;

paramsRight.fx = 1399.2200;
paramsRight.fy = 1399.2200;
paramsRight.cx = 1115.0000;
paramsRight.cy = 600.0290;
paramsRight.k1 = -0.1711;
paramsRight.k2 = 0.0258;
paramsRight.p1 = -0.0010;
paramsRight.p2 = -0.0009;
paramsRight.k3 = 0;

% Stereo Parameters
tx = 62.9976;
ty = -0.0024;
tz = 0.0022;
rx = 0.0034;
ry = 0;
rz = -0.0008;


% Load Images
imgLeft = imread('C:\Users\nnqua\OneDrive\Dokumente\MATLAB\Tracking_Needle_Holder\Tracking_Needle_Holder\data\image_left_unrect\image_left_unrect_0.jpg');
imgRight = imread('C:\Users\nnqua\OneDrive\Dokumente\MATLAB\Tracking_Needle_Holder\Tracking_Needle_Holder\data\image_right_unrect\image_right_unrect_0.jpg');

% Undistort Images
imgLeftUndistorted = undistortImage(imgLeft, cameraParameters('IntrinsicMatrix', [paramsLeft.fx 0 paramsLeft.cx; 0 paramsLeft.fy paramsLeft.cy; 0 0 1], 'RadialDistortion', [paramsLeft.k1, paramsLeft.k2, paramsLeft.k3], 'TangentialDistortion', [paramsLeft.p1, paramsLeft.p2]));
imgRightUndistorted = undistortImage(imgRight, cameraParameters('IntrinsicMatrix', [paramsRight.fx 0 paramsRight.cx; 0 paramsRight.fy paramsRight.cy; 0 0 1], 'RadialDistortion', [paramsRight.k1, paramsRight.k2, paramsRight.k3], 'TangentialDistortion', [paramsRight.p1, paramsRight.p2]));

% Rectify Images
[imgLeftRectified, imgRightRectified] = rectifyStereoImages(imgLeftUndistorted, imgRightUndistorted, stereoParameters('TranslationOfCamera2', [tx, ty, tz], 'RotationOfCamera2', [rx, ry, rz]));