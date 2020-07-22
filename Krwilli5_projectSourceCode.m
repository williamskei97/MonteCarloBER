% Code by Keith Williams
% Written Fall Semester, 2019
% ECE 514, Random Processes
clear
clc
rng(848, 'twister'); % intialize rng
m = 100; % number of trials
n = 100; % number of received bits per trial, change for different results
BER = 0.5*erfc(sqrt(0.5)); % the true bit-error rate, as defined by project
% outline
TVar = BER*(1-BER); % the known variance of bit-error rate, viewing BER as 
% a Bernoulli Distribution
TStd = sqrt(TVar); % the known std dev for BER
z = 1; % table value needed for 68.3% confidence interval
ylimits = [0,0.6];
xlimits = [0,11];
TContain = zeros(1,m);
SContain = zeros(1,m);
for ii = 1:m
    trials(ii).R = zeros(1,n);
    trials(ii).Xi = zeros(1,n);
    for jj = 1:n
        trials(ii).R(jj) = -1 + randn(1,1); % generate received bit values
        if trials(ii).R(jj) >= 0 % if R bit value is greater than zero, bit
            % error is present
            trials(ii).Xi(jj) = 1; % if bit error is present, set Xi equal 
            % to zero
        else
        end
        
    end
    trials(ii).M = sum(trials(ii).Xi)/n; % get the trial BER using formula 
    % derived in class
    trials(ii).SampleV = n/(n-1)*(trials(ii).M*(1 - trials(ii).M)); % get 
    % sample variance
    trials(ii).SStd = sqrt(trials(ii).SampleV); % get the sample standard 
    % deviation
    trials(ii).SLowLim = trials(ii).M - (z*trials(ii).SStd/sqrt(n)); 
    % upper limit of confidence interval, sample v
    trials(ii).SUpLim = trials(ii).M + (z*trials(ii).SStd/sqrt(n)); 
    % lower limit of confidence interval, sample v
    trials(ii).TLowLim = trials(ii).M - (z*TStd/sqrt(n)); 
    % upper limit, known var
    trials(ii).TUpLim = trials(ii).M + (z*TStd/sqrt(n)); 
    % lower limit, known var
    if trials(ii).SLowLim < BER && BER < trials(ii).SUpLim 
        % method for counting trials with CI containing true BER
        SContain(ii) = 1; % if the true BER is within the limits, count it
    else
        SContain(ii) = 0; % do not count otherwise
    end
    if trials(ii).TLowLim < BER && BER < trials(ii).TUpLim
        TContain(ii) = 1; % if the true BER is within limits, count it
    else
        TContain(ii) = 0; % do not count otherwise
    end
    % these if statements do not count trials with 0 mean as "within CI
    % limits"
end
SP = sum(SContain)/m; % find fraction of trials with CI containing the true
% BER, sample variance
TP = sum(TContain)/m; % find fraction of trials with CI containing the true
% BER, known variance

% plot generation
titleStringS = ...
    ['Confidence Intervals of First 10 trials, Sample Var, n = ',...
    num2str(n)];
titleStringT = ...
    ['Confidence Intervals of First 10 trials, Known Var, n = ',...
    num2str(n)];
x = 1:1:10; % trial numbers for plots
slowlimits = zeros(1,10);
suplimits = zeros(1,10);
tlowlimits = zeros(1,10);
tuplimits = zeros(1,10);
Mvals = zeros(1,10);
TrueMean = BER * ones(1,10);

for kk = 1:10
    slowlimits(kk) = trials(kk).SLowLim;
    suplimits(kk) = trials(kk).SUpLim;
    Mvals(kk) = trials(kk).M;
    tlowlimits(kk) = trials(kk).TLowLim;
    tuplimits(kk) = trials(kk).TUpLim;
end

% sample variance CI plots
hold
plot(x, slowlimits, "v",'Color','b','linewidth',1.5,'MarkerSize',14)
plot(x, suplimits, "^",'Color','b','linewidth',1.5,'MarkerSize',14)
plot(x, Mvals, "x",'Color','b','linewidth',1.5,'MarkerSize',14)
plot(x, TrueMean, "*",'Color','r','linewidth',2,'MarkerSize',14)
xlim(xlimits);
ylim(ylimits);
ax = gca;
ax.FontSize = 18;
ylabel({'Bit-Error Rates'},'FontWeight','bold','FontSize',20);
grid on
xlabel({'Trial Number'},'FontWeight','bold','FontSize',20);
title(titleStringS,'FontWeight','bold','FontSize',20);
lgd1 = legend({'lower limit','upper limit','trial mean','true mean'},...
    'FontSize',18);
xticks(x);

% known variance CI plots
figure
hold
plot(x, tlowlimits, "v",'Color','b','linewidth',1.5,'MarkerSize',14)
plot(x, tuplimits, "^",'Color','b','linewidth',1.5,'MarkerSize',14)
plot(x, Mvals, "x",'Color','b','linewidth',1.5,'MarkerSize',14)
plot(x, TrueMean, "*",'Color','r','linewidth',2,'MarkerSize',14)
xlim(xlimits);
ylim(ylimits);
ax = gca;
ax.FontSize = 18;
ylabel({'Bit-Error Rates'},'FontWeight','bold','FontSize',20);
grid on
xlabel({'Trial Number'},'FontWeight','bold','FontSize',20);
title(titleStringT,'FontWeight','bold','FontSize',20);
lgd2 = legend({'lower limit','upper limit','trial mean','true mean'},...
    'FontSize',18);
xticks(x);
