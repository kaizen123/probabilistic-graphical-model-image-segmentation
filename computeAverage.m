function [ average ] = compute( image )
%COMPUTE Summary of this function goes here
%   Detailed explanation goes here



allRed = image(:, :, 1);
allGreen = image(:, :, 2);
allBlue = image(:, :, 3);

averageRed = mean(mean(allRed));
averageGreen = mean(mean(allGreen));
averageBlue = mean(mean(allBlue));

average = [averageRed averageGreen averageBlue];

end

