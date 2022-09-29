%% GENERATE THE PATH MATRIX -> orderMat
% Rev 1: 2016/06/23 by Charles Cheung
% Rev 2: 2021/09/25 by Charles Cheung

function OrderMat = getOrderMat(mRow, nCol, PathStr)
switch PathStr
case 'spiral'
	[PathMat] = getSpiralMat(mRow, nCol);
case 'circular'
	[PathMat] = getCircularMat(mRow, nCol);
otherwise
	error('Unsupported sampling path %s\n', PathStr);
end

OrderMat = pathMat2OrderMat(PathMat);

