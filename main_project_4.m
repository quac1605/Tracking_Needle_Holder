
numPairs = 40;

outputVideoFile = 'anaglyph_video.avi';

outputVideo = VideoWriter(outputVideoFile);
outputVideo.FrameRate = 10; % Adjust as needed
open(outputVideo);

for i = 1:numPairs

    % Load stereo images
    leftImage = imread(['image_left_' num2str(i) '.jpg']);
    rightImage = imread(['image_right_' num2str(i) '.jpg']);

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


    % Write frame to video
    writeVideo(outputVideo, anaglyphImage);

end

close(outputVideo);