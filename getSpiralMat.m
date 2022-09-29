%% GENERATE THE PATH MATRIX -> orderMat
% Revised on 2016/06/23 by Charles Cheung
% Revised on 2021/09/25 by Zibang Zhang (Charles Cheung)
% nPixel can be odd or even.
function spiralMat = getSpiralMath(mRow, nCol)
if mRow > nCol
    nPixel = mRow;
else
    nPixel = nCol;
end

spiralMat = rot90(spiral(nPixel),2); % the ratotation keeps the origin at right down side of the center

% Resizing
spiralMat = imresize(spiralMat, [mRow nCol], 'nearest');

%% Reorder
[spiralMatValSorted, spiralMatValSortedInd] = sort(spiralMat(:));

if length(unique(spiralMatValSorted)) ~= mRow*nCol
    error('Error occured in spiral path generation. \n length(unique(spiralMatValSorted)) ~= mRow*nCol');
end

SpiralPath1D = zeros(mRow * nCol, 1);
for iElement = 1:mRow*nCol
    SpiralPath1D(spiralMatValSortedInd(iElement)) = iElement;
end

spiralMat = reshape(SpiralPath1D, [mRow nCol]);

end
