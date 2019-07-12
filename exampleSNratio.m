close all

quantizebits = 14;
base_freq = 50e6;

target = 1e6;
funcyboi = @(t) sin(t.*2.*pi.*target);

best_divisor = 0;
best_multipler = 0;
best_error = -1;

muliplierlist=[33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64];

for mult = flip(muliplierlist)
    divis = round(base_freq*mult/target);
    if(divis>0)
        yield = base_freq*mult/divis;
        error = abs((yield-target)/target);
        if best_error < 0 || error < best_error
            best_error = error;
            best_multipler = mult;
            best_divisor = divis;
        end
        if error == 0
            break
        end
    end
end

t_fast = linspace(0,1/target,best_multipler*base_freq/target*100);
t_slow = linspace(0,1/target,best_multipler*base_freq/target);
x1=funcyboi(t_fast);
x2=round(funcyboi(t_slow).*2.^quantizebits)./2.^quantizebits;
x2_oversampled = interp1(t_slow,x2,t_fast,'previous');
error = x1-x2_oversampled;

figure(1)
hold on
plot(t_fast,x1)
plot(t_fast,x2_oversampled)
hold off

Psignal = rms(x1);
Perror =rms(error);
number_of_pnts = best_multipler*base_freq/target
SNR = 10*log10(Psignal/Perror)