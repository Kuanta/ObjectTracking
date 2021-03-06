%   This script captures a round object with edge detection using IPCam
%It assumes that there aren't any other round objects around since it gets
%the one with the smallest Eccenctricity
%(For circles Ecc=0 and for lines Ecc=1)

clear

url='http://161.9.12.158:8080/shot.jpg';

%Initialize needed variables
posX=0;
posY=0;
angle=0;
area=0;

loopCount=200;

%Initialize an array of struct
data(1:loopCount)=struct('posX',0,'posY',0,'angle',0,'area',0);
% redLow=100;
% redHigh=255;
% 
% greenLow=50;
% greenHigh=150;
% 

% blueLow=50;
% blueHigh=200;

%Thresholds
hueLow=0.95;
hueHigh=1;

satLow=0.05;
satHigh=0.7;

valLow=0.5;
valHigh=0.95;

hold on

for i=1:loopCount
    
    ecc=1;
    
     IMG=imread(url);
     [height,width,rgb]=size(IMG);
     Blurred=imgaussfilt(IMG,5);
    
%     
% %RGB THRESHOLDING
%     red=IMG(:,:,1);
%     green=IMG(:,:,2);
%     blue=IMG(:,:,3);
%     
%     maskRed=(red >= redLow) & (red <= redHigh);
%     maskGreen=(green >= greenLow) & (green <= greenHigh);
%     maskBlue=(blue >= blueLow) & (blue <= blueHigh);
%     maskRgb=uint8(maskRed & maskGreen & maskBlue);
%     
%     maskRed=maskRgb.*IMG(:,:,1);
%     maskGreen=maskRgb.*IMG(:,:,2);
%     maskBlue=maskRgb.*IMG(:,:,3);
%     maskedRgb=cat(3,maskRed,maskGreen,maskBlue);


    
    maskedRgb=isolateColorHSV(IMG,hueLow,hueHigh,satLow,satHigh,valLow,valHigh);
    BW=im2bw(Blurred,.7);%Blur the image for easy processing
    
    %Edge Detection
    edged=edge(BW,'Prewitt');
    
    %Morphological  Operations
    se=strel('disk',30);
    BWclosed=imclose(edged,se); %Smoothen the image
    BWfilled=imfill(BWclosed,'holes');
    BWao=bwareaopen(BWfilled,500); %Clear the smaller pixels
    BWfinal=imclearborder(BWao);%Remove regions toching the edges
    
    %Getting info with regionprops
    stats=regionprops(BWfinal,'Eccentricity','Centroid','Area');
    
    %If there aren't any regions, remember the last data, don't change
    %anything
    if length(stats)==0
        
    %If there is only one region, get its info if its nearly round
    elseif length(stats) == 1
        if(stats.Eccentricity<ecc)
            centroid = stats.Centroid;
            posX=centroid(1);
            posY=height-centroid(2);
            area=stats.Area;
        end
        
    %More than one region
    else
        for k=1:length(stats) %loop stats
            if stats(k).Eccentricity < 0.8 & stats(k).Eccentricity <ecc
                %Get the object with the smallest eccentricity
                ecc=stats(k).Eccentricity;
                centroid = stats(k).Centroid;
                
                %If portrait...
                posX=centroid(1);
                posY=height-centroid(2);
                area=stats.Area;
                
                %If landscape
            end

        end
    end
    
    %Calculate Angle
    angle=getAngle(posX,posY,width,height);
    %posX
    %posY
    angle
    %area
    
    %Collect the data
    data(i)=struct('posX',posX,'posY',posY,'angle',angle,'area',area);
    
    %marked=insertMarker(BWao,[posX posY],'o','color','black','size',20);
    imshow(BWfinal);
   
end
    
