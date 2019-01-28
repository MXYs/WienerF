close all;
clear all;

[y,Fs] = audioread('sp15.wav');
% siz = wavread('sp07.wav','size'); %siz = [samples channels]
% length_in_second = siz(1)/Fs;
N = length(y);
slength = N/Fs; % total time of sudio

% unknown system
h = rand(1, 64); % (1x64) vector

% input signal u(n)
%u = randn(1024,1); % 1024x1 vector (standard normal distribution)
u = y;

% desired response d(n)
d = filter(h, 1, u); % denominator = 1

% Generate noisy signal with voice box
fs = Fs;
snr = 0;
z = v_addnoise(u,fs,snr);

N = length(h);
M = N;
%R = u.*u';
%p = xcorr(u,d,length(u));

rxx = xcorr(z);
Rxx = zeros(N);

% temp=toeplitz(rxx);
for i = 1:N                             
    for j = 1:N
        Rxx(i,j) = rxx(N+i-j);
    end
end
rxd = xcorr(d,z);                      
Rxd = rxd(N:N+M-1);
hopt = Rxx\Rxd;

% de=conv(hopt,noisy);
de = zeros(1,N);
for n = 1:N
   for i = 1:n-1
       de(n) = de(n) + hopt(i)*z(n-i);
   end
end
clearvars i j n
de(1:2) = z(1:2);

ems = sum(z.^2) - Rxd.*hopt;
error = de-d;

% Annalysis... Compare desired response and est response
d_w = filter(hopt,1,z);

% Evaluation : input SNR (10dB)
noise = z - u;
snr_in = var(u)/ var(noise);
snr_in = 10*log(snr_in);
snr_out = var(d_w-noise)/var(noise);
snr_out = 10*log(snr_out);
val = npm(h,hopt');
log_10_npm = 10*log10(val);
figure
plot(d)
hold on
plot(d_w)
legend('with desired response', 'with estimated response')


figure
subplot(3,1,1);
plot(z)
title('observed input')

subplot(3,1,2);
plot(d_w)
title('filtered/enhanced')

subplot(3,1,3);
plot(d,'k-')
title('desired')

figure
v_spgrambw(z,Fs,'pJcw')
title('observed speech');
figure
v_spgrambw(d_w,Fs,'pJcw')
title('enhanced speech');
figure
v_spgrambw(d,Fs,'pJcw')
title('desired speech');
%audiowrite('filtedsound.wav',10*d_w,fs);