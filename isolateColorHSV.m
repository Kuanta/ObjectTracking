function [ isolatedIMG ] = isolateColorHSV( IMG , hueLow ,hueHigh, satLow ,satHigh, valLow ,valHigh)
%UNTİTLED Summary of this function goes here
%   Detailed explanation goes here
    
    IMGHsv=rgb2hsv(IMG);
    
    hue=IMGHsv(:,:,1);
    sat=IMGHsv(:,:,2);
    val=IMGHsv(:,:,3);
    
    hueMask=(hue >= hueLow) & (hue <= hueHigh);
    satMask=(sat >= satLow) & (sat <= satHigh);
    valMask=(val >= valLow) & (val <= valHigh);
    maskHsv=uint8(hueMask & satMask & valMask);
    
    maskRed=maskHsv.*IMG(:,:,1);
    maskGreen=maskHsv.*IMG(:,:,2);
    maskBlue=maskHsv.*IMG(:,:,3);

    isolatedIMG=cat(3,maskRed,maskGreen,maskBlue);

end

