function imageSegmentation


%reading image and corresponding i_f and i_b images

image = double(imread('image1.jpg'));

i_fImage = double(imread('i_fImage.jpg'));
i_bImage = double(imread('i_bImage.jpg'));



%computint i_f and i_b
i_f = computeAverage(i_fImage);
i_b = computeAverage(i_bImage);


%defining beta
beta = 0.5;


%seprating red green and blue channels for easier use
redOfImage = image(:, :, 1);
greenOfImage = image(:, :, 2);
blueOfImage = image(:, :, 3);

%determining the size of image
sizeOfImage = size(image);
widthOfImage = sizeOfImage(1);
lengthOfImage = sizeOfImage(2);


%f = draw(widthOfImage,lengthOfImage);


E_i_0 = zeros(widthOfImage, lengthOfImage);
%computing E_i_(0) matrix
for i = 1:widthOfImage
    for j = 1:lengthOfImage
        redOfImage_i_fRed = image(i, j, 1) - i_f(1);
        greenOfImage_i_fGreen = image(i, j, 2) - i_f(2);
        blueOfImage_i_fBlue = image(i, j, 3) - i_f(3);
        E_i_0(i,j) = beta*norm(double([redOfImage_i_fRed greenOfImage_i_fGreen blueOfImage_i_fBlue]));
    end
end

%sizeOfF = size(f);
%sizeOfF = sizeOfF(1);



E_i_1 = zeros(widthOfImage, lengthOfImage);
%computing E_i_(1) matrix
for i = 1:widthOfImage
    for j = 1:lengthOfImage
        redOfImage_i_bRed = image(i, j, 1) - i_b(1);
        greenOfImage_i_bGreen = image(i, j, 2) - i_b(2);
        blueOfImage_i_bBlue = image(i, j, 3) - i_b(3);
        E_i_1(i,j) = beta*norm(double([redOfImage_i_bRed greenOfImage_i_bGreen blueOfImage_i_bBlue]));
    end
end
% 
% 
% for i = 1:sizeOfF
%     E_i_1(f(i,2),f(i,1)) = 100000;
% end


%digraph variables
source = [];
target = [];
weights = [];

indexOfTheSource = widthOfImage * lengthOfImage + 1;
%adding source to picture foreground nodes and edges to picture matrix
for counter = 1:(widthOfImage*lengthOfImage)
    source = [source indexOfTheSource];
    target = [target counter];
    weights = [weights E_i_0(floor((counter-1)/lengthOfImage)+1 , rem((counter-1) , lengthOfImage)+1)];
end



indexOfTheTarget = widthOfImage * lengthOfImage + 2;
%adding target to picture background nodes and edges to picture matrix
for counter = 1:(widthOfImage*lengthOfImage)
    source = [source counter];
    target = [target indexOfTheTarget];
    weights = [weights E_i_1(floor((counter-1)/lengthOfImage)+1 , rem((counter-1) , lengthOfImage)+1)];
end


%row inner edges
for i = 1:widthOfImage
    for j = 1:(lengthOfImage-1)
        source = [source ((i-1) * lengthOfImage + j)];
        target = [target ((i-1) * lengthOfImage + j)+1];
        weights = [weights 1];
        source = [source ((i-1) * lengthOfImage + j)+1];
        target = [target ((i-1) * lengthOfImage + j)];
        weights = [weights 1];
    end
end

%column inner edges

for i = 1:widthOfImage-1
    for j = 1:lengthOfImage
        source = [source ((i-1) * lengthOfImage + j)];
        target = [target ((i-1) * lengthOfImage + j)+widthOfImage];
        weights = [weights 1];
        source = [source ((i-1) * lengthOfImage + j)+widthOfImage];
        target = [target ((i-1) * lengthOfImage + j)];
        weights = [weights 1];
    end
end

G = digraph(source,target,weights);

[mf,~,cs,ct] = maxflow(G,indexOfTheSource,indexOfTheTarget);
% 
sizeOfCs = size(cs);
sizeOfCs = sizeOfCs(1);

for i = 1:sizeOfCs
    index = cs(i);
    xAxis = floor((index-1)/lengthOfImage+1);
    yAxis = rem((index-1) , lengthOfImage)+1;
    image(xAxis,yAxis,1) = 255;
    image(xAxis,yAxis,2) = 255;
    image(xAxis,yAxis,3) = 255;
end

% sizeOfCs = size(ct);
% sizeOfCs = sizeOfCs(1);
% 
% for i = 1:sizeOfCs
%     index = ct(i);
%     xAxis = int8((index-1)/lengthOfImage+1);
%     yAxis = rem((index-1) , lengthOfImage)+1;
%     image(xAxis,yAxis,1) = 255;
%     image(xAxis,yAxis,2) = 255;
%     image(xAxis,yAxis,3) = 255;
% end



imshow(uint8(image));

end