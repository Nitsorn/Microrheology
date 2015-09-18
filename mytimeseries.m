function [x,y,z]=mytimeseries(N,f,dia,tp,x0,v0)
% Returns x y and z coordinates (m) given:
% N = number of frames
% f = frame rate (Hz)
% d = particle diameter
% tp = temperature parameter
% x0 = initial position (m)
% v0 = drift velocity (m/s)
% Call: [x,y,z]=mytimeseries(1000,10,200e-9,0.5,[0 0 0],0.1e-6*[0 0 -1])
 
dt=1/f;
delta=dia*dt*tp;
 
x=zeros(N,1);
y=zeros(N,1);
z=zeros(N,1);
 
x(1)=x0(1);
y(1)=x0(2);
z(1)=x0(3);
 
 for i=2:N   
            dx=delta*normrnd(0,1)+v0(1)*dt;
            dy=delta*normrnd(0,1)+v0(2)*dt;
            dz=v0(3)*dt;
 
            x(i)=x(i-1)+dx; 
            y(i)=y(i-1)+dy;
            z(i)=z(i-1)+dz; 
             
 end
 
if 1==0
figure(1)
plot(x,'-bo'); hold on
plot(y,'-ro'); hold on
plot(z,'-go'); hold on
ylabel('position (m)')
xlabel('frame')
end

function [x,y,z]=mytimeseriesstraight(Lx,Ly,N,x0)
% Returns x y and z coordinates (m) given:
% N = number of frames
% f = frame rate (Hz)
% d = particle diameter
% sf = scale factor (-)
% x0 = initial position (m)
% v0 = drift velocity (m/s)
  
x=zeros(N,1);
y=zeros(N,1).*(-Ly/4);
z=zeros(N,1);
 
x(1)=x0(1);
y(1)=x0(2);
z(1)=x0(3);
 
 for i=2:N   
            dx=0;
            dy=(Ly/2)/N;
            dz=0;
 
            x(i)=x(i-1)+dx; 
            y(i)=y(i-1)+dy;
            z(i)=z(i-1)+dz; 
             
 end
 
if 1==0
figure(1)
plot(x,'-bo'); hold on
plot(y,'-ro'); hold on
plot(z,'-go'); hold on
ylabel('position (m)')
xlabel('frame')
end

function writetif(Ecc,i)


Ecc = (Ecc - min(min(Ecc))) / (max(max(Ecc)) - min(min(Ecc)));

if numel(num2str(i))==1
    imwrite(Ecc,['0000',num2str(i),'.tif']);
elseif numel(num2str(i))==2
    imwrite(Ecc,['000',num2str(i),'.tif']);
elseif numel(num2str(i))==3
    imwrite(Ecc,['00',num2str(i),'.tif']);    
else
    imwrite(Ecc,['0',num2str(i),'.tif']);
end


return