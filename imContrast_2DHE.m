function [out,CDF,PDF,Hist2D,LogHist2D] = imContrast_2DHE(varargin)

in = varargin{1};
if size(in,3)>1
    In = rgb2hsv(in);
    in = In(:,:,3);
    in = uint8(in.*255);
end
if nargin==1
    w = 5;
else
    w = varargin{2};
end

[row,col]=size(in);
sketchOut = zeros(256,256);
w_half = (w-1)/2;
padValue = NaN;
padImIn(w_half+1:row+w_half,w_half+1:col+w_half)=double(in);
padImIn(row+w_half+1:row+2*w_half,:)=padValue;
padImIn(:,col+w_half+1:col+2*w_half)=padValue;
padImIn(1:w_half,:)=padValue;
padImIn(:,1:w_half)=padValue;
for m=0:255
    [i,j]=find(padImIn==m);
    windows = zeros(w,w,length(i));
    for x=1:length(i)
        minRow=i(x)-(w-1)/2;
        maxRow=i(x)+(w-1)/2;
        minCol=j(x)-(w-1)/2;
        maxCol=j(x)+(w-1)/2;
        windows(:,:,x)=padImIn(minRow:maxRow,minCol:maxCol);
    end
    windows = reshape(windows,1,[]);
    windows = uint8(windows(~isnan(windows)));
    freq = imhist(windows);
    weights = 0:255;
    weights = abs(m-weights)+1;
    freq = freq.*weights.';
    sketchOut(m+1,:)=freq.';
end
Hist2D = sketchOut/sum(sum(sketchOut));
LogHist2D = log10(Hist2D);
PDF = sum(Hist2D,2);
CDF = cumsum(PDF);
CDFTarget = 0:255;
CDFTarget = CDFTarget/255;
diffTable = abs(CDF-CDFTarget);
[~,ind]=min(diffTable,[],2);
out = in;
for x=0:255
    out(in==x)= ind(x+1)-1;
end
if exist('In','var')
    out = double(out)./255;
    In(:,:,3) = out;
    out = hsv2rgb(In);
end