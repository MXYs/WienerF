t = (0:0.1:10)'; %1/Fs = 0.1 ->Fs=10
x = sin(t);
y = awgn(x,10,'measured');
n = y - x;
plot(t,[x y n])
%plot(t,y)
legend('Original Signal', 'Signal with AWGN', 'AWGN')
%{
N = length(y);
ydft = fft(y);
ydft = ydft(1:N/2+1);
psdy = (1/(10*N)) * abs(ydft).^2;
psdy(2:end-1) = 2*psdy(2:end-1);
freq = 0 : 10/length(y) :10/2;
plot(freq, 10*log10(psdy))
grid on
title('periodogram using fft')
xlabel('frequency (hz)')
ylabel('power/freq(db/hz)')
%}

