function [img, spec] = getFSPIReconstruction( I, nStepPS, Phaseshift )
% Phase-shifting formulae
if and(nStepPS == 4, Phaseshift == 90)
    % Assumption: I1 -> 0, I2 -> pi, I3 -> pi/2, I4 -> 3pi/2 !!!
    spec = (I(:,:,1)-I(:,:,2))+1i*(I(:,:,3)-I(:,:,4));
end

if and(nStepPS == 3, Phaseshift == 120)
    % Assumption: I1 -> 0, I2 ->
    spec = (2*(I(:,:,1))-I(:,:,2)-I(:,:,3)) + sqrt(3)*1i*(I(:,:,2)-I(:,:,3));
    spec = 2 * spec / 3;
end

if and(nStepPS == 3, Phaseshift == 90)
    % Assumption: I1 -> 0, I2 ->
    spec = ((I(:,:,3))-I(:,:,2)) + 1i*(2*I(:,:,1)-I(:,:,2)-I(:,:,3));
    %         spec  = spec / 2;
end

spec = completeSpec(spec);
img  = real(ifft2(ifftshift(spec)));
end

function fullSpec = completeSpec(halfSpec)
% Complete a Fourier spectrum with central symmetry
[mRow, nCol] = size(halfSpec);
fullSpec = zeros(size(halfSpec));

if mod(mRow,2) == 1 && mod(nCol,2) == 1 % nPixel is odd
    halfSpec = halfSpec + rot90(conj(halfSpec), 2);
    halfSpec(ceil(mRow/2),ceil(nCol/2)) = (halfSpec(ceil(mRow/2),ceil(nCol/2)))/2;
    fullSpec = halfSpec;
else
    if mod(mRow, 2) == 0 && mod(nCol, 2) == 0                   % Even * Even
        RightBottomHalfSpec = halfSpec(2:end, 2:end);
        RightBottomFullSpec = completeSpec(RightBottomHalfSpec);
        
        fullSpec(2:end, 2:end) = RightBottomFullSpec;
        
        TopLine = halfSpec(1, 2:end);
        TopLine = completeSpec(TopLine);
        fullSpec(1, 2:end) = TopLine;
        
        LeftColumn = halfSpec(2:end, 1);
        LeftColumn = completeSpec(LeftColumn);
        fullSpec(2:end, 1) = LeftColumn;
        
        fullSpec(1,1) = halfSpec(1,1);
    else
        if mod(mRow, 2) == 1 && mod(nCol, 2) == 0   % ODD * EVEN
            LeftColumn = halfSpec(1:end, 1);
            LeftColumn = completeSpec(LeftColumn);
            
            RightHalfSpec = halfSpec(:, 2:end);
            RightFullSpec = completeSpec(RightHalfSpec);
            
            fullSpec(1:end, 1) = LeftColumn;
            fullSpec(:, 2:end) = RightFullSpec;
        else                                         % EVEN * ODD
            halfSpec = halfSpec';
            fullSpec = completeSpec(halfSpec);
            fullSpec = fullSpec';
        end
        
    end
end
end

