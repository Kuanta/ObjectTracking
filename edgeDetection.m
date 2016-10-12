clear

filepath='http://192.168.1.10:8080/shot.jpg';

posX=0;
posY=0;

hueLow=0.07;
hueHigh=0.3;

satLow=0;
satHigh=0.55;

valLow=0.5;
valHigh=0.7;

while(1)
    
    ecc=1;
    
     IMG=imread(filepath);
     [height,width,rgb]=size(IMG);
     Blurred=imgaussfilt(IMG,5);
%     IMGHsv=rgb2hsv(IMG);
%     
%     hue=IMGHsv(:,:,1);
%     sat=IMGHsv(:,:,2);
%     val=IMGHsv(:,:,3);
%     
%     hueMask=(hue >= hueLow) & (hue <= hueHigh);
%     satMask=(sat >= satLow) & (sat <= satHigh);
%     valMask=(val >= valLow) & (val <= valHigh);
%     maskHsv=uint8(hueMask & satMask & valMask);
%     
%     maskRed=maskHsv.*IMG(:,:,1);
%     maskGreen=maskHsv.*IMG(:,:,2);
%     maskBlue=maskHsv.*IMG(:,:,3);
% 
%     maskedRgb=cat(3,maskRed,maskGreen,maskBlue);
    
    BW=im2bw(Blurred,.5);
    
    edged=edge(BW,'Roberts');
    se=strel('disk',30);
    BWclosed=imclose(edged,se); %Bu sayede ayrýk pixellerin birleþtirilmesi amaçlanýyor
    BWfilled=imfill(BWclosed,'holes');
    
    
    BWao=bwareaopen(BWfilled,500); %Ýzole pixelleri temizle
    
    stats=regionprops(BWao,'Eccentricity','Centroid');
    
    if length(stats) == 1
        %ýf there is only 1 region, don't loop through them all
        centroid = stats.Centroid;
        posX=centroid(1);
        posY=centroid(2);
    else
        for k=1:length(stats) %loop stats
            if stats(k).Eccentricity < 0.8 & stats(k).Eccentricity <ecc
                %Get the object with the smallest eccentricity
                ecc=stats(k).Eccentricity;
                centroid = stats(k).Centroid;
                
                %If portrait...
                posX=centroid(1);
                posY=height-centroid(2);
                
                %If landscape
            end

        end
    end
    posX
    posY
end
    
