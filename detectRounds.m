clear

filepath='http://192.168.1.10:8080/shot.jpg';
eccthresh=0.6;
posX=0;
posY=0;

%while(1)
    posX=0;
    posY=0;
    IMG=imread(filepath);
    E=entropyfilt(IMG);
    Eim=mat2gray(E);
    BW=im2bw(Eim,.8);
    BWao=bwareaopen(BW,2000);
    nhood=true(9);
    closeBWao=imclose(BWao,nhood);
    mask=imfill(closeBWao,'holes');


    

    stats = regionprops(mask,'Area','Centroid','Eccentricity');
 for k = 1:length(stats)

      % mark objects above the threshold with a black circle
      if stats(k).Eccentricity < eccthresh
        centroid = stats(k).Centroid;
        posX=centroid(1);
        posY=centroid(2);

      end
    end
   

    
       posX
       posY
%end
%marked=insertShape(IMG,'circle',[posX posY 10],'LineWidth',10);
%imshow(marked);