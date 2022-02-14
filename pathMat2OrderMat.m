function OrderMat = pathMat2OrderMat(PathMat)
[mRow,nCol] = size(PathMat);
Mask = getHalfFourierMask(mRow, nCol);

PathMatMasked = PathMat .* Mask;
PathMatMaskedArr = reshape(PathMatMasked, [length(PathMatMasked(:)) 1]);
[Val, Ind] = sort(PathMatMaskedArr,  'ascend');

FirstNonZeroElement = find(Val~=0);
FirstNonZeroElementInd = FirstNonZeroElement(1);
Ind = Ind(FirstNonZeroElementInd:end);

nPoint = length(Ind);
OrderMat = zeros(nPoint, 2);

for iPoint = 1:nPoint
    OrderMat(iPoint,2) = floor(Ind(iPoint) / mRow) + 1;
    OrderMat(iPoint,1) = mod(Ind(iPoint)- 1, mRow) + 1;
end

end
