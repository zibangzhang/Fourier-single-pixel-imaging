function [ existence ] = isVectorInMat( vector, mat )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
mRow = size(mat, 1);
pz  = ones(mRow, 1) * vector - mat;
existence = logical(size(find(sum(abs(pz)')' == 0), 1)); % �ж��������A�д���c����panding=1��
end

