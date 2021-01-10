function out = methodology(varargin)

in = varargin{1};
w = 33;
T0 = 5;
gamma = 0.05;
if nargin>1
    for check=2:2:nargin
       switch varargin{check}
           case 'w'
               w=varargin{check+1};
           case 'T0'
               T0 = varargin{check+1};
           case 'gamma'
               gamma = varargin{check+1};
       end
    end
end
[row,col]=size(in);
sketch = zeros(row,col);
w_half = (w-1)/2;
padValue = NaN;
padImIn(w_half+1:row+w_half,w_half+1:col+w_half)=double(in);
padImIn(row+w_half+1:row+2*w_half,:)=padValue;
padImIn(:,col+w_half+1:col+2*w_half)=padValue;
padImIn(1:w_half,:)=padValue;
padImIn(:,1:w_half)=padValue;
paddedImIn = padImIn;
paddedImIn(row+w_half+1:row+2*w_half,w_half+1:col+w_half)=flipud(double(in(end-w_half+1:end,:))); %down
paddedImIn(w_half+1:row+w_half,col+w_half+1:col+2*w_half)=fliplr(double(in(:,end-w_half+1:end))); %right
paddedImIn(1:w_half,w_half+1:col+w_half)=flipud(double(in(1:w_half,:))); %top
paddedImIn(w_half+1:row+w_half,1:w_half)=fliplr(double(in(:,1:w_half))); %left
paddedImIn(1:w_half,1:w_half) = rot90(flipud(double(in(1:w_half,1:w_half)))); %upper left
paddedImIn(1:w_half,end-w_half+1:end) = double(in(1:w_half,end-w_half+1:end)).'; %upper right
paddedImIn(end-w_half+1:end,1:w_half) = double(in(end-w_half+1:end,1:w_half)).'; %lower left
paddedImIn(end-w_half+1:end,end-w_half+1:end) = rot90(flipud(double(in(end-w_half+1:end,end-w_half+1:end)))); %lower right
graph = zeros(256,1);
for k=0:255
    [i,j]=find(padImIn==k);
    for x=1:length(i)
        window = zeros(w,w);
        minRow=i(x)-(w-1)/2;
        maxRow=i(x)+(w-1)/2;
        minCol=j(x)-(w-1)/2;
        maxCol=j(x)+(w-1)/2;
        window(:,:)=paddedImIn(minRow:maxRow,minCol:maxCol);
        window = uint8(window(~isnan(window)));
        z = imhist(window);
        inputRange = 0:255;
        r = abs(inputRange-k);
        jnd = JND(T0,gamma);
        jnd = round(jnd(k+1));
        graph(1:jnd+1)=1;
        graph(jnd+2:jnd+256)= 1./(1+1.2.^(-20:234));
        graph = graph(r+1);
        z = reshape(z.*graph,1,1,256);
        sketch(i(x)-w_half,j(x)-w_half)=sum(z,3)/(w^2);
    end
end
significance = sketch;
[~, remap] = newHistEq(in);
remap = double(remap);
inputRange = (0:255).';
enhancement = remap - (inputRange+1);
out = double(in);
% figure
for intensity=0:255
    idx = find(in==intensity);
    out(idx) = out(idx) + (significance(idx).*enhancement(intensity+1));
end
out = uint8(out);
% imshow(out)
a = 1-significance;
b = double(in);
for intensity=0:255
    idx = find(in==intensity);
    b(idx) = enhancement(intensity+1);
end
c = b.*a;
C = c;
d = imgaussfilt(C,5,'FilterSize',15);
e =double(out) + d;
% figure
out = uint8(e);
% imshow(out)
