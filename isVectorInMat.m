function [ existence ] = isVectorInMat( vector, mat )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
mRow = size(mat, 1);
pz  = ones(mRow, 1) * vector - mat;
existence = logical(size(find(sum(abs(pz)')' == 0), 1)); % 判定结果，若A中存在c，则panding=1；
end

