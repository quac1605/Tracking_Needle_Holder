% % Load calibration images
% imagesLeft = imageDatastore("data/project_data/image_left_unrect/");
% imagesRight = imageDatastore("data/project_data/image_right_unrect/");
% 
% % Detect checkerboards in images
% [imagePoints, boardSize] = detectCheckerboardPoints(imagesLeft.Files, imagesRight.Files);
% 
% % Generate world coordinates of the checkerboard corners
% squareSize = 25; % in millimeters
% worldPoints = generateCheckerboardPoints(boardSize, squareSize);
% 
% % Calibrate the stereo camera system
% stereoParams = estimateCameraParameters(imagePoints, worldPoints);

load('stereoParams.mat'); 

numPairs = 149;

% Read a pair of images
for i = 0:numPairs

    I1 = imread(['data/project_data/image_left_unrect/image_left_unrect_' num2str(i) '.jpg']);
    I2 = imread(['data/project_data/image_right_unrect/image_right_unrect_' num2str(i) '.jpg']);

    % Rectify the images
    [J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
    
    % % Display the rectified images
    % figure;
    % imshowpair(J1, J2, 'montage');
    % title('Rectified Images');
    % 
    % % Display rectified images with epipolar lines
    % figure;
    % imshow(stereoAnaglyph(J1, J2));
    % title('Rectified Images (Anaglyph)');

    J3 = stereoAnaglyph(J1, J2);

    imwrite(J1, ['rectified_output/left/rectified_left_' num2str(i) '.jpg']);
    imwrite(J2, ['rectified_output/right/rectified_right_' num2str(i) '.jpg']);
    imwrite(J3, ['rectified_output/anaglyph/anaglyph_' num2str(i) '.jpg']);

end
