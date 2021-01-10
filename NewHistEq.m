function [out, remap] = NewHistEq(in)

hist = imhist(in);
PDF = hist./sum(hist);
inputRange = 0:255;
inputRange = inputRange.';
mean = ceil(sum(inputRange.*PDF));
meanIdx = mean+1;

CDFdark = flipud(cumsum(flipud(PDF(1:meanIdx))));
CDFdark = max(CDFdark)-CDFdark;
CDFdark = CDFdark/max(CDFdark)/2;

CDFbright = cumsum(PDF(meanIdx+1:end)) + (PDF(meanIdx)+PDF(meanIdx+1))/2;
CDFbright = CDFbright/max(CDFbright)/2;
CDFbright = CDFbright + 0.5;

CDF = [CDFdark;CDFbright];
remap = uint8(CDF.*255);

out = in;
for intensity = 0:255
    out(in==intensity+1)=remap(intensity+1);
end

