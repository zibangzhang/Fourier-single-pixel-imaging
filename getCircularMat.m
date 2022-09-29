%% By Zibang Zhang
% Initialized on XX/XX/XXXX
% Revised on 25/09/2021. mRow ~= nCol supported
% Revised on 14/02/2022. rewritten, much faster, simplier

function [ CircularMat ] = getCircularMat( mRow, nCol)
xArr = [1:nCol]/nCol;
yArr = [1:mRow]/mRow;

CenterX = xArr(floor(nCol/2) + 1);
CenterY = yArr(floor(mRow/2) + 1);

[xGrid, yGrid] = meshgrid(xArr, yArr);

xGrid = xGrid - CenterX;
yGrid = yGrid - CenterY;

[thetaGrid, rhoGrid] = cart2pol(xGrid, yGrid);

WeightGrid = 10000 * rhoGrid + thetaGrid;
[Val, Ind] = sort(WeightGrid(:));

CircularMat = zeros(mRow,nCol);
for index = 1:mRow*nCol
   CircularMat(Ind(index)) = index;    
end