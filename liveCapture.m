clear

url='http://161.9.11.49:8080/shot.jpg';

posX=0;
posY=0;
angle=0;
area=0;

loopCount=200;
data=zeros(loopCount);
% redLow=100;
% redHigh=255;
% 
% greenLow=50;
% greenHigh=150;
% 

% blueLow=50;
% blueHigh=200;

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
    BW=im2bw(Blurred,.5);
    
    
    edged=edge(BW,'Prewitt');
    se=strel('disk',30);
    BWclosed=imclose(edged,se); %Bu sayede ayr�k pixellerin birle�tirilmesi ama�lan�yor
    BWfilled=imfill(BWclosed,'holes');
    
    
    BWao=bwareaopen(BWfilled,1000); %�zole pixelleri temizle
    BWfinal=imclearborder(BWao);
    
    
    stats=regionprops(BWfinal,'Eccentricity','Centroid','Area');
    
    if length(stats) == 1
        %�f there is only 1 region, don't loop through them all
        centroid = stats.Centroid;
        posX=centroid(1);
        posY=height-centroid(2);
        area=stats.Area;
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
    %angle
    
    data(i)=struct('posX',posX,'posY',posY,'angle',angle,'area',area);
    
    %marked=insertMarker(BWao,[posX posY],'o','color','black','size',20);
    imshow(BW);
   
end
    
