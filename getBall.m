%Color detection with HSV parameters for a single image

%Reading image as RGB
IMG=imread('assets/topLeft.jpg');

[height,width,rgb]=size(IMG);

%Converting RGB to HSV
IMGHsv=rgb2hsv(IMG);

%Extracting Hue, Saturation and Value
IMGHue=IMGHsv(:,:,1);
IMGSat=IMGHsv(:,:,2);
IMGVal=IMGHsv(:,:,3);

%Adjust these thresholds to get the needed colour (These are for a tennis
%ball
hueLow=0.15;
hueHigh=0.2;

satLow=0.7;
satHigh=0.99;

valueLow=0.4;
valueHigh=0.95;



hueMask=(IMGHue >= hueLow) & (IMGHue<=hueHigh);
satMask=(IMGSat >= satLow)&(IMGSat <= satHigh);
valueMask=(IMGVal >= valueLow) & (IMGVal <= valueHigh);

maskHsv=uint8(hueMask & satMask & valueMask); %uint8 is needed for the multiplication with IMG

maskRgbRed=maskHsv.*IMG(:,:,1);
maskRgbGreen=maskHsv.*IMG(:,:,2);
maskRgbBlue=maskHsv.*IMG(:,:,3);

maskRgb=cat(3,maskRgbRed,maskRgbGreen,maskRgbBlue);

%Convert RGB image to Binary
IMGBin=im2bw(maskRgb,0.3);

%Calculate the position of the ball
[centerX,centerY]=find(IMGBin);

posX=mean(centerX);
posY=mean(centerY);

%Get the angle
eyeX=width/2;
eyeY=height;

deltaX=posX-eyeX;
deltaY=abs(posY-eyeY);

angle=atan(deltaY/deltaX); %In radians
angle=(angle/pi)*180; %In degrees