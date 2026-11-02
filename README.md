# GynCycle_PMOS (Fork)

This repository is a public fork of the original [SoFiwork/GynCycle](https://github.com/SoFiwork/GynCycle) repository, adapted to model **Polycystic Ovary Syndrome (PMOS)** dynamics.

## 🛠️ PMOS Model Extensions

Modified MATLAB files for PMOS simulation:
* **`HumanSimulationFollGrowth.m`**
* **`Simulation_NormalCycle.m`**
* **`testfun_NormalCycle.m`**

## ⚙️ Additional MATLAB Code Fix

To get the code running correctly, an additional modification is required in the **`CreateFollicles.m`** file.

The MATLAB built-in function `size` needs to be replaced with `numel` when determining the number of elements in the `timevec` array.

**Original code:**

```matlab
%create poisson distributed starting times for each foll
fileID = fopen('StartTimesPoiss.txt','w+');
fprintf(fileID,'Start time\n');
TotIntervall = te-tb;
timevec=poissonproc(paraPoi(1),[tb,te]); 
arraysize=size(timevec);
for i=1:arraysize
    fprintf(fileID,'%f \n',timevec(i));
end
fclose(fileID);
```

**Updated code:**
```matlab
%create poisson distributed starting times for each foll
fileID = fopen('StartTimesPoiss.txt','w+');
fprintf(fileID,'Start time\n');
TotIntervall = te-tb;
timevec=poissonproc(paraPoi(1),[tb,te]); 

% 'numel' instead of 'size' to count the number of elements in an array
% arraysize=size(timevec);
arraysize=numel(timevec);

for i=1:arraysize
    fprintf(fileID,'%f \n',timevec(i));
end
fclose(fileID);
```
**Explanation:**
The MATLAB function size returns the dimensions of an array, whereas numel returns the total number of elements. Since the for loop needs to iterate over every element of timevec, numel is the appropriate function here. This prevents potential errors when timevec contains multiple elements.


# 📚 Original GynCycle Documentation

For the complete original documentation, installation instructions, usage guidelines, and citations, please refer to the original repository at {Link: GitHub https://github.com/SoFiwork/GynCycle}.
