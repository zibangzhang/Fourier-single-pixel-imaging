function [ CircularPath ] = CircularPath( mRow, nCol, CenterX, CenterY, Radius )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    % if radius is not a positive number, the code will generate a circular
    % path full of a matrix
    
    % Check pre-generated data
    PreGeneratedDataFileName = sprintf('CircularPath_%d_%d_%d_%d_%d.mat', mRow, nCol, CenterX, CenterY, Radius');
    if exist(PreGeneratedDataFileName, 'file')
        load(PreGeneratedDataFileName);
        return;
    end
    

    Center2TopDistance = abs(CenterY - 1 + 1) ;
    Center2BottomDistance  = abs(CenterY - mRow + 1);
    Center2LeftDistance = abs(CenterX - 1 + 1);
    Center2RightDistance = abs(CenterX - nCol + 1);
    
    MaxDistanceX = max([Center2LeftDistance Center2RightDistance]);
    MaxDistanceY = max([Center2TopDistance Center2BottomDistance]);
    
    FullRadius = round(sqrt((MaxDistanceX+1).^2  + (MaxDistanceY+1) .^ 2));
    
    [CenteredCircularPath, CenteredCircularCX, CenteredCircularCY] = getCenteredCircularPath(FullRadius);
    
    [MROW, NCOL] = size(CenteredCircularPath);
    yArr = [1:MROW];
    xArr = [1:NCOL];
    [xGrid, yGrid] = meshgrid(xArr, yArr);
    
    if Radius > 0
        CenteredCircularPath((xGrid - CenteredCircularCX).^2 + ...
                             (yGrid - CenteredCircularCY).^2 > Radius^2) = 0;
    end
    
    %% Cropping
    CircularPath = CenteredCircularPath;
    CircularPath = CircularPath(CenteredCircularCX - (CenterX - 1) : CenteredCircularCX - (CenterX - 1) + nCol - 1, :);
    CircularPath = CircularPath(:, CenteredCircularCY - (CenterY - 1) : CenteredCircularCY - (CenterY - 1) + mRow - 1);
    
    %% Reorder
    minValue = min(min(CircularPath));
    maxValue = max(max(CircularPath));
    
    CircularPathEmpty = zeros(mRow, nCol);
    count = 1;
    for iValue = minValue:maxValue
        [iRow, jCol] = find(CircularPath == iValue);
        if ~isempty([iRow, jCol])
            CircularPathEmpty(iRow, jCol) = count;
            count = count + 1;
        end
    end
    CircularPath = CircularPathEmpty;
    
    save(PreGeneratedDataFileName, 'CircularPath');
    %% Debug
%     figure, imagesc(CircularPath); axis image; colormap jet;
end

function [CenteredCircularPath, CenteredCircularCX, CenteredCircularCY] = getCenteredCircularPath(Radius)
mRow = 2 * Radius + 3;
nCol = mRow;

CenteredCircularCX = round(mRow/2);
CenteredCircularCY = round(nCol/2);

% mask = zeros(mRow,nCol);
% 
% count = 1;
% for iRad = 0:Radius
%     theta = 0;
%     dTheta = 2*pi/(2*4*(iRad*2+1)-4);
%     
%     while(theta < 2*pi)
%         jCol = round(CenteredCircularCY + iRad*cos(theta));
%         iRow = round(CenteredCircularCX + iRad*sin(theta));
%         
%         
%         if mask(iRow,jCol)~=0
%             theta = theta + dTheta;
%             continue;
%         end
%         
%         
%         mask(iRow,jCol) = count;
%         count = count + 1;
%     end
% end
% CenteredCircularPath = mask;

% CenteredCircularPath = spiral(mRow);
% xArr = [1:nCol];
% yArr = [1:mRow];
% [xGrid, yGrid] = meshgrid(xArr, yArr);
% CenteredCircularPath( (xGrid - CenteredCircularCY).^2  + (yGrid - CenteredCircularCX).^2 >  Radius^2 ) = 0;

xArr = [1:nCol];
yArr = [1:mRow];
[xGrid, yGrid] = meshgrid(xArr, yArr);

xGrid = xGrid - CenteredCircularCX;
yGrid = yGrid - CenteredCircularCY;

[thetaGrid, rhoGrid] = cart2pol(xGrid, yGrid);

rhoGridArr = sort(unique(rhoGrid(:)));
thetaGridArr = sort(unique(thetaGrid(:)));

CenteredCircularPath = zeros(mRow, nCol);
flagMat = zeros(mRow, nCol);
count = 1;
for iRho = 1:length(rhoGridArr)
    thisRho = rhoGridArr(iRho);
    thetaArr = sort(unique(thetaGrid(rhoGrid == thisRho)));
    
    for itheta = 1:length(thetaArr)
       [jCol, iRow] = pol2cart(thetaArr(itheta), thisRho);
       jCol = round(jCol) + CenteredCircularCY;
       iRow = round(iRow) + CenteredCircularCX;
       if flagMat(iRow, jCol) == 0
           CenteredCircularPath(iRow, jCol) = count;
           count = count + 1;
       end
   end
end

end

