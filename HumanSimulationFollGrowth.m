%set specifications for simulations a call calculation and solving of the ODE
%needed:'Model28_Parameter.dat', 'InitialValues.txt'

function HumanSimulationFollGrowth
%
%-----------------------------------------------------------------------
%
runnum        = 1;
%save simulation results
ShowStuff     = 1;
SaveStuff     = 0;
DirStuff      = 'Results_LutStim/'; 
%select type of simulation 
NormalCycle   = 1;
LutStim       = 0;
LateFollPhase = 0; 
%
%-----------------------------------------------------------------------
%% Select Model
case_name = "NEW_PMOS"; %OLD_NORMAL, OLD_PMOS, NEW_NORMAL, NEW_PMOS
%% Select Model-Specific parameters
switch upper(case_name)
    case 'OLD_NORMAL'
        % Simulation time
        te_ = 30 * 3;

        % Parameters for growth equation
        v_      = 2;
        gamma_  = 0.035/2;
        xi_     = 25;
        mu_     = 1;
        k_      = 0.09/((xi_)^v_);
        rho_    = 0.01;
        Folmax_ = 22;

        % Parameters for Poisson distribution
        is_seed_set_ = true;
        rng_seednumber_ = 15;
        lambda_ = 9/15;
        intervallPoi_ = 0.25;

        % Simulation settings
        Tovu_ = -14 * 2;
        ylim_values_ = [0, 26];
        xlim_values_ = [0, 30 * 3];
    case 'OLD_PMOS'
        % Simulation time
        te_ = 30 * 12;

        % Parameters for growth equation
        v_      = 2;
        gamma_  = 0.035/2;
        xi_     = 25;
        mu_     = 0.017/0.09;
        k_      = 0.09/((xi_)^v_);
        rho_    = 0.01;
        Folmax_ = 22;

        % Parameters for Poisson distribution
        is_seed_set_ = true;
        rng_seednumber_ = 15;
        lambda_ = 9/15;
        intervallPoi_ = 0.25;

        % Simulation settings
        Tovu_ = -14 * 2 * 24;
        ylim_values_ = [0, 26];
        xlim_values_ = [0, 30 * 12];

    case 'NEW_NORMAL'

        % Simulation time
        te_ = 30 * 3;

        % Parameters for growth equation
        v_      = 2;
        gamma_  = 0.035/2;
        xi_     = 25;
        mu_     = 1;
        k_      = 0.17/((xi_)^v_);
        rho_    = 0.01;
        Folmax_ = 22;

        % Parameters for Poisson distribution
        is_seed_set_ = true;
        rng_seednumber_ = 22;
        lambda_ = 3/15;
        intervallPoi_ = 0.25;

        % Simulation settings
        Tovu_ = -14 * 2;
        ylim_values_ = [0, 26];
        xlim_values_ = [0, 30 * 3];
    case 'NEW_PMOS'

        % Simulation time
        te_ = 30 * 12;

        % Parameters for growth equation
        v_      = 2;
        gamma_  = 0.035/2;
        xi_     = 25;
        mu_     = 0.1;
        k_      = 0.17/((xi_)^v_);
        rho_    = 0.01;
        Folmax_ = 22;

        % Parameters for Poisson distribution
        is_seed_set_ = true;
        rng_seednumber_ = 653;
        lambda_ = 3/15;
        intervallPoi_ = 0.25;

        % Simulation settings
        Tovu_ = -14 * 2 * 24;
        ylim_values_ = [0, 26];
        xlim_values_ = [0, 30 * 12];


    otherwise
        error('Unknown model: %s', model);

end
% 
for i = 1:runnum
%
%-----------------------------------------------------------------------
%   
%integration time beginning and end
    tb = 0;
    te = te_;
%
%-----------------------------------------------------------------------
% 
% several parameter vectors (function see ReadMe)
para=[];
    para(1) = 0;                %ODE function called to test(0) or not (1)
    para(2) = 54;               %number of extra-equations 
    para(3) = 0;
    para(4) = 0;           
    para(5) = 0;   
    para(6) = 0;    
    para(7) = 6/10;             %mean for FSH Sensitivity 
    para(8) = 0.55*para(7);     %std.deviation for FSH Sensitivity %0.55
    para(9) = 25;               %threshold LH concentration for ovulation    
    para(10) = 5;               %big but not ovulated follicle livetime
    para=para';

%parameter for growth equation
    v       = v_;                      %fractal dimension 
    gamma   = gamma_;                %growth rate %0.035/2
    xi      = xi_;                     %max. diameter of follicles 
    mu      = mu_;                      %proportion of self harm  
    k       = k_;           %strength of competition %0.065
    rho     = rho_;                   %rate of decline
    Folmax  = Folmax_;                     %min. ovulation size %20
paraOde = [ v; gamma; xi; mu; k; rho; Folmax];

% Set parameters for creating random follicles
is_seed_set = is_seed_set_;
rng_seed_number = rng_seednumber_; 
rng_generator = 'twister';

%parameters for poisson distribution
lambda          = lambda_ ;           %#Follikels/days
intervallPoi    = intervallPoi_;            %intervall per day in which follicles appear
paraPoi = [lambda; intervallPoi];
  
%load parameter for ODE
file = 'Parameter.dat';
Par=importdata(file,' ');
%
%-----------------------------------------------------------------------
%
%load initial values
file = 'InitialValues.txt';
delimiterIn=';';
headerlinesIn=0;
yInitial=importdata(file,delimiterIn,headerlinesIn);
%
%-----------------------------------------------------------------------
%
%initial follicles
y0Foll = 4;                                                 
StartValues = [y0Foll; yInitial]';

if (is_seed_set)
    rng(rng_seed_number, rng_generator);
end

[FSHVec, StartVec] = CreateFollicles(para,paraPoi,tb,te);
%
%-----------------------------------------------------------------------
%
%Normal Cycle
%
%-----------------------------------------------------------------------
%
if NormalCycle
    Simulation_NormalCycle(case_name,Tovu_,xlim_values_,ylim_values_,para,paraPoi,paraOde,Par,tb,te,StartValues,StartVec,FSHVec,ShowStuff,SaveStuff,DirStuff);
end
%
%-----------------------------------------------------------------------
%
%Luteal Phase Stimulation: FSH/LH administartion (Menopur)
%
%-----------------------------------------------------------------------
%
if (LutStim)
    Par(599)=200;          %start of dosing - fiktive Zeitpunkte, werde in der Simulation gesetzt
    Par(598)=Par(599)+10;   %end time of dosing       
    Par(579)=13.387/2.65;   %D FSH
    Par(578)=9.87;          %beta FSH
    Par(577)=0.42;          %clearance rate FSH
    Par(576)=2.14;          %D LH
    Par(575)=6.04;          %beta LH 
    Par(574)=3.199;         %clearance rate LH
    Par(596) = 0;
    Simulate_LutStim(para,paraPoi,paraOde,Par,tb,te,StartValues,StartVec,FSHVec,ShowStuff,SaveStuff,DirStuff);
end
%
%-----------------------------------------------------------------------
%
%Late Folliculare Phase Phase Stimulation: FSH/LH administartion (Menopur)
%
%-----------------------------------------------------------------------
%
if (LateFollPhase)
    Par(599)=200;          %start of dosing - fiktive Zeitpunkte, werde in der Simulation gesetzt
    Par(598)=Par(599)+10;   %end time of dosing       
    Par(579)=13.387/4;      %D FSH
    Par(578)=9.87;          %beta FSH
    Par(577)=0.42;          %clearance rate FSH
    Par(576)=2.14;          %D LH
    Par(575)=6.04;          %beta LH 
    Par(574)=3.199;         %clearance rate LH
    Par(596) = 0;
    Simulate_LateFollPhase(para,paraPoi,paraOde,Par,tb,te,StartValues,StartVec,FSHVec,ShowStuff,SaveStuff,DirStuff);
end
%
%-----------------------------------------------------------------------
%
end
