IMG=imread('ball.jpg');

[x,y,z]=size(IMG);

result=zeros(x,y,z);

%Belirtilmek istenen objenin yaklaþýk rengini rgb cinsinden gir
red=140;
green=90;
blue=90;
 
tolerance=20;

%Loop the image. If a pixel is near the wanted color, make it black. Set
%it to white otherwise
for i=1:x
    for j=1:y
        %check Red
        if (abs(IMG(i,j,1)-red)<tolerance) & (abs(IMG(i,j,2)-green)<tolerance) & (abs(IMG(i,j,3)-blue)<tolerance)
            result(i,j,1)=255;
            result(i,j,2)=255;
            result(i,j,3)=255;
        else
            result(i,j,1)=0;
            result(i,j,2)=0;
            result(i,j,3)=0;
        end
    end
end

bitImage=im2bw(result,0.5);
