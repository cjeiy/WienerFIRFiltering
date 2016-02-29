%% Preparatory Task
%System corrensponding to variance = 0
%h(0)    = 1
%h(n=!0) = 0
pic = imread('kth.jpg');
[KEY,CPIC] = encoder(pic);
decoded_pic = decoder(KEY,CPIC);

image(decoded_pic)

%%
%Create h(n) corresponding to loss over wireless network
%h(0)          = 1
%h(1//2)       = 0.7
%h(n!=(0,1,2)) = 0
pic2 = imread('kth.jpg');
[KEY2,CPIC2] = encoder(pic2);
n = length(KEY2);
u = zeros(n,1);
u(1)=1; u(2)=0.7; u(3)=0.7;
u=u';
KEY2=KEY2';
KEY_WIRELESS = conv(KEY2,u,'full');
KEY_WIRELESS = KEY_WIRELESS(1:n);
KEY_WIRELESS = sign(KEY_WIRELESS);



decoded_pic2= decoder(KEY_WIRELESS,CPIC2);
image(decoded_pic2)

%%

clc, clear all, close all;

load training
load spydata

MSE_BEST = inf;

N=31;
for n = 1:N
   Y = received(1:n+1);
   X = training(1:n+1);
   
   r_Y = xcorr(Y,Y')
   %xcorr(Y, Y')
   R_Y = toeplitz(r_Y(n+1:2*n+1))

   r_XY = xcorr(X,Y)

   h_FIR = mldivide(R_Y,r_XY(n+1:2*n+1))

   X_hat = h_FIR'*Y;
   
   MSE = (sum((training(1:32)-mean(filter(h_FIR,1,received(1:32)))).^2));
   fel(n) = MSE
   if MSE<MSE_BEST 
       MSE_BEST = MSE;
       best_h = h_FIR;
       best_n = n;
   end

end

MSE_BEST
best_h
best_n
key = conv(best_h,received);
key=sign(key(1:end-best_n));
decoded_pic2= decoder(key,cPic);
figure(3)
image(decoded_pic2)

%%
   h_FIR = R_Y(1:n,1:n)\r_XY(1:n);
   
   X_hat = h_FIR'*Y;
   
   MSE = sum((X_hat-X)^2)
   MSE1 = mean((X_hat-X)^2)
   
   
   
   
   


end
