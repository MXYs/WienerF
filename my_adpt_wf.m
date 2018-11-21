clear all
close all


fs = 10;
t = (0:1/fs:10)'; %column vector
t = t(1:100);
disp(t);
target_snr = 10; %dB

x = sin(t); %audio signal -  clean sine wave, x
s = v_addnoise(x,fs,target_snr); % degraded signal, s
n = s - x; %noise signal, n
%{
figure
plot(t,[x s])
legend('Original Signal', 'Signal with noise')
%}
N = length(s);


x_psd = fft2(x);    %clean signal PSD
n_psd = fft(n);     %noise PSD = variance of the noise
s_psd = fft2(s);    %original signal PSD



%time domain
%small segment where we assume s to be stationary:
N = length(s);
s = s(1:N/2+1);
n = n(1:N/2+1);
smean = mean(s);
svar = var(s);
nvar = var(n);
omega_n = (n-mean(n))/sqrt(var(n));
s_n = smean + svar*omega_n; %segmented noisy sig
%within this small segment, the winer filter trans fn is:
H_w = svar/(svar-nvar);
%h_n = H_w*delta;
s_enhanced = smean + H_w*(s_n - smean);
disp(N);
figure
plot(t,[s s_enhanced])
legend('degraded Signal', 'Signal enhanced')
