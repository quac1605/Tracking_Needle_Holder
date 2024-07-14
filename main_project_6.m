% 
% numPairs = 149;
% 
% outputVideoFile1 = 'output_left.avi';
% 
% outputVideo1 = VideoWriter(outputVideoFile1);
% outputVideo1.FrameRate = 30; % Adjust as needed
% open(outputVideo1);
% 
% outputVideoFile2 = 'output_right.avi';
% 
% outputVideo2 = VideoWriter(outputVideoFile2);
% outputVideo2.FrameRate = 30; % Adjust as needed
% open(outputVideo2);
% 
% outputVideoFile3 = 'output_anaglyph.avi';
% 
% outputVideo3 = VideoWriter(outputVideoFile3);
% outputVideo3.FrameRate = 30; % Adjust as needed
% open(outputVideo3);
% 
% for i = 1:numPairs
% 
%     frame1 = imread(['rectified_output/left/rectified_left_' num2str(i) '.jpg']);
%     frame2 = imread(['rectified_output/right/rectified_right_' num2str(i) '.jpg']);
%     frame3 = imread(['rectified_output/anaglyph/anaglyph_' num2str(i) '.jpg']);
%     writeVideo(outputVideo1, frame1);
%     writeVideo(outputVideo2, frame2);
%     writeVideo(outputVideo3, frame3);
% 
% end
% 
% close(outputVideo1);
% close(outputVideo2);
% close(outputVideo3);

% Number of image pairs
numPairs = 149;

% Define output video file names
outputVideoFile1 = 'output_left.avi';
outputVideoFile2 = 'output_right.avi';
outputVideoFile3 = 'output_anaglyph.avi';

% Create VideoWriter objects
outputVideo1 = VideoWriter(outputVideoFile1);
outputVideo1.FrameRate = 30; % Adjust as needed
open(outputVideo1);

outputVideo2 = VideoWriter(outputVideoFile2);
outputVideo2.FrameRate = 30; % Adjust as needed
open(outputVideo2);

outputVideo3 = VideoWriter(outputVideoFile3);
outputVideo3.FrameRate = 30; % Adjust as needed
open(outputVideo3);

% Loop through each pair of images
for i = 1:numPairs
    % Construct file names for each frame
    frame1File = fullfile('rectified_output', 'left', ['rectified_left_' num2str(i) '.jpg']);
    frame2File = fullfile('rectified_output', 'right', ['rectified_right_' num2str(i) '.jpg']);
    frame3File = fullfile('rectified_output', 'anaglyph', ['anaglyph_' num2str(i) '.jpg']);

    % Read each frame
    frame1 = imread(frame1File);
    frame2 = imread(frame2File);
    frame3 = imread(frame3File);

    % Write each frame to the respective video
    writeVideo(outputVideo1, frame1);
    writeVideo(outputVideo2, frame2);
    writeVideo(outputVideo3, frame3);
end

% Close the VideoWriter objects
close(outputVideo1);
close(outputVideo2);
close(outputVideo3);

disp('Video creation complete');