function InitPhaseArr = getPhaseShiftingInitPhaseArr(nStep)
%InitPhaseArr = getPhaseShiftingInitPhaseArr (nStepPS, Phaseshift);  	
    InitPhaseArr = [0:nStep-1]*2*pi/nStep;
end