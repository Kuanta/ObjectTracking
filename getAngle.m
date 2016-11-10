function [ Angle ] = getAngle(x,y,w,h)
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here
    eyeX=w/2;
    eyeY=0;
    
%     if(strcmp('Landscape',type))
%     elseif(strcamp('Portrait',type))
%         eyeX=w/2;
%         eyeY=h;
%         Angle= atand(((h-y)-eyeY)/(x-eyeX))
% 
%         
%     else
%     end
    Angle=atand((y-eyeY)/(x-eyeX));

end

