function[fit]= fhd(population,Xtr)
fit=mean(abs((population*Xtr)'));
end