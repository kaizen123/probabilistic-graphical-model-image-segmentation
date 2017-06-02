function pos = draw(widthOfImage,lengthOfImage)
figure, imshow('image.jpg');
h = imfreehand('Closed',0);
pos = int16(getPosition(h));
% sizeOfPos = size(pos);
% sizeOfPos = sizeOfPos(1);
% f = [];
% temp = 0;
% for i = 1:sizeOfPos
%     temp = (pos(i,2)-1) * lengthOfImage + pos(i,1);
%     f = [f temp];
% end
end