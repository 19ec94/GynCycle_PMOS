# GynCycle_PMOS (Fork)

This repository is a public fork of the original [SoFiwork/GynCycle](https://github.com/SoFiwork/GynCycle) repository, adapted to model **Polycystic Ovary Syndrome (PMOS)** dynamics.

## 🛠️ PMOS Model Extensions

Modified MATLAB files for PMOS simulation:
* **`HumanSimulationFollGrowth.m`**
* **`Simulation_NormalCycle.m`**
* **`testfun_NormalCycle.m`**

## 🔬 Simulation Model Selection

Four different simulation cases are implemented:

| Model | Description |
|---|---|
| `OLD_NORMAL` | Original normal menstrual cycle model |
| `OLD_PMOS` | Original PMOS model |
| `NEW_NORMAL` | Updated normal menstrual cycle model |
| `NEW_PMOS` | Updated PMOS model |

The simulation model can be selected directly in **`HumanSimulationFollGrowth.m`**:

```matlab
%% Select Model
% User can choose one of the four models (OLD_NORMAL, OLD_PMOS, NEW_NORMAL, NEW_PMOS) to run the simulation.
case_name = "NEW_PMOS"; 
```
The model-specific parameters are automatically assigned using a MATLAB switch statement.

These parameters include:

- Simulation duration (te_)
- Follicle growth parameters (v_, gamma_, xi_, mu_, k_, rho_, Folmax_)
- Poisson distribution parameters (lambda_, intervallPoi_)
- Random number generator settings for reproducibility (is_seed_set_, rng_seednumber_)
- Simulation and plotting settings (Tovu_, ylim_values_, xlim_values_)

To switch between models, simply change the value of case_name. There is no need to modify the individual parameters manually.
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
