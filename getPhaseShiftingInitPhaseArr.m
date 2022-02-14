function InitPhaseArr = getPhaseShiftingInitPhaseArr(nStep, phaseshift)
	if and(nStep == 4, phaseshift == 90)
        InitPhaseArr = [0, pi, pi/2, 3*pi/2];
		return;
	end
	
    if and(nStep == 3, phaseshift == 120)
        InitPhaseArr = [0, 2*pi/3, 4*pi/3];
		return;
	end
	
    if and(nStep == 3, phaseshift == 90)
        InitPhaseArr = [0, pi/2, -pi/2];
		return;
    end
    
    if and(nStep == 2, phaseshift == 90)
        InitPhaseArr = [0, pi/2];
		return;
    end
    
	
	error('No corresponding initial phase array found!');
end