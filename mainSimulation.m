%% Initialied on 2013/10/28
% Rev 1: 2015/1/22 by Charles Cheung
% Rev 2: 2016/6/23 by Charles Cheung
% Rev 3: 2016/12/25 by Charles Cheung
% Rev 4: 2021/09/25 by Charles Cheung
% Rev 5: 2022/02/14 by Charle Cheung. 
% Optimized the generation of circular path

%% simulating single-pixel imaging with phase-shifting sinusoid illumination
close all
clear
clc
TimeStamp = datestr(now, 'YYmmDD_HHMMSS');

%% SWITCH
SW_ENCRYPTION = 0;      
SW_NOISE = 0;     

%% Parameters
nStepPS = 3;                % N-step phase shifts
Phaseshift = 120;            % phase shift
SamplingRatio = 1;       % formerly, spectral coverage

% Get input image
[FileName, FolderName] = uigetfile({'*.bmp;*.jpg;*.tif;*.png;*.gif'','...
    'All Image Files';'*.*','All Files'});
SamplingPath = 'circular';  % circular, spiral


%% 
InputImg = im2double(imread(fullfile(FolderName, FileName)));
figure,imshow(InputImg);title('Input image'); axis image;

[mRow, nCol] = size(InputImg);
[fxMat, fyMat] = meshgrid([0:1:nCol-1]/nCol, [0:1:mRow-1]/mRow);

fxMat = fftshift(fxMat);
fyMat = fftshift(fyMat);

% Get the order matrix
OrderMat = getOrderMat(mRow, nCol, 'circular');

% Get the path matrix
nCoeft = round(size(OrderMat, 1) * SamplingRatio);

InitPhaseArr = getPhaseShiftingInitPhaseArr (nStepPS, Phaseshift);
MeasurementMat = zeros(mRow, nCol, nStepPS);

RealFourierCoeftList = getRealFourierCoeftList(mRow, nCol);

if SW_NOISE
    ReponseNoise = rand(nCoeft * nStepPS) * 2;              % random noise generation
end
    
MeasurementArr = zeros(nCoeft * nStepPS, 1);                  % measurements

iMeasurement = 1;
tic;
for iCoeft = 1:nCoeft
    iRow = OrderMat(iCoeft,1);
    jCol = OrderMat(iCoeft,2);
    
    fx = fxMat(iRow,jCol);
    fy = fyMat(iRow,jCol);

    IsRealCoeft = isVectorInMat( [iRow jCol], RealFourierCoeftList );
    
     for iStep = 1:nStepPS
        if IsRealCoeft == 1 && iStep > 2
            if nStepPS == 3
                MeasurementMat(iRow,jCol,iStep) = MeasurementMat(iRow,jCol,2);
            end
            
            if nStepPS == 4
                MeasurementMat(iRow,jCol,iStep) = 0;
            end
            
            continue;
        end
        
        [ Pattern ] = getFourierPattern( 1, mRow, nCol, fx, fy, InitPhaseArr(iStep) );
        
        if SW_ENCRYPTION
            Pattern = Encode(Pattern, key);
        end
        
        ResponseVal =  sum(sum( Pattern .* InputImg ));

        if SW_NOISE
            ResponseVal = ResponseVal + ReponseNoise(iMeasurement);        % add noise to measurements
        end
           
        MeasurementMat(iRow,jCol,iStep) = ResponseVal;
        MeasurementArr(iMeasurement) = ResponseVal;

        iMeasurement = iMeasurement + 1;
    end
end

toc;

[img, spec] = getFSPIReconstruction( MeasurementMat, nStepPS, Phaseshift );
MeasurementArr = MeasurementArr(1 : iMeasurement-1);

figure, imagesc(img); caxis([0 1]); axis image; colormap gray; title('Reconstructed Img');
figure, specshow(spec);

if SW_ENCRYPTION
    img = Encode(img, key);
    figure, imagesc(img); axis image; colormap gray; title('Reconstructed Decoded Img');
end

PSNR = psnr(img, InputImg);
SSIM = ssim(img, InputImg);
RMSE = rmse(InputImg, img);

fprintf('PNSR = %f\nSSIM = %f\nRMSE = %f\n', PSNR, SSIM, RMSE);

%% Saving results
ErrorImg = InputImg - img;
figure, imagesc(ErrorImg); axis image; colormap jet; colorbar; title('error image');

TrueSpec = fftshift(fft2(InputImg));

SpecAbsDiff = abs(spec) - abs(TrueSpec);
SpecRealDiff = real(spec) - real(TrueSpec);
SpecImagDiff = imag(spec) - imag(TrueSpec);

figure, imagesc(SpecAbsDiff); axis image; colormap jet; title('spec abs diff'); colorbar;
figure, imagesc(SpecRealDiff); axis image; colormap jet; title('spec real diff'); colorbar;
figure, imagesc(SpecImagDiff); axis image; colormap jet; title('spec imag diff'); colorbar;

ResultFolderName = sprintf('[%s]FSI_Simulation_mRow=%d_nCol=%d_nStep=%d_PS=%d', TimeStamp, mRow, nCol, nStepPS, Phaseshift);

mkdir(ResultFolderName);
ResultFileName = 'results.mat';
ResultFilePath = fullfile(ResultFolderName, ResultFileName);
save(ResultFilePath);