clear all
close all

fs = 8000;
dt = 1/fs;
stoptime = 0.25;
t = (0:dt:stoptime-dt)'; %column vector
M = 256;
%%sinewave:
fc = 60; %hertz
x = cos(2*pi*fc*t);
%add noise by voicebox
target_snr = 10;
s = v_addnoise(x,fs,target_snr); % degraded signal, s
n = x - s;
%est PSD by cpsd
Pss = cpsd(s,s,M);
Pxs = cpsd(x,s,M);
Pnn = cpsd(n,n,M);
%Compute Wiener filter
HH = Pxs/Pss;
HH = HH * exp(-1i*2*pi/length(HH)*length(HH)*floor(length(HH)/2));  %shift for causal filter
hh = ifft(HH);

%compute PSD using periodogram 
Ss = periodogram(s,rectwin(length(s)),length(s),fs);
Nn = periodogram(n,rectwin(length(n)),length(n),fs);
%Compute Wiener filter using different transfer function found
HH1 = Ss/(Ss+Nn);
hh1 = ifft(HH1);

%%apply wiener filters to signal
y = conv(s, hh(1:end, 3), 'same'); 
%y1 = conv(s,hh1,'same');




%%plot Corss PSDs
%For real x & y, cpsd returns a one-sided CPSD. For complex x&y, it returns a two-sided CPSD.
figure;
plot(20*log10(abs(.5*Pss)),'b')
hold
plot(20*log10(abs(.5*Pxs)), 'g')
legend('Pss','Pxs')
title('(Cross)PSDs')
ylabel('|H| in dB')
xlabel('Freq')

%plot single PSD using periodogram
figure;
plot(Ss, 'b')
hold
plot(Nn, 'g')
legend('Ss', 'Nn')
title('Periodogram PSDs')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

%%plot transfer function1 of wiener filter
figure;
plot(20*log10(abs(HH)))
title('Transfer func by cpsd')
zoom xon

%%plot transfer functin2 of wiener filter
figure;
plot(20*log10(abs(HH1)))
title('Transfer func by pediodogram')
zoom xon



% plot clean signal vs time:
figure;
plot(s);
xlabel('n');
legend('noisy');
zoom xon;

% plot signals
