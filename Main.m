clear
name = 'cameraman';
str = [name '.tif'];
in = imread(str);

if size(in,3)>1
    in = rgb2gray(in);
end
if size(in,1)*size(in,2) > 300^2
    scle = sqrt((300^2)/(size(in,1)*size(in,2)));
    in = imresize(in,scle);
    disp('scaled image')
end
in = im2uint8(in);

out = MBBDHE(in);

imshow(in);
title('Original Input Image')

figure
imshow(out)
title('MBBDHE resultant Image')

