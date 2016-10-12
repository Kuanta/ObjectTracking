clear

filepath='http://192.168.1.10:8080/shot.jpg';
GaussSigma=5;

posX=0;
posY=0;

%while(1)
    
    ecc=1; %needed while looping through stats

    IMG=imread(filepath);
    [height,width,rgb]=size(IMG);
    
    %Blurred=imgaussfilt(IMG,GaussSigma);
    
    %texture filtering...
    E=stdfilt(IMG);
    Eim=mat2gray(E);
    BW=im2bw(Eim,.4);
    
    %Morphological operations...
    se=strel('disk',30);
    BWclosed=imclose(BW,se); %Bu sayede ayrýk pixellerin birleþtirilmesi amaçlanýyor
    
    BWao=bwareaopen(BWclosed,500); %Ýzole pixelleri temizle
    
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
    
%end
posX
posY