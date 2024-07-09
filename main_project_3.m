leftImage = imread('image_left_0.jpg');
rightImage = imread('image_right_0.jpg');

% Extract color channels
leftRed = leftImage(:,:,1);
rightGreenBlue = rightImage(:,:,2:3);

% Create anaglyph image
anaglyphImage = zeros(size(leftImage), 'like', leftImage);
anaglyphImage(:,:,1) = leftRed;
anaglyphImage(:,:,2:3) = rightGreenBlue;

% Display the anaglyph image
figure;
imshow(anaglyphImage);
title('Anaglyph Stereo Image');

% Save the anaglyph image
imwrite(anaglyphImage, 'anaglyphImage.png');