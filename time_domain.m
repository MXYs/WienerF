close all;
clear all;
clc;

% unknown system
h = rand(1, 64); % (1x64) vector

% input signal u(n)
u = randn(1024,1); % 1024x1 vector (standard normal distribution)

% desired response d(n)
d = filter(h, 1, u); % denominator = 1

% Generate noisy signal with voice box
fs = 8000;
snr = 5;
z = v_addnoise(u,fs,snr);


N = length(h);
M = N;
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

% de_x=conv(hopt_x,d_x);
de_x = zeros(1,N);
for n = 1:N
   for i = 1:n-1
       de_x(n) = de_x(n) + hopt(i)*z(n-i);
   end
end
de_x(1:2) = z(1:2);
ems_x = sum(z.^2) - Rxd.*hopt;
e_x = de_x-d;


% Annalysis... Compare desired response and est response
d_w = filter(hopt,1,z);

figure
plot(z)
hold on
plot(d_w)
hold on
plot(d)
legend('noisy','estimated response','desired')


% Comparison between input SNR (5) and output SNR
%output_snr = snr(d_w,z - u);

val = npm(h,hopt');

%{
% Create in Matlab R and p from the signals
% R: auto-cor mtx estimate of i/p u(n) for a lag of i-k
m = length(h)-1; % filter length
[X, R] = corrmtx(u,m); 
% X:(n + m)by(m + 1) Toeplitz matrix, n=length(u); R:(m + 1)by(m + 1) = X'*X.

% p: cross-correlation between input u(n-k) and desired response d(n) for a lag of -k.
[p,lags] = xcorr(u,d,m,'unbiased'); %scales the raw correlation by 1/(M-abs(lags))
p = p(N:N+M-1);

% Wiener-Hopf equations to obtain estimated filter-weights
w_opt = R\p;
est = filter(w_opt,1,z);

val = npm(h,w_opt');
%}