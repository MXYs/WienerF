clc; close all; clear all;
[y,Fs] = audioread('sp11.wav');

% unknown system
h = rand(1, 64); %returns a 1-by-64 vector

% clean input signal u(n)
%u = randn(1024,1); % returns 1024-by-1 vector (standard normal distribution)
u = y;

% desired response d(n)
d = filter(h, 1, u); % denominator = 1


% Add white additive gausiian noise to u(n)
fs = Fs; %8000; 
snr = 5;
z = v_addnoise(u,fs,snr); % VoiceBox api 
%z2 = awgn(u,snr); 

% noise 
n = z - u;

%compute PSD using periodogram 
Ss = periodogram(u,hamming(length(u)),length(u),fs);
Nn = periodogram(n,hamming(length(n)),length(n),fs);
HH = Ss/(Ss+Nn);

Pss = pwelch(u);
Pnn = pwelch(n);
H = Pss/(Pss+Pnn);
%recursive noise est
%Pn(w,k) = alpha*Pn(w,k-1) + (1-alpha)*Py(w,k);


n = 2^nextpow2(length(z));
Z = fftshift(z);
Z = Z(1:length(z)/2+1);
Y = H*Z(1:length(H))';

y = ifftshift(Y);
figure
v_spgrambw(y,Fs,'pJcw')
figure
v_spgrambw(z,Fs,'pJcw')

figure
subplot(2,1,1);
plot(z)
title('noisy')
subplot(2,1,2);
plot(y)
title('filtered signal')

%{
% PSDs using Welch technique. segments and Hamming window of length m.
m = length(h)*4+1;

%{
% transfer function by cross psd
P_ux = cpsd(u,x2,rectwin(m));
P_xx = pwelch(x2,rectwin(m));
H = P_ux/P_xx;

X_m = fft(x2,m);
Y_m = H*X_m;
y = ifft(Y_m);

figure
plot(1:length(y), y)
hold on
plot(x2(1:m))
hold on
plot(u(1:m))
legend('filtered','noisy','clean')
%}

%{
%transfer functionusing SNR
H3 = input_SNR/(1+input_SNR);
X_m = fft(x2,m); 
Y = H3*X_m;
y = ifft(Y);
% plot to visule filter effects
Gain = 10;
y = Gain.*y;
figure
plot(1:length(y),y)
hold on
plot(x2(1:m))
hold on
plot(u(1:m))
legend('filtered ', 'x2','clean')
%}

figure
plot(input_SNR(1:50),'x')
hold on
plot(output_SNR(1:50),'.')
legend('input SNR', 'output SNR')

%}

%{
% calculating snr in freq domain
N               = 8192; % FFT length
leak            = 50; 
% considering a leakage of signal energy to 50 bins on either side of major freq component

fft_s           = fft(inptSignal,N); % analysing freq spectrum
abs_fft_s       = abs(fft_s);

[~,p]           = max(abs_fft_s(1:N/2));
% Finding the peak in the freq spectrum

sigpos          = [p-leak:p+leak N-p-leak:N-p+leak];
% finding the bins corresponding to the signal around the major peak
% including leakage

sig_pow         = sum(abs_fft_s(sigpos)); % signal power = sum of magnitudes of bins conrresponding to signal
abs_fft_s([sigpos]) = 0; % making all bins corresponding to signal zero:==> what ever that remains is noise 
noise_pow       = sum(abs_fft_s); % sum of rest of componenents == noise power

SNR             = 10*log10(sig_pow/noise_pow);
%}