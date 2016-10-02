camAdress='http://192.168.1.10:8080';
cam=ipcam(camAdress);
frame=getsnapshot(cam);
imshow(frame);
hold on;