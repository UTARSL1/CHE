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

out = methodology(in);

imshow(in);
figure
imshow(out)
figure
imshow(histeq(in))
figure
imshow(newHistEq(in))
figure
imshow(imContrast_2DHE(in))